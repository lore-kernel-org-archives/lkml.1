Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbYCCVGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbYCCVGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYCCVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:06:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60718 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYCCVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:06:19 -0500
Date: Mon, 3 Mar 2008 22:06:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303210647.GA20559@elf.ucw.cz>
References: <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080303210526.GI13869@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210526.GI13869@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-03 22:05:26, Pavel Machek wrote:
> Hi!
> 
> > However I wasn't able to make the problem go away, by removing the
> > _PAGE_PWT constants from __PAGE_KERNEL_NOCACHE and
> > __PAGE_KERNEL_VSYSCALL_NOCACHE in include-asm/pgtable.h in the newest
> > 2.6.25:
> > 
> > diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
> > index 174b877..f81c968 100644
> > --- a/include/asm-x86/pgtable.h
> > +++ b/include/asm-x86/pgtable.h
> > @@ -84,9 +84,9 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
> >  #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
> >  #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
> >  #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
> > -#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
> > +#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
> >  #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
> > -#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
> > +#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD)
> >  #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
> >  #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
> >  
> > So while I'm fairly confident in that I bisected correctly, the number
> > of attempts I had to go through to get a reliable result, and the fact
> > that I cannot make the problem go away by reverting the current code to
> > something similar, counts quite a lot against me.
> > 
> > However I'm 100% confident that the problem appears between
> > cf8fa920cb4271f17e0265c863d64bea1b31941a and
> > 925596a017bbd045ff711b778256f459e50a119, which is something like 16
> > commits. I have been at both points in the tree at least 2 times, and
> > confirmed that cf8fa920cb4271f17e0265c863d64bea1b31941a worked for me,
> > and 925596a017bbd045ff711b778256f459e50a119 didn't.
> > 
> > > while requiring PROT_EXEC is fine, breaking existing user-space apps 
> > > over that is not fine. So are you absolutely sure that by reverting that 
> > > PWT|PCD commit, s2ram again starts to work? That's utmost weird...
> > I'm sure that it fixed the problem for me, yes, and I'm fairly confident
> > that I ran make clean && make to compile the kernel during the entire
> > bisection between the two commites mentioned above.
> > 
> > > perhaps there's some CPU bug that causes NX to _NOT_ work if only PCD is 
> > > used (not PCD|PWT). Seems like a pretty unlikely scenario though.
> > $ cat /proc/cpuinfo
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 15
> > model name      : Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
> > stepping        : 10
> > 
> > But I'm a bit puzzled by the fact that I'm aparently the only one how
> > have encountered the problem? Maybe it's only a problem if one also uses
> > PAE? (Thats just a wild guess to explain why I'm the only one seeing
> > this).
> 
> I do not have NX capable CPU in machine using for suspend
> testing. ... and you are using 32-bit userspace on 64-bit kernel,
> right?

Sorry, I meant "32-bit userspace on 32-bit kernel"... but that on
64-bit capable cpu.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
