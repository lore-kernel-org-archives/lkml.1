Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXJBIgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXJBIgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXJBIgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:36:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7346 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXJBIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:36:05 -0400
Date: Tue, 2 Oct 2007 10:37:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Message-ID: <20071002083758.GD5236@kernel.dk>
References: <20071002073943.GC5236@kernel.dk> <200710021015.33203.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710021015.33203.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02 2007, Arnd Bergmann wrote:
> On Tuesday 02 October 2007, Jens Axboe wrote:
> > 
> > The layout of struct blk_user_trace_setup is a bit unfortunate, it gets
> > padded differently on 32-bit and 64-bit archs. So right now it's not
> > possible to trace 64-bit kernels with a 32-bit app. This patch fixes
> > that up by adding a compat ioctl handler for BLKTRACESETUP.
> 
> actually, I would guess that it is currently working on s390, sparc64,
> powerpc, parisc and mips, but your patch breaks it :(.

Not so good. But how could it work on the above archs, surely the
padding (and thuse resulting size of the structure) is different?

> > diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> > index 5a5b711..b18b9cc 100644
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> 
> I'd prefer to not add anything to fs/compat_ioctl.c at all, but always
> handle these in the places where the native version is handled.

Fine with me.

> In your case, I'd either mark BLKTRACESETUP32 as COMPATIBLE_IOCTL() and
> handle it from inside of blk_trace_ioctl(), or handle it in
> compat_blkdev_ioctl.

OK

> > @@ -2052,6 +2052,51 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
> >          }
> >          return ret;
> >  }
> > +
> > +struct blk_user_trace_setup32 {
> > +	char name[32];
> > +	u16 act_mask;
> > +	u16 pad;
> > +	u32 buf_size;
> > +	u32 buf_nr;
> > +	u64 start_lba;
> > +	u64 end_lba;
> > +	u32 pid;
> > +} __attribute__((packed));
> 
> Errm, no. Everyone makes that mistake once, so you're in good company,
> but the packed attribute makes this incorrect on every architecture
> except x86_64 and ia64, because only i386 has no padding before the u64
> and after the last member.
> 
> We now have the compat_u64 type that behaves like the 32 bit user space
> version of an unsigned long long. If you use that to define 
> compat_blk_user_trace_setup, you don't need the attribute.

And ditto for u16 and u32, I gather? If you notice, it's not padding in
front of the u64 that bites me here, it's before the u32.

> > +#define BLKTRACESETUP32 _IOWR(0x12,115,struct blk_user_trace_setup32)
> > +
> > +static int blktrace32_setup(int fd, unsigned cmd, unsigned long arg)
> 
> The naming convention these days is to use a 'compat_' prefix, not a '32'
> postfix.

OK, I will adapt.

> > +{
> > +	struct blk_user_trace_setup __user *buts = compat_alloc_user_space(sizeof(*buts));
> > +	struct blk_user_trace_setup32 __user *buts32 = compat_ptr(arg);
> > +	int err;
> > +
> > +	if (copy_in_user(&buts->name, &buts32->name, BDEVNAME_SIZE) ||
> > +	    get_user(buts->act_mask, &buts32->act_mask) ||
> > +	    get_user(buts->buf_size, &buts32->buf_size) ||
> > +	    get_user(buts->buf_nr, &buts32->buf_nr) ||
> > +	    get_user(buts->start_lba, &buts32->start_lba) ||
> > +	    get_user(buts->end_lba, &buts32->end_lba) ||
> > +	    get_user(buts->pid, &buts32->pid))
> > +		return -EFAULT;
> > +
> > +	err = sys_ioctl(fd, BLKTRACESETUP, (unsigned long) buts);
> > +	if (err)
> > +		return err;
> > +
> > +	if (copy_to_user(&buts32->name, &buts->name, BDEVNAME_SIZE) ||
> > +	    put_user(buts32->act_mask, &buts->act_mask) ||
> > +	    put_user(buts32->buf_size, &buts->buf_size) ||
> > +	    put_user(buts32->buf_nr, &buts->buf_nr) ||
> > +	    put_user(buts32->start_lba, &buts->start_lba) ||
> > +	    put_user(buts32->end_lba, &buts->end_lba) ||
> > +	    put_user(buts32->pid, &buts->pid))
> > +		return -EFAULT;
> > +
> > +	return err;
> 
> Most of these fields are read-only for the kernel, so you should only need
> the first copy_to_user. I think you should split the blk_trace_setup function
> to have the common code take a struct blk_user_trace_setup kernel pointer,
> and one or two versions that just do the copy_{to,from}_user.

I was pretty sure that we modified start_lba and end_lba and copied
those back as well, so it was a conscious decision to just copy
everything for safety. But checking we only do mangle and copy back
->name, so your suggestion is a good one.

-- 
Jens Axboe

