Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbXFZRiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbXFZRiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbXFZRiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:38:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52071 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbXFZRiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:38:04 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070626170622.GA13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
	 <1182855427.12109.203.camel@pmac.infradead.org>
	 <20070626170622.GA13886@enneenne.com>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 18:38:40 +0100
Message-Id: <1182879520.3263.19.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 19:06 +0200, Rodolfo Giometti wrote:
> On Tue, Jun 26, 2007 at 11:57:07AM +0100, David Woodhouse wrote:
> > 
> > Your syscalls blindly dereference userspace pointers instead of using
> > copy_{to,from} user.
> 
> I use access_ok() to test userspace addresses. It should be ok,
> shouldn't it?

No; it's racy. You must use copy_from_user() and copy_to_user().

> > Why did you split all your syscalls into two functions?
> > 
> > s/__FUNCTION__/__func__/
> 
> Just for an easy management of mutex locking.

That sounds like you're scared of using goto. Don't be :)

> > s/antennas/antennae/
> 
> Done. However I found other files in the kernel code with the same
> error... ;)

This is often true of anything which gets pointed out during review. :)

> > You seem to have added debugging messages mentioning 'serial8250' into
> > serial_core.h
> 
> Yes! Fixed.
> 
> > You added <linux/pps.h> with #ifdef __KERNEL__ in it, but didn't export
> > it to userspace. Why?
> 
> This file is called by timepps.h who exports the userland data.

I don't see this timepps.h of which you speak. If it's a _userspace_
file, it cannot include <linux/pps.h> unless you actually add
<linux/pps.h> to the list of files which are exported.

Run 'make headers_install' and observe that there is no file
usr/include/linux/pps.h -- so there would be no /usr/include/linux/pps.h
generated from your kernel tree. You need to add 'unifdef-y += pps.h' to
include/linux/Kbuild for that to happen.

> > Your structures for userspace communication look OK -- I don't think you
> > need special 32/64 compatibility for them. You do need it for the
> > 'struct timespec' in sys_time_pps_fetch() though.
> 
> Mmm... can you please explain a bit what do you mean? Maybe just a
> link...

64-bit kernels can run 32-bit userspace programs. But some structures
come out _differently_ between 32-bit and 64-bit compilation, so the
system call needs a special 'compat' handler instead of just running the
normal 64-bit system call.

The 'struct timespec' is one structure which is sometimes different for
32-bit vs. 64-bit, so any system call taking a 'struct timespec' must
have a separate compat_sys_xxxx() to handle that. See something like
compat_sys_clock_settime() in kernel/compat.c for an example (but don't
use set_fs() like it does; just see how it handles the compat_timespec).

> > Must we have the ioctl-like interface to sys_time_pps_cmd()? If the
> 
> It seems to me stronger then other solutions...
> 
> > second argument is always 'struct pps_source_data_s *', why does the
> > syscall pretend it's 'void *'?
> 
> Just to keep sys_time_pps_cmd() generic for future new commands.

Hm. I'll let other people complain at you about that :)

-- 
dwmw2

