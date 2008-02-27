Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbYB0WK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbYB0WK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbYB0WKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:10:37 -0500
Received: from xspect.dk ([212.97.129.87]:52081 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358AbYB0WKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:10:36 -0500
Date: Wed, 27 Feb 2008 23:10:33 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080227221033.GR17932@hjernemadsen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	I have a Thinkpad T61p, which I'm able to suspend with s2ram on
Linux 2.6.24.3. However when I try to suspend it on 2.6.25-rc3, s2ram
dies after changing to vt1, with a segfault. I'm using s2ram from cvs,
and libx86 version 0.99 from http://www.codon.org.uk/~mjg59/libx86/.

Some details about the segfault:

$ sudo gdb ./s2ram
(gdb) run
Starting program: /home/ksm/downloads/suspend/s2ram 
Switching from vt7 to vt1
Calling get_mode

Program received signal SIGSEGV, Segmentation fault.
0xb7facf4a in run_vm86 () at lrmi.c:526
526             asm volatile (
(gdb) list
521     static int
522     lrmi_vm86(struct vm86_struct *vm)
523     {
524             int r;
525     #ifdef __PIC__
526             asm volatile (
527              "pushl %%ebx\n\t"
528              "movl %2, %%ebx\n\t"
529              "int $0x80\n\t"
530              "popl %%ebx"
(gdb) bt 
#0  0xb7facf4a in run_vm86 () at lrmi.c:526
#1  0xb7fad61b in LRMI_int (i=16, r=0xbffca670) at lrmi.c:844
#2  0x0804acfc in do_vbe_service (AX=20227, BX=0, regs=0xbffca670)
    at vbetool/vbetool.c:158
#3  0x0804af7e in __get_mode () at vbetool/vbetool.c:453
#4  0x0804a30f in s2ram_hacks () at s2ram-x86.c:268
#5  0x0804954f in main (argc=1, argv=0x0) at s2ram-main.c:92

I have tried to bisect the problem, and it fingered the following
commit:

commit 82bc03fc158e28c90d7ed9919410776039cb4e14
Author: Ingo Molnar <mingo@elte.hu>

    x86: add PWT to NOCACHE flags

Reverting this commit in the bisected tree (by executing git show
82bc03fc158e28c90d7ed9919410776039cb4e14 | patch -R -p1), makes the
segfault go away. I've run make clean between each kernel compile, to be
sure the tree was correctly compiled.

I have attached the .config I'm using for 2.6.25-rc3 (when bisecting, I
just choose the default on every question). If necessary, I can try to
reconstruct the one I ended up with after the bisection.

Hope this makes sense to someone, and thanks in advance.

-- 
Kind regards
	Klaus S. Madsen
