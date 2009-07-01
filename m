Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZGALkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZGALkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZGALkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:40:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZGALkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:40:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [microblaze-uclinux] [PATCH 10/11] microblaze: use generic system.h
Date: Wed, 1 Jul 2009 13:39:55 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <cover.1245345894.git.arnd@arndb.de> <4372408b2a754e861984bf803d8b1ade651eb827.1245347640.git.arnd@arndb.de> <4A4B4659.5030008@monstr.eu>
In-Reply-To: <4A4B4659.5030008@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907011339.56171.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/FMWlxA5FbH/aC78fRGbqzPWf1fKWDrk95X6/
 3/CP7qEmZaV6P1AkYg68RZzqiD3ABfZBuQKN/UlxKh3jbVJpI5
 vJjxZEY1xiFxDd12EBSVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Michal Simek wrote:
> this patch can't be applied because generic implementation expect pointer to task struct
> but microblaze low level code expect thread_info. I have one patch for MMU kernel which fixed it
> but I don't have it for noMMU kernel.

Ok, just leave it out for now then, it's not important because it does not impact the ABI.

Maybe I should allow overriding switch_to() in the generic file?

	Arnd <><
---
asm-generic: make parts of system.h optional

The asm-generic/system.h file was originally meant as an example, but by
letting the architecture override some of its contents, it immediately
becomes much more useful.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -24,6 +24,7 @@
 
 struct task_struct;
 
+#ifndef switch_to
 /* context switching is now performed out-of-line in switch_to.S */
 extern struct task_struct *__switch_to(struct task_struct *,
 		struct task_struct *);
@@ -31,10 +32,15 @@ extern struct task_struct *__switch_to(struct task_struct *,
 	do {								\
 		((last) = __switch_to((prev), (next)));			\
 	} while (0)
+#endif
 
+#ifndef arch_align_stack
 #define arch_align_stack(x) (x)
+#endif
 
+#ifndef nop
 #define nop() asm volatile ("nop")
+#define nop
 
 #endif /* !__ASSEMBLY__ */
 
@@ -46,9 +52,11 @@ extern struct task_struct *__switch_to(struct task_struct *,
  * This implementation only contains a compiler barrier.
  */
 
+#ifndef mb()
 #define mb()	asm volatile ("": : :"memory")
 #define rmb()	mb()
 #define wmb()	asm volatile ("": : :"memory")
+#endif
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
