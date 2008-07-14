Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYGNQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYGNQIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYGNQID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:08:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbYGNQIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:08:01 -0400
Date: Mon, 14 Jul 2008 18:07:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
Message-ID: <20080714160748.GA10684@elte.hu>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008, Ingo Molnar wrote:
> > > 
> > > Why not use something sane like 0xdead000000000000, which has the high 
> > > bit set but very fundamentally isn't a valid pointer, and never will 
> > > be? And which is a *lot* more visually obvious too!
> > 
> > initially i suggested that too - but such addresses raise a #GP instead 
> > of a page fault so their decoding is a bit harder.
> 
> But raising a GP is exactly what you want: a PF is an indication that the 
> address was actually half-way valid, and will not fault at all on some 
> (possibly future) machine.
> 
> > We dont do any instruction decoding in #GP handlers to figure out what 
> > happened, while in the pagefault case we know which address faulted, 
> > etc.
> 
> Why would we care? It would be very obvious from the instruction 
> disassembly plus the register contents. No need to decode instructions.
> 
> > Perhaps we could try to make #GP handlers a bit more informative - 
> > although decoding instructions will make things a bit more fragile 
> > inevitably.
> > 
> > Perhaps make it 0xffffcdead0000000 ?
> 
> I'm really not seeing the reason for not just doing it right.

ok. Find the updated pull request below. I've added your Acked-by to the 
last commit.

Please pull the latest safe-poison-pointers git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git safe-poison-pointers

Thanks,

	Ingo

------------------>
Avi Kivity (1):
      core, x86: make LIST_POISON less deadly

Ingo Molnar (1):
      x86: change LIST_POISON to 0xdead000000000000


 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0edaaa..0dbd040 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1019,6 +1019,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xdead000000000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 9f31683..0d105a5 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -1,14 +1,20 @@
 #ifndef _LINUX_POISON_H
 #define _LINUX_POISON_H
 
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+#define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+#else
+#define POISON_POINTER_DELTA 0L
+#endif
+
 /********** include/linux/list.h **********/
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
