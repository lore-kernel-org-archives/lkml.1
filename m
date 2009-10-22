Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZJVOUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZJVOUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZJVOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:20:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49659 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbZJVOUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:20:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <takashi.iwai@gmail.com>
Subject: Re: Problems with string (charp) module parameters
Date: Fri, 23 Oct 2009 00:50:41 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <s5haazv1sw5.wl%tiwai@suse.de> <200910212341.06025.rusty@rustcorp.com.au> <6dc076840910211913l1cf12e82tbb9151da78e41422@mail.gmail.com>
In-Reply-To: <6dc076840910211913l1cf12e82tbb9151da78e41422@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910230050.41790.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 12:43:36 pm Takashi Iwai wrote:
> Hi Rusty,
> 
> (sending from gmail address since VPN doesn't work here in hotel...)
> 
> On Wed, Oct 21, 2009 at 3:11 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Tue, 13 Oct 2009 09:07:46 pm Takashi Iwai wrote:
> >> * The handling of parameter array is pretty buggy now.
> >>   kp->perm and kp->flags aren't properly initialized in
> >>   param_array().  Thus, you might call kfree() with invalid pointers,
> >>   or pass a wrong type for bool.
> >
> > Yes, an array of charp isn't going to work.  Erk, I switched one bug for
> > another :(
> >
> >> So, the situation looks messy right now, not only about the section
> >> issue.  If we allow kmalloc of each parameter array element, the flag
> >> must be associated to each element, not a global one to the array.
> >>
> >> Thoughts?
> >
> > Yes, that's hard.  There's only one place which currently has a writable
> > array parameter: drivers/usb/atm/ueagle-atm.c, and it's root only.
> >
> > OK, for 2.6.32, we remove the const.  In the longer term, I'm reworking how
> > this is done entirely.
> 
> As far as I checked, removing only const doesn't suffice on x86.
> The problem is rather the __param section assignment.
> We'd need to get rid of that, too, if we keep the code in the current way.

Something like this?

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -147,6 +147,10 @@
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
 	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___param) = .;				\
+	*(__param)							\
+	VMLINUX_SYMBOL(__stop___param) = .;				\
+	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
@@ -336,15 +340,7 @@
 		MEM_KEEP(init.rodata)					\
 		MEM_KEEP(exit.rodata)					\
 	}								\
-									\
-	/* Built-in module parameters. */				\
-	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__start___param) = .;			\
-		*(__param)						\
-		VMLINUX_SYMBOL(__stop___param) = .;			\
-		. = ALIGN((align));					\
-		VMLINUX_SYMBOL(__end_rodata) = .;			\
-	}								\
+	VMLINUX_SYMBOL(__end_rodata) = .;				\
 	. = ALIGN((align));
 
 /* RODATA & RO_DATA provided for backward compatibility.


This would work for 2.6.32, for 2.6.33 I have a different solution.

> It's not only for avoiding the mess to separate static and kmalloc
> strings but also for
> avoiding races between the referrer and the sysfs-write of char
> pointer.  (In general, we
> have no lock for parameters.)

Good point.  We should use rcu here.  But there's still a race with copying
in strings of any kind.

> As you pointed out, there are no many users of writable charp parameters.
> So, replacing is easy task.  In that way, we can keep struct
> kernel_parameter as const
> gracefully without hustling any big code change.

But we'd need to make sure noone adds one in future.  After all, you tried
to add one and found this problem!

I'll post my current patch series: it needs testing, but I'd appreciate
your thoughts.

Thanks!
Rusty.
