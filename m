Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXECIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXECIhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXECIhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:37:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXECIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DqSn96YVUD/HI+fLmHRK3pobDSwqbE+oVBp3ja5BQeXDY3JQO8lfgxBj9yCbfJAKTybYIHD6s8uLffLRKvd3xGokoF3Y/pqidZDEuNXMD8tM3v/+0wGadxPXpTeGAzX8qBLtMJuQBfc6Kq4QlOtwC2wo3LNlcTFG2hrRtpL3xfQ=
Message-ID: <528646bc0705030137r6e7565c3o1d9ed91fbb3e702f@mail.gmail.com>
Date: Thu, 3 May 2007 02:37:21 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add support for Xilinx SystemACE CompactFlash interface.
Cc: "Jens Axboe" <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20070502004557.6d61b180.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11780881962680-git-send-email-grant.likely@secretlab.ca>
	 <20070502004557.6d61b180.akpm@linux-foundation.org>
X-Google-Sender-Auth: f3d3e0175762eb33
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  2 May 2007 00:43:16 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
> > + * To Do:
> > + *    - Add FPGA configuration control interface.
> > + *    - Request major number from lanana
> > + *    - Add legacy device geometry ioctl
> > + */
>
> Swoon.  Want a job writing kernel comments?

Heh; I don't know, how much does that pain pay?  :-)

> >
> > +static LIST_HEAD(ace_instances);
> > +static int ace_major = 0;
>
> Pleas eremove the "= 0;': it takes up space in vmlinux, but .bss is zeroed
> anyway.

Oops; yes.  I'm waiting on a major number assignment from lanana.
It's supposed to go here.

> > +     void (*out)(struct ace_device *ace, ulong reg, uint16_t val);
> > +     void (*identin)(struct ace_device *ace);
> > +     void (*datain)(struct ace_device *ace);
> > +     void (*dataout)(struct ace_device *ace);
> > +};
> > +
> > +/* 8 Bit bus width */
> > +static uint16_t ace_in_8(struct ace_device *ace, ulong reg)
>
> Here we have the correct `foo *bar';
>
> > +{
> > +     void* r = ace->baseaddr + reg;
>
> And here we have the kernelly-incorrect `foo* bar;'
>
> Please do s/* / */ everywhere.

/me runs entire driver through scripts/Lindent for good measure.

> > +static void ace_identin_8(struct ace_device *ace)
> > +{
> > +     void* r = ace->baseaddr + 0x40;
> > +     int i = ACE_FIFO_SIZE/2;
> > +     while (i--)
> > +#if defined(__BIG_ENDIAN)
> > +             *ace->data_ptr++ = (in_8(r)) | (in_8(r+1)<<8);
> > +#else
> > +             *ace->data_ptr++ = (in_8(r)<<8) | (in_8(r+1));
> > +#endif
> > +}
>
> This ifdeffery appears in several places.  SUggest the addition of a helper
> function which does it in a single place.

It's actually two different things that look very similar, and there
are only 4 tests for __BIG_ENDIAN in the whole driver, and they're all
different.  But the point is moot; I messed up the 8 bit accessors.
It will be reimplemented in the next patch.

> > +{
> > +#ifndef __LITTLE_ENDIAN
> > +# ifdef __BIG_ENDIAN
> > +     /* The ace_reg_read16 macro handles 16 bit reads correctly, but
> > +      * 32bit values are partially little endian; swap the words
> > +      */
> > +     id->lba_capacity   = ((id->lba_capacity >> 16) & 0x0000FFFF) |
> > +                          ((id->lba_capacity << 16) & 0xFFFF0000);
> > +     id->spg            = ((id->spg >> 16) & 0x0000FFFF) |
> > +                          ((id->spg << 16) & 0xFFFF0000);
> > +# else
> > +#  error "Please fix <asm/byteorder.h>"
>
> Don't you trust us? :)

That's what happens when I copy a snippit from another parts of the kernel.  :-P

>
> > +#if defined(DEBUG)
> > +const char* ace_statenames[ACE_FSM_NUM_STATES] = {
> > +     "idle",
> > +     "req lock",
> > +     "wait lock",
> > +     "wait cf ready",
> > +     "identify prepare",
> > +     "identify transfer",
> > +     "identify complete",
> > +     "request prepare",
> > +     "request transfer",
> > +     "request complete",
> > +};
> > +#endif
>
> Can these have static storage class?

Yeah, but I'll just remove them instead

> > +static int ace_release(struct inode *inode, struct file *filp)
> > +{
> > +     struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
> > +     unsigned long flags;
> > +     uint16_t val;
> > +
> > +     ace_dbg(ace, "ace_release() users=%i\n", ace->users-1);
> > +
> > +     spin_lock_irqsave(&ace->lock, flags);
> > +     ace->users--;
> > +     if (ace->users == 0) {
> > +             val = ace_reg_read16(ace, ACE_CTRL);
> > +             ace_reg_write16(ace, ACE_CTRL, val & ~ACE_CTRL_LOCKREQ);
> > +     }
> > +     spin_unlock_irqrestore(&ace->lock, flags);
> > +     return 0;
> > +}
>
> Who owns gendisk.private_data?  Is it the device driver?  I've never
> looked...

gd.private_data points to the struct ace_device; which is freed in ace_remove().

>
> > +static int ace_ioctl(struct inode *inode, struct file *filp,
> > +                         unsigned int cmd, unsigned long arg)
> > +{
> > +     struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
> > +     ace_dbg(ace, "ace_ioctl()\n");
> > +
> > +     return -ENOTTY;
> > +}
>
> I suspect you can just leave this unimplemented.

But keeping it in reminds me that I need to get it done.  :-)  It will
be implemented in the next patch.

> > +     /*
> > +      * Initialize the request queue
> > +      */
> > +     ace->queue = blk_init_queue(ace_request, &ace->lock);
> > +     if (ace->queue == NULL)
> > +             goto err_blk_initq;
> > +     blk_queue_hardsect_size(ace->queue, 512);
> > +
> > +     /*
> > +      * Allocate and initialize GD structure
> > +      */
> > +     ace->gd = alloc_disk(ACE_NUM_MINORS);
> > +     if (!ace->gd)
> > +             goto err_alloc_disk;
> > +
> > +     ace->gd->major = ace_major;
> > +     ace->gd->first_minor = ace->id * ACE_NUM_MINORS;
> > +     ace->gd->fops = &ace_fops;
> > +     ace->gd->queue = ace->queue;
> > +     ace->gd->private_data = ace;
> > +     snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
> > +     device_rename(ace->dev, ace->gd->disk_name);
>
> Now why are we doing a device_rename() here?  The only other caller in the
> tree is the netdev renaming code.  I suspect something is awry here.

Mostly so that the device shows up as '/sys/block/xsa' instead of
'/sys/block/xsysace.0'.  Plus it shows 'xsa' in the log when using
dev_dbg() macros.

I can remove this if this is a bad idea.

>
> Looks nice though.

Thanks for the comments; I'll clean up and resubmit.

Cheers,
g.

-- 
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
