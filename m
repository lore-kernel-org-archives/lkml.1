Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbYDYQoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbYDYQoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbYDYQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:44:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760726AbYDYQoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:44:00 -0400
Date: Fri, 25 Apr 2008 18:43:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425164259.GA19962@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 25 Apr 2008, Ingo Molnar wrote:
> > 
> > hm, right now we've got a debug protection in set_fixmap() to make 
> > sure it's only ever called once. So it's going to be a noisy bootup. 
> > (but it's a warning only) The patch below removes that.
> 
> No, I think the warning is good, I should have done some kind of 
> clear_fixmap() after doing the mmap.

yeah - then you need the patch below that makes clear_fixmap() available 
on 64-bit as well.

	Ingo

--------------->
Subject: x86: make clear_fixmap() available on 64-bit as well
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 18:25:25 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/fixmap.h    |    8 ++++++++
 include/asm-x86/fixmap_32.h |    7 ++-----
 include/asm-x86/fixmap_64.h |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

Index: linux/include/asm-x86/fixmap.h
===================================================================
--- linux.orig/include/asm-x86/fixmap.h
+++ linux/include/asm-x86/fixmap.h
@@ -1,5 +1,13 @@
+#ifndef _ASM_FIXMAP_H
+#define _ASM_FIXMAP_H
+
 #ifdef CONFIG_X86_32
 # include "fixmap_32.h"
 #else
 # include "fixmap_64.h"
 #endif
+
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, __pgprot(0))
+
+#endif
Index: linux/include/asm-x86/fixmap_32.h
===================================================================
--- linux.orig/include/asm-x86/fixmap_32.h
+++ linux/include/asm-x86/fixmap_32.h
@@ -10,8 +10,8 @@
  * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  */
 
-#ifndef _ASM_FIXMAP_H
-#define _ASM_FIXMAP_H
+#ifndef _ASM_FIXMAP_32_H
+#define _ASM_FIXMAP_32_H
 
 
 /* used by vmalloc.c, vsyscall.lds.S.
@@ -121,9 +121,6 @@ extern void reserve_top_address(unsigned
 #define set_fixmap_nocache(idx, phys)			\
 	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
-#define clear_fixmap(idx)			\
-	__set_fixmap(idx, 0, __pgprot(0))
-
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 
 #define __FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
Index: linux/include/asm-x86/fixmap_64.h
===================================================================
--- linux.orig/include/asm-x86/fixmap_64.h
+++ linux/include/asm-x86/fixmap_64.h
@@ -8,8 +8,8 @@
  * Copyright (C) 1998 Ingo Molnar
  */
 
-#ifndef _ASM_FIXMAP_H
-#define _ASM_FIXMAP_H
+#ifndef _ASM_FIXMAP_64_H
+#define _ASM_FIXMAP_64_H
 
 #include <linux/kernel.h>
 #include <asm/apicdef.h>
