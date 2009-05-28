Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZE1XPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZE1XPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZE1XPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:15:38 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:41573 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZE1XPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:15:37 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Pavel Machek <pavel@ucw.cz>
Subject: [Futex RFC] was Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Thu, 28 May 2009 18:15:34 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Harald Welte <HaraldWelte@viatech.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090528203022.GB1290@ucw.cz> <200905281555.00245.lkml@morethan.org>
In-Reply-To: <200905281555.00245.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281815.36728.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 28 2009, Michael S. Zick wrote:
> On Thu May 28 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > @hpa - I still like your suggestion that it is only one (or a few)
> > > > uses of atomic ops that is incorrect and in general atomic ops
> > > > should compile away on uni-processor.
> > > > 
> > > 
> > > Actually, the more I think about it the more I suspect there is a race
> > > condition either in the chip set or in any VIA-specific drivers (if
> > > there are any.)  Putting LOCKs in random places will slow the CPU down
> > > significantly, so it might resolve the race condition without actually
> > > solving the problem.
> > 
> > Which you can verify; replace lock with something slow (pushad,
> > popad)? And see what happens.
> > 
> > (And if it never ever triggers on hp2133, you have strong clue that it
> > may not be cpu-related, but bios-related or chipset related or something).
> > 
> > Some time ago I was trying to debug misterious hangs on some
> > via/fic machines. 
> > 
> > We never figured out what was wrong, but we discovered many other bios
> > bugs, and those were not being fixed; so debugging was
> > hard/impossible. Unfortunately I no longer have access to that hw.
> > 
> 
> Then I am not losing my mind here - *it is* a difficult problem.  ;)
> 
> > hp2133 did _not_ have that problem.
> >
> 
> Today's build has been playing me music for over 8 hours on the
> HP-2133 (C7M-CN896) but can't get past a couple of hours on the
> (fic) Everex Cloudbook (C7M-CX700).
> 
> Also, the distro on the Cloudbook is using pulse-audio - the
> distro on the HP is not.  So I am reviewing the recent bug
> fixes to kernel/futex for something over-looked.  ;)
> May be a wild goose chase, but I think pulse-audio uses futexes.
> 

Please, somebody apply an experienced eye-ball to this;
It does seem to make a difference, but tests have not run
for very long yet.

diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index 1f11ce4..da3c801 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -19,7 +19,8 @@
                     "\t.previous\n"                            \
                     _ASM_EXTABLE(1b, 3b)                       \
                     : "=r" (oldval), "=r" (ret), "+m" (*uaddr) \
-                    : "i" (-EFAULT), "0" (oparg), "1" (0))
+                    : "i" (-EFAULT), "0" (oparg), "1" (0)      \
+                    : "memory")

 #define __futex_atomic_op2(insn, ret, oldval, uaddr, oparg)    \
        asm volatile("1:\tmovl  %2, %0\n"                       \
@@ -35,7 +36,8 @@
                     _ASM_EXTABLE(2b, 4b)                       \
                     : "=&a" (oldval), "=&r" (ret),             \
                       "+m" (*uaddr), "=&r" (tem)               \
-                    : "r" (oparg), "i" (-EFAULT), "1" (0))
+                    : "r" (oparg), "i" (-EFAULT), "1" (0)      \
+                    : "memory")


Mike
> Thanks for the other hints.
> 
> Mike 
> > Try forcing maximum throttling, then move mouse for like five
> > seconds. If kbc dies, you have same buggy bios, and probably are
> > debugging same problem....
> > 								Pavel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


