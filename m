Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYDZR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYDZR3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYDZR3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:29:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbYDZR27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:28:59 -0400
Date: Sat, 26 Apr 2008 19:28:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080426172843.GA20534@elte.hu>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426172222.GD17345@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> perhaps the combination of distcc and crosscompilers doesnt work well 
> on UML? (it works fine with other architectures)

so i tried a third build method, gcc 3.4, and that built it fine but UML 
crashed during bootup:

 dione:~/linux/linux-x86.q> ./linux
 Core dump limits :
         soft - 0
         hard - NONE
 Checking that ptrace can change system call numbers...OK
 Checking syscall emulation patch for ptrace...OK
 Checking advanced syscall emulation patch for ptrace...OK
 Checking for tmpfs mount on /dev/shm...OK
 Checking PROT_EXEC mmap in /dev/shm/...OK
 Checking for the skas3 patch in the host:
   - /proc/mm...not found: No such file or directory
   - PTRACE_FAULTINFO...not found
   - PTRACE_LDT...not found
 UML running in SKAS0 mode
 Segmentation fault

(gdb) bt
#0  0x000000006020fd92 in txInit ()
#1  0x000000006000a4c1 in init_jfs_fs ()
#2  0x0000000060001794 in do_initcalls ()
#3  0x000000006000196d in do_basic_setup ()
#4  0x0000000060001a14 in kernel_init ()
#5  0x0000000060028427 in run_kernel_thread ()
#6  0x000000006001d020 in new_thread_handler ()
#7  0x0000000000000000 in ?? ()

rip            0x6020fd92       0x6020fd92 <txInit+306>

txInit is in JFS.

but at least i could build UML. (this is all with pristine -git)

So i checked the patch below. And it built fine, and boo^H^Hcrashed just 
like it did before:

   - PTRACE_FAULTINFO...not found
   - PTRACE_LDT...not found
 UML running in SKAS0 mode
 Segmentation fault

so i guess this is the way to go?

	Ingo

---------------------->
Subject: uml: kconfig cleanup
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 19:10:17 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/Kconfig.x86_64 |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-x86.q/arch/um/Kconfig.x86_64
===================================================================
--- linux-x86.q.orig/arch/um/Kconfig.x86_64
+++ linux-x86.q/arch/um/Kconfig.x86_64
@@ -1,3 +1,10 @@
+
+menu "Host processor type and features"
+
+source "arch/x86/Kconfig.cpu"
+
+endmenu
+
 config UML_X86
 	bool
 	default y
