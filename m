Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYCCUwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYCCUwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYCCUwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:52:30 -0500
Received: from xspect.dk ([212.97.129.87]:32820 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYCCUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:52:30 -0500
Date: Mon, 3 Mar 2008 21:52:27 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303205227.GU17932@hjernemadsen.org>
References: <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303174858.GB25496@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 18:48:58 +0100, Ingo Molnar wrote:
> 
> * Klaus S. Madsen <ksm@hjernemadsen.org> wrote:
> 
> > The following patch solves the segfault, by changing the mmap flags of 
> > the video memory area, to allow execution. The patch is against 
> > libx86-0.99 available from http://www.codon.org.uk/~mjg59/libx86/
> > 
> > --- libx86-0.99/x86-common.c	2006-09-08 00:44:27.000000000 +0200
> > +++ libx86-0.99.new/x86-common.c	2008-03-01 10:08:25.000000000 +0100
> > @@ -232,7 +232,7 @@
> >  	}
> >  
> >  	m = mmap((void *)0xa0000, 0x100000 - 0xa0000,
> > -	 PROT_READ | PROT_WRITE,
> > +	 PROT_READ | PROT_WRITE | PROT_EXEC,
> 
> are you sure you ID-ed the right commit that broke things?
I can't be sure. It was my third attempt, and there seems to be some
sort of Makefile trouble in that area, which causes the problem to
appear and disappear at random, unless I do a make clean && make. But
the triggering commit was found with make clean && make, and I made sure
that reverting the resulting commit did actually solve the problem...

However I wasn't able to make the problem go away, by removing the
_PAGE_PWT constants from __PAGE_KERNEL_NOCACHE and
__PAGE_KERNEL_VSYSCALL_NOCACHE in include-asm/pgtable.h in the newest
2.6.25:

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..f81c968 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -84,9 +84,9 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
So while I'm fairly confident in that I bisected correctly, the number
of attempts I had to go through to get a reliable result, and the fact
that I cannot make the problem go away by reverting the current code to
something similar, counts quite a lot against me.

However I'm 100% confident that the problem appears between
cf8fa920cb4271f17e0265c863d64bea1b31941a and
925596a017bbd045ff711b778256f459e50a119, which is something like 16
commits. I have been at both points in the tree at least 2 times, and
confirmed that cf8fa920cb4271f17e0265c863d64bea1b31941a worked for me,
and 925596a017bbd045ff711b778256f459e50a119 didn't.

> while requiring PROT_EXEC is fine, breaking existing user-space apps 
> over that is not fine. So are you absolutely sure that by reverting that 
> PWT|PCD commit, s2ram again starts to work? That's utmost weird...
I'm sure that it fixed the problem for me, yes, and I'm fairly confident
that I ran make clean && make to compile the kernel during the entire
bisection between the two commites mentioned above.

> perhaps there's some CPU bug that causes NX to _NOT_ work if only PCD is 
> used (not PCD|PWT). Seems like a pretty unlikely scenario though.
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
stepping        : 10

But I'm a bit puzzled by the fact that I'm aparently the only one how
have encountered the problem? Maybe it's only a problem if one also uses
PAE? (Thats just a wild guess to explain why I'm the only one seeing
this).

-- 
Kind regards
	Klaus S. Madsen
