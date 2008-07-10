Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYGJBZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYGJBZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGJBZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:25:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbYGJBZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:25:00 -0400
Date: Wed, 9 Jul 2008 18:18:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, tony.camuso@hp.com
Subject: Re: [PATCH][v5] HP iLO driver
Message-Id: <20080709181857.4a38b920.akpm@linux-foundation.org>
In-Reply-To: <20080702153853.GA18049@ldl.fc.hp.com>
References: <20080702153853.GA18049@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 09:38:53 -0600 David Altobelli <david.altobelli@hp.com> wrote:

> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo/dXccbN), and use this to send/receive queries.  
> The O_EXCL open flag is used to indicate that a particular channel cannot
> be shared between processes.  This driver will replace various packages
> HP has shipped, including hprsm and hp-ilo.
> 
> 	v4 -> v5
> 	Converted more macros to inline functions
> 	Reorganized to remove kzalloc under spinlock
> 
> 	v3 -> v4
> 	Removed an upper case variable and some extra parens
> 	Converted some macros to inline functions
> 
> 	v2 -> v3
> 	Moved code from drivers/char to drivers/misc
> 
> 	v1 -> v2
> 	Changed device path to /dev/hpilo/dXccbN.
> 	Removed a volatile from fifobar variable.
> 	Changed ILO_NAME to remove spaces.
> 
>
> ...
>
> +static ssize_t ilo_write(struct file *fp, const char __user *buf,
> +			 size_t len, loff_t *off)
> +{
> +	int err, pkt_id, pkt_len;
> +	struct ccb_data *data;
> +	struct ccb *driver_ccb;
> +	struct ilo_hwinfo *hw;
> +	void *pkt;
> +
> +	data = fp->private_data;
> +	driver_ccb = &data->driver_ccb;
> +	hw = data->ilo_hw;
> +
> +	if (is_device_reset(hw) || is_channel_reset(driver_ccb)) {
> +		/*
> +		 * If the device has been reset, applications
> +		 * need to close and reopen all ccbs.
> +		 */
> +		ilo_reset(hw);
> +		return -ENODEV;
> +	}

Can multiple processes open and write to this "device"?  If so, the above
looks awfully racy.  Perhaps vfs-level i_mutex coverage will save us on the
write-versus-write side, but not on write-versus-read.


