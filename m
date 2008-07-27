Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYG0T3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYG0T3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYG0T3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:29:25 -0400
Received: from www.tglx.de ([62.245.132.106]:48029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYG0T3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:29:25 -0400
Date: Sun, 27 Jul 2008 21:23:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: -git: BUG: unable to handle kernel paging request at c0100248
 [CPU hotplug]
In-Reply-To: <19f34abd0807271019i2112498ay57c267354bd63a8c@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807272118460.574@apollo.tec.linutronix.de>
References: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>  <b647ffbd0807271014j17d1a14cncd0976ff4d3ff3fd@mail.gmail.com> <19f34abd0807271019i2112498ay57c267354bd63a8c@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Vegard Nossum wrote:
> Booting processor 1/1 ip 6000
> Initializing CPU#1
> [...]
> Write protecting the kernel text: 5648k
> 
> So it succeeds because the protection happens much later :-)

Patch below fixes the issue. I get it to Linus ASAP.

Thanks,

	tglx
---------
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f67e934..a7010c3 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -456,9 +456,6 @@ is386:	movl $2,%ecx		# set MP
 1:
 #endif /* CONFIG_SMP */
 	jmp *(initial_code)
-.align 4
-ENTRY(initial_code)
-	.long i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
@@ -601,6 +598,11 @@ ignore_int:
 #endif
 	iret
 
+.section .cpuinit.data,"wa"
+.align 4
+ENTRY(initial_code)
+	.long i386_start_kernel
+
 .section .text
 /*
  * Real beginning of normal "text" segment
