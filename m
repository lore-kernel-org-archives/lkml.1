Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYGQC5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYGQC5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYGQC5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:57:41 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48182 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYGQC5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:57:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAJ9RfkhMRKxB/2dsb2JhbACBWa5j
Date: Wed, 16 Jul 2008 22:57:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Immedate Values Optimized Jump Fix
Message-ID: <20080717025738.GA23277@Krystal>
References: <20080715024754.GA26471@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080715024754.GA26471@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:53:15 up 42 days,  7:34,  5 users,  load average: 0.52, 0.39,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rarely emit a single patch for a fix wrt LTTng (I usually just release
a new version), but this one is worth it. It will be in 0.11 pretty
soon, but if you want to apply it to 0.10 meanwhile, it's highly
recommended.

Caused a kernel OOPS when loading the tracepoint probes once in a while
on a 8-way x86_64.


Immedate Values Optimized Jump Fix

Fix the immediate values optimized jump fallback, which parameters were wrong
following the last changes. It should be a 5 bytes instruction (not 2) with a 4
bytes operand.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/immediate.c |    2 +-
 include/asm-x86/immediate.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/immediate.c	2008-07-16 22:50:35.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2008-07-16 22:51:07.000000000 -0400
@@ -500,7 +500,7 @@ __kprobes int arch_imv_update(struct __i
 				"Jump target fallback at %lX, nr fail %d\n",
 				imv->imv, ++nr_fail);
 #endif
-			imv->size = 1;
+			imv->size = 4;	/* Fallback on movl */
 		} else {
 #ifdef DEBUG_IMMEDIATE
 			static int nr_success;
Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/immediate.h	2008-07-16 22:49:19.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2008-07-16 22:51:07.000000000 -0400
@@ -132,7 +132,7 @@ struct __imv {
 		BUILD_BUG_ON(sizeof(__typeof__(name##__imv)) > 1);	\
 		asm (".section __imv,\"aw\",@progbits\n\t"		\
 			_ASM_PTR "%c1, (3f)-4\n\t"			\
-			".byte 0, 2\n\t"				\
+			".byte 0, 5\n\t"				\
 			".previous\n\t"					\
 			"mov $0,%0\n\t"					\
 			"3:\n\t"					\

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
