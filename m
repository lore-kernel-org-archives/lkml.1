Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbYGAGCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbYGAGCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGAGCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:02:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYGAGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:02:07 -0400
Date: Mon, 30 Jun 2008 23:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HP iLO driver
Message-Id: <20080630230158.97e9d93b.akpm@linux-foundation.org>
In-Reply-To: <20080616140729.GA377@ldl.fc.hp.com>
References: <20080616140729.GA377@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 08:07:29 -0600 David Altobelli <david.altobelli@hp.com> wrote:

> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo/dXccbN), and use this to send/receive queries.  
> The O_EXCL open flag is used to indicate that a particular channel cannot
> be shared between processes.  This driver will replace various packages
> HP has shipped, including hprsm and hp-ilo.
> 
> 	v1 -> v2
> 	Changed device path to /dev/hpilo/dXccbN.
> 	Removed a volatile from fifobar variable.
> 	Changed ILO_NAME to remove spaces.
> 
> Please CC me on any replies, thanks for your time.
> 
>
> ...
>
> +static int ilo_open(struct inode *ip, struct file *fp)
> +{
> +	int slot, error;
> +	struct ccb_data *data;
> +	struct ilo_hwinfo *hw;
> +
> +	slot = iminor(ip) % MAX_CCB;
> +	hw = container_of(ip->i_cdev, struct ilo_hwinfo, cdev);
> +
> +	spin_lock(&hw->alloc_lock);
> +
> +	if (IS_DEVICE_RESET(hw))
> +		ilo_locked_reset(hw);
> +
> +	/* each fd private_data holds sw/hw view of ccb */
> +	if (hw->ccb_alloc[slot] == NULL) {
> +		/* new ccb allocation */
> +		error = -ENOMEM;
> +		data = kzalloc(sizeof(struct ccb_data), GFP_KERNEL);

Doing a GFP_KERNEL allocation inside spin_lock() is a flagrant bug
which would have been detected had you enabled
CONFIG_DEBUG_SPINLOCK_SLEEP (which ia64 appears to support (if this is
an ia64-only driver?)) while testing.

Please see Documentation/SubmitChecklist

Using GFP_ATOMIC would be a poor solution for this - it is unreliable. 
Better would be to speculatively perform the allocation outside the
spinlocked region and then toss it away if you didn't use it:

	p = kmalloc(size, GFP_KERNEL);
	spin_lock();
	if (expr) {
		q = p;
		p = NULL;
	}
	spin_unlock();
	kfree(p);

> +		if (!data)
> +			goto out;
> +
> +		/* create a channel control block for this minor */
> +		error = ilo_ccb_open(hw, data, slot);

That's large but _looks_ OK for called-under-spinlock.

> +		if (error)
> +			goto free;
> +
> +		hw->ccb_alloc[slot] = data;
> +		hw->ccb_alloc[slot]->ccb_cnt = 1;
> +		hw->ccb_alloc[slot]->ccb_excl = fp->f_flags & O_EXCL;
> +		hw->ccb_alloc[slot]->ilo_hw = hw;
> +	} else if (fp->f_flags & O_EXCL || hw->ccb_alloc[slot]->ccb_excl) {
> +		/* either this open or a previous open wants exclusive access */
> +		error = -EBUSY;
> +		goto out;
> +	} else
> +		hw->ccb_alloc[slot]->ccb_cnt++;
> +
> +	spin_unlock(&hw->alloc_lock);
> +
> +	fp->private_data = hw->ccb_alloc[slot];
> +
> +	return 0;
> +free:
> +	kfree(data);
> +out:
> +	spin_unlock(&hw->alloc_lock);
> +	return error;
> +}
> +
> +static const struct file_operations ilo_fops = {
> +	THIS_MODULE,

	.owner = THIS_MODULE

> +	.read		= ilo_read,
> +	.write		= ilo_write,
> +	.open 		= ilo_open,
> +	.release 	= ilo_close,
> +};
> +
> +static void ilo_unmap_device(struct pci_dev *pdev, struct ilo_hwinfo *hw)
> +{
> +	pci_iounmap(pdev, hw->db_vaddr);
> +	pci_iounmap(pdev, hw->ram_vaddr);
> +	pci_iounmap(pdev, hw->mmio_vaddr);
> +}
>
> ...
>
> +#define ENTRY_MASK_QWORDS \
> +	(((1 << ENTRY_BITS_QWORDS) - 1) << ENTRY_BITPOS_QWORDS)
> +#define ENTRY_MASK_DESCRIPTOR \
> +	(((1 << ENTRY_BITS_DESCRIPTOR) - 1) << ENTRY_BITPOS_DESCRIPTOR)
> +
> +#define ENTRY_MASK_NOSTATE (ENTRY_MASK >> (ENTRY_BITS_C + ENTRY_BITS_O))

hm, I spose these make sens as macros.

> +#define GETQWORDS(_e) (((_e) & ENTRY_MASK_QWORDS) >> ENTRY_BITPOS_QWORDS)
> +#define GETDESC(_e) (((_e) & ENTRY_MASK_DESCRIPTOR) >> ENTRY_BITPOS_DESCRIPTOR)

But these could be lower-case inline functions.  Why use pretend
functions when we can use real ones?

> +#define QWORDS(_B) (((_B) & 7) ? (((_B) >> 3) + 1) : ((_B) >> 3))

And this one is buggy - will do weird things if passed an expression
which has side-effects.

General rule: only impement code within macros when macros MUST be used.

> +#endif /* __HPILO_H */
> diff -urpN linux-2.6.25.orig/drivers/char/Kconfig linux-2.6.25/drivers/char/Kconfig
> --- linux-2.6.25.orig/drivers/char/Kconfig	2008-04-30 16:42:55.000000000 -0500
> +++ linux-2.6.25/drivers/char/Kconfig	2008-06-16 08:23:36.000000000 -0500
> @@ -1049,5 +1049,18 @@ config DEVPORT
>  
>  source "drivers/s390/char/Kconfig"
>  
> +config HP_ILO
> +	tristate "Channel interface driver for HP iLO/iLO2 processor"
> +	default n
> +	help
> +	  The channel interface driver allows applications to communicate
> +	  with iLO/iLO2 management processors present on HP ProLiant
> +	  servers.  Upon loading, the driver creates /dev/hpilo/dXccbN files, 
> +	  which can be used to gather data from the management processor,
> +	  via read and write system calls.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called hpilo.
> +	
>  endmenu

OK, so this is available on all architectures?

There are pros and cons.  No avr32 user is likely to use this driver
;), but otoh having it compiled on other architectures can expose
problems.


