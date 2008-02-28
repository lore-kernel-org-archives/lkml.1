Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbYB1PEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbYB1PEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYB1PEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:04:47 -0500
Received: from xspect.dk ([212.97.129.87]:37059 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYB1PEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:04:46 -0500
Date: Thu, 28 Feb 2008 16:04:44 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080228150444.GG17932@hjernemadsen.org>
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228094000.GA2987@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 10:40:00 +0100, Ingo Molnar wrote:
> 
> * Klaus S. Madsen <ksm@hjernemadsen.org> wrote:
> 
> > > > 524             int r;
> > > > 525     #ifdef __PIC__
> > > > 526             asm volatile (
> > > > 527              "pushl %%ebx\n\t"
> > > > 528              "movl %2, %%ebx\n\t"
> > > > 529              "int $0x80\n\t"
> > > > 530              "popl %%ebx"
> > > > (gdb) bt 
> > > > #0  0xb7facf4a in run_vm86 () at lrmi.c:526
> > > > #1  0xb7fad61b in LRMI_int (i=16, r=0xbffca670) at lrmi.c:844
> > > > #2  0x0804acfc in do_vbe_service (AX=20227, BX=0, regs=0xbffca670)
> > > >     at vbetool/vbetool.c:158
> > > > #3  0x0804af7e in __get_mode () at vbetool/vbetool.c:453
> > > > #4  0x0804a30f in s2ram_hacks () at s2ram-x86.c:268
> > > > #5  0x0804954f in main (argc=1, argv=0x0) at s2ram-main.c:92

[snip]

> > > thanks for tracking this down. It would be nice to figure out why this 
> > > change made a difference. Perhaps VM86 mode has some restrictions in 
> > > what type of pagetables it can operate in - and the CPU just refuses to 
> > > properly emulate those 16-bit instructions? (this would be very weird). 
> > > We are trying to execute 16-bit BIOS code here, right?
> > > 
> > > which instruction is the segfault coming from - the int $0x80? So in 
> > > vm86 mode we generated a #GPF which shows up as a SIGSEGV?

The segfault was at address 0xb7f59f4a, and the disassembly of
the run_vm86 function is:

0xb7f59f20 <run_vm86+0>:        push   %ebp
0xb7f59f21 <run_vm86+1>:        mov    %esp,%ebp
0xb7f59f23 <run_vm86+3>:        push   %edi
0xb7f59f24 <run_vm86+4>:        push   %esi
0xb7f59f25 <run_vm86+5>:        push   %ebx
0xb7f59f26 <run_vm86+6>:        call   0xb7f59697  <__i686.get_pc_thunk.bx>
0xb7f59f2b <run_vm86+11>:       add    $0x18b5,%ebx
0xb7f59f31 <run_vm86+17>:       sub    $0x3c,%esp
0xb7f59f34 <run_vm86+20>:       lea    0x48c(%ebx),%eax
0xb7f59f3a <run_vm86+26>:       mov    %eax,0xffffffc0(%ebp)
0xb7f59f3d <run_vm86+29>:       mov    $0x71,%eax
0xb7f59f42 <run_vm86+34>:       mov    0xffffffc0(%ebp),%ecx
0xb7f59f45 <run_vm86+37>:       push   %ebx
0xb7f59f46 <run_vm86+38>:       mov    %ecx,%ebx
0xb7f59f48 <run_vm86+40>:       int    $0x80
0xb7f59f4a <run_vm86+42>:       pop    %ebx
0xb7f59f4b <run_vm86+43>:       mov    %eax,%edx
0xb7f59f4d <run_vm86+45>:       and    $0xff,%eax
0xb7f59f52 <run_vm86+50>:       cmp    $0x2,%eax
0xb7f59f55 <run_vm86+53>:       je     0xb7f5a0b5 <run_vm86+405>
0xb7f59f5b <run_vm86+59>:       sub    $0x1,%eax
0xb7f59f5e <run_vm86+62>:       jne    0xb7f5a28a <run_vm86+874>

Hope this helps. 

-- 
Kind regards
	Klaus S. Madsen
