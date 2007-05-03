Return-Path: <linux-kernel-owner+w=401wt.eu-S1767727AbXECTNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767727AbXECTNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767724AbXECTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:13:49 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:33967 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767719AbXECTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:13:47 -0400
X-BigFish: VP
Message-ID: <463A3512.4020508@am.sony.com>
Date: Thu, 03 May 2007 12:16:34 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt1 - bug in asm-mips/atomic.h
References: <20070205065636.GA1652@elte.hu> <20070426135730.GA2116@elte.hu>
In-Reply-To: <20070426135730.GA2116@elte.hu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2007 19:13:42.0404 (UTC) FILETIME=[29DA1C40:01C78DB7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i have released the v2.6.20-rt1 kernel...
Ingo,

There appears to be a bug in the patch for include/asm-mips/atomic.h
In the hunk for line 554, it has 2 #endifs.
I think it should only have one.

A portion of the patch reads:

Index: new-linux/include/asm-mips/atomic.h
===================================================================
--- new-linux.orig/include/asm-mips/atomic.h	2007-04-25 20:08:32.000000000 -0700
+++ new-linux/include/asm-mips/atomic.h	2007-04-26 16:15:14.000000000 -0700
@@ -545,7 +554,9 @@
 		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
 		: "Ir" (i), "m" (v->counter)
 		: "memory");
-	} else {
+	}
+#if !defined(CONFIG_NO_SPINLOCK) && !defined(CONFIG_PREEMPT_RT)
+	else {
 		unsigned long flags;

 		raw_local_irq_save(flags);
@@ -554,6 +565,8 @@
 		v->counter = result;
 		raw_local_irq_restore(flags);
 	}
+#endif
+#endif

 	smp_mb();


When I applied the patch to 2.6.21 and tried to compile for MIPS I got:
  CHK     include/linux/utsrelease.h
  CC      arch/mips/kernel/asm-offsets.s
In file included from /home/tbird/work/alp-3.0/alp-linux/include/linux/rt_lock.h:14,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/spinlock.h:116,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/capability.h:45,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/sched.h:47,
                 from /home/tbird/work/alp-3.0/alp-linux/arch/mips/kernel/asm-offsets.c:14:
include2/asm/atomic.h:571: error: expected '(' before 'volatile'
include2/asm/atomic.h:573: error: expected identifier or '(' before 'return'
include2/asm/atomic.h:574: error: expected identifier or '(' before '}' token
include2/asm/atomic.h:576: error: expected declaration specifiers or '...' before 'atomic64_t'
include2/asm/atomic.h: In function 'atomic64_sub_return':
include2/asm/atomic.h:593: error: 'v' undeclared (first use in this function)
include2/asm/atomic.h:593: error: (Each undeclared identifier is reported only once
include2/asm/atomic.h:593: error: for each function it appears in.)
include2/asm/atomic.h:585: error: invalid lvalue in asm output 2
include2/asm/atomic.h:585: error: memory input 4 is not directly addressable
include2/asm/atomic.h:599: error: invalid lvalue in asm output 2
include2/asm/atomic.h:599: error: memory input 4 is not directly addressable
include2/asm/atomic.h: At top level:
include2/asm/atomic.h:638: error: expected declaration specifiers or '...' before 'atomic64_t'
include2/asm/atomic.h: In function 'atomic64_sub_if_positive':
include2/asm/atomic.h:659: error: 'v' undeclared (first use in this function)
include2/asm/atomic.h:647: error: invalid lvalue in asm output 2
include2/asm/atomic.h:647: error: memory input 4 is not directly addressable
include2/asm/atomic.h:665: error: invalid lvalue in asm output 2
include2/asm/atomic.h:665: error: memory input 4 is not directly addressable
In file included from /home/tbird/work/alp-3.0/alp-linux/include/linux/rt_lock.h:14,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/spinlock.h:116,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/capability.h:45,
                 from /home/tbird/work/alp-3.0/alp-linux/include/linux/sched.h:47,
                 from /home/tbird/work/alp-3.0/alp-linux/arch/mips/kernel/asm-offsets.c:14:
include2/asm/atomic.h:779:2: error: #endif without #if

After removing the second #endif in the second hunk above, things compiled better.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Electronics
=============================

