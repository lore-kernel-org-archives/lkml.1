Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYKIN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYKIN3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYKIN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:29:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:29063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYKIN3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:29:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding:from;
        b=tdfHrJHuRzv2A5JxcbR+IABaZBpyJYQaGmqlMuQHpbUFheDRldq7/c5RD4SHN07sqW
         Np7UTooPgsmMiw9Gzk4b4PiHkQ8kHR9nYKqu0l7iYeZxhRqAbF9UH7WxliSRNIM9cpMa
         gGIftr9Cf+SkxzjUHa9Tag8FPRX2YVwCK1Gzw=
Subject: [patch] x86, bts: DS and BTS initialization
To: lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 14:29:21 +0100
Message-Id: <1226237361.6104.20.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move BTS initialisation out of an #ifdef CONFIG_X86_64 guard.

Assume core2 BTS and DS layout for future models of family 6 processors.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2008-11-09 10:55:13.000000000 -0100
+++ gits/arch/x86/kernel/ds.c	2008-11-09 12:40:56.000000000 -0100
@@ -821,17 +821,16 @@
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
+		case 0 ... 0xC:
+			/* sorry, don't know about them */
+			break;
 		case 0xD:
 		case 0xE: /* Pentium M */
 			ds_configure(&ds_cfg_var);
 			break;
-		case 0xF: /* Core2 */
-		case 0x1C: /* Atom */
+		default: /* Core2, Atom, ... */
 			ds_configure(&ds_cfg_64);
 			break;
-		default:
-			/* sorry, don't know about them */
-			break;
 		}
 		break;
 	case 0xF:
Index: gits/arch/x86/kernel/ptrace.c
===================================================================
--- gits.orig/arch/x86/kernel/ptrace.c	2008-11-09 10:55:15.000000000
-0100
+++ gits/arch/x86/kernel/ptrace.c	2008-11-09 12:40:57.000000000 -0100
@@ -929,17 +929,16 @@
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
+		case 0 ... 0xC:
+			/* sorry, don't know about them */
+			break;
 		case 0xD:
 		case 0xE: /* Pentium M */
 			bts_configure(&bts_cfg_pentium_m);
 			break;
-		case 0xF: /* Core2 */
-        case 0x1C: /* Atom */
+		default: /* Core2, Atom, ... */
 			bts_configure(&bts_cfg_core2);
 			break;
-		default:
-			/* sorry, don't know about them */
-			break;
 		}
 		break;
 	case 0xF:
Index: gits/arch/x86/kernel/cpu/intel.c
===================================================================
--- gits.orig/arch/x86/kernel/cpu/intel.c	2008-11-09 10:54:04.000000000
-0100
+++ gits/arch/x86/kernel/cpu/intel.c	2008-11-09 12:41:59.000000000 -0100
@@ -307,12 +307,11 @@
 		set_cpu_cap(c, X86_FEATURE_P4);
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
+#endif
 
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
-#endif
-
 	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*


