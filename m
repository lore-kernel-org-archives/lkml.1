Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZFBIzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZFBIzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZFBIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:55:30 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:57297
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753810AbZFBIz3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:55:29 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R98dR1805M873fnzz1202hzzz32i6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKLSS7-02-48D-01
Date: Tue, 2 Jun 2009 10:55:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] dma-debug: add debugfs file for driver filter
Message-ID: <20090602085519.GL4062@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com> <1243523971-12681-3-git-send-email-joerg.roedel@amd.com> <20090601150418.79dfd250.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090601150418.79dfd250.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Jun 2009 08:55:19.0487 (UTC) FILETIME=[DB2604F0:01C9E35F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 03:04:18PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 17:19:29 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the dma-api/driver_filter file to debugfs. The root user
> > can write a driver name into this file to see only dma-api errors for
> > that particular driver in the kernel log. Writing an empty string to
> > that file disables the driver filter.
> > 
> >
> > ...
> >
> > +static ssize_t filter_read(struct file *file, char __user *user_buf,
> > +			   size_t count, loff_t *ppos)
> > +{
> > +	unsigned long flags;
> > +	char buf[NAME_MAX_LEN + 1];
> > +	int len;
> > +
> > +	if (!current_driver_name[0])
> > +		return 0;
> > +
> > +	/*
> > +	 * We can't copy to userspace directly because current_driver_name can
> > +	 * only be read under the driver_name_lock with irqs disabled. So
> > +	 * create a temporary copy first.
> > +	 */
> > +	read_lock_irqsave(&driver_name_lock, flags);
> > +	strncpy(buf, current_driver_name, NAME_MAX_LEN - 1);
> 
> If you use strlcpy() here,
> 
> > +	read_unlock_irqrestore(&driver_name_lock, flags);
> > +
> > +	/* make it look nice :-) */
> > +	len = strnlen(buf, NAME_MAX_LEN - 1);
> > +	buf[len]     = '\n';
> > +	buf[len + 1] = 0;
> 
> the above can all be replaced with a simple strcat().  I think.

Right, thanks.

> Perhaps the whole lot can be replaced with a single scnprintf(), if
> it's known that the input string has appropriate length.

I will check that. Thanks.

> > +	return simple_read_from_buffer(user_buf, count, ppos, buf, len + 1);
> > +}
> > +
> > +static ssize_t filter_write(struct file *file, const char __user *userbuf,
> > +			    size_t count, loff_t *ppos)
> > +{
> > +	unsigned long flags;
> > +	char buf[NAME_MAX_LEN];
> > +	size_t len = NAME_MAX_LEN - 1;
> > +	int i;
> > +
> > +	/*
> > +	 * We can't copy from userspace directly. Access to
> > +	 * current_driver_name is protected with a write_lock with irqs
> > +	 * disabled. Since copy_from_user can fault and may sleep we
> > +	 * need to copy to temporary buffer first
> > +	 */
> > +	len = min(count, len);
> > +	if (copy_from_user(buf, userbuf, len))
> > +		return -EFAULT;
> > +
> > +	buf[NAME_MAX_LEN - 1] = 0;
> 
> Might be able to use strncpy_from_user() here.
> 
> > +	write_lock_irqsave(&driver_name_lock, flags);
> > +	if (!isalnum(buf[0])) {
> > +		if (current_driver_name[0])
> > +			printk(KERN_INFO "DMA-API: switching off dma-debug "
> > +					 "driver filter\n");
> > +		current_driver_name[0] = 0;
> > +		current_driver = NULL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	for (i = 0; i < NAME_MAX_LEN; ++i) {
> > +		current_driver_name[i] = buf[i];
> > +		if (isspace(buf[i]) || buf[i] == ' ' ||
> > +		    buf[i] == '\t' || buf[i] == 0)
> > +			break;
> > +	}
> > +	current_driver_name[i] = 0;
> > +	current_driver = NULL;
> > +
> > +	printk(KERN_INFO "DMA-API: enable driver filter for driver [%s]\n",
> > +	       current_driver_name);
> > +
> > +out_unlock:
> > +	write_unlock_irqrestore(&driver_name_lock, flags);
> > +
> > +	return count;
> > +}
> 
> It's unobvious what user interface this code is attempting to implement.
> The change to DMA-API.txt in the fourth patch doesn't illuminate the
> issue either. Some code comments explaining wtf this is doing and why
> would help, please.

It implements a file to which the name of a driver can be written. If
done, dma-debug will only print errors from that particular driver. I
will state that also in a comment.

> I'd have thought that the test for isspace() makes the tests for ' '
> and '\t' redundant?

Checking again, this is true for '\t' but not for ' '. The later one
would be checked by isblank() which is not implemented in the kernel.


Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

