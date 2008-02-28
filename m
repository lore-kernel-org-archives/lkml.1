Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbYB1JRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbYB1JRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYB1JRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:17:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYB1JRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:17:02 -0500
Date: Thu, 28 Feb 2008 10:16:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080228091639.GB1133@elte.hu>
References: <20080227221033.GR17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227221033.GR17932@hjernemadsen.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Klaus S. Madsen <ksm@hjernemadsen.org> wrote:

> Hi all,
> 
> 	I have a Thinkpad T61p, which I'm able to suspend with s2ram 
> on Linux 2.6.24.3. However when I try to suspend it on 2.6.25-rc3, 
> s2ram dies after changing to vt1, with a segfault. I'm using s2ram 
> from cvs, and libx86 version 0.99 from 
> http://www.codon.org.uk/~mjg59/libx86/.
> 
> Some details about the segfault:
> 
> $ sudo gdb ./s2ram
> (gdb) run
> Starting program: /home/ksm/downloads/suspend/s2ram 
> Switching from vt7 to vt1
> Calling get_mode
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0xb7facf4a in run_vm86 () at lrmi.c:526
> 526             asm volatile (
> (gdb) list
> 521     static int
> 522     lrmi_vm86(struct vm86_struct *vm)
> 523     {
> 524             int r;
> 525     #ifdef __PIC__
> 526             asm volatile (
> 527              "pushl %%ebx\n\t"
> 528              "movl %2, %%ebx\n\t"
> 529              "int $0x80\n\t"
> 530              "popl %%ebx"
> (gdb) bt 
> #0  0xb7facf4a in run_vm86 () at lrmi.c:526
> #1  0xb7fad61b in LRMI_int (i=16, r=0xbffca670) at lrmi.c:844
> #2  0x0804acfc in do_vbe_service (AX=20227, BX=0, regs=0xbffca670)
>     at vbetool/vbetool.c:158
> #3  0x0804af7e in __get_mode () at vbetool/vbetool.c:453
> #4  0x0804a30f in s2ram_hacks () at s2ram-x86.c:268
> #5  0x0804954f in main (argc=1, argv=0x0) at s2ram-main.c:92
> 
> I have tried to bisect the problem, and it fingered the following
> commit:
> 
> commit 82bc03fc158e28c90d7ed9919410776039cb4e14
> Author: Ingo Molnar <mingo@elte.hu>
> 
>     x86: add PWT to NOCACHE flags
> 
> Reverting this commit in the bisected tree (by executing git show 
> 82bc03fc158e28c90d7ed9919410776039cb4e14 | patch -R -p1), makes the 
> segfault go away. I've run make clean between each kernel compile, to 
> be sure the tree was correctly compiled.

thanks for tracking this down. It would be nice to figure out why this 
change made a difference. Perhaps VM86 mode has some restrictions in 
what type of pagetables it can operate in - and the CPU just refuses to 
properly emulate those 16-bit instructions? (this would be very weird). 
We are trying to execute 16-bit BIOS code here, right?

which instruction is the segfault coming from - the int $0x80? So in 
vm86 mode we generated a #GPF which shows up as a SIGSEGV?

	Ingo
