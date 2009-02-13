Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbZBMOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbZBMOYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZBMOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:24:15 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:13413 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZBMOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:24:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mqz0yXnuVBa6AB2ZnTx37qw//rfYSCMH5U8z8VB2Io+8S4z1LQt4iOrHBbhkQpm1zt
         LXud1jsJXFx/qF5m4+vpaiI2kZw+zm4Wt5cRSVFe7VHzmjR5gOKyaYR1E99Y/bRt3tIu
         Q1ppKAvSU+8q9lTHCGMIgdMHlBNMWxtW0ADAE=
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 20:24:11 +0600
Message-ID: <b9df5fa10902130624r5690b37bv404c528a90e5d112@mail.gmail.com>
Subject: [PATCH -mm] x86/mm: Fix section mismatch
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix section mismatch.

Currently pat_init calls pat_disable which is annoted with __cpuinit.
Thus requires pat_init to be
annoted with __cpuinit, otherwise causes the following warning.

 LD      arch/x86/mm/built-in.o
WARNING: arch/x86/mm/built-in.o(.text+0x1fff): Section mismatch in
reference from the function pat_init() to the function
.cpuinit.text:pat_disable()
The function pat_init() references
the function __cpuinit pat_disable().
This is often because pat_init lacks a __cpuinit
annotation or the annotation of pat_disable is wrong.

After annotating pat_init with __cpuinit, it generates the following
warning when CONFIG_x86_PAT=n.

 MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xd48b): Section mismatch in reference from
the function generic_set_all() to the function
.cpuinit.text:pat_init()
The function generic_set_all() references
the function __cpuinit pat_init().
This is often because generic_set_all lacks a __cpuinit
annotation or the annotation of pat_init is wrong.

This patch fixes the above warnings.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/mm/pat.c	2009-02-13 11:23:25.000000000 +0600
+++ rakib/arch/x86/mm/pat.c	2009-02-13 11:21:49.000000000 +0600
@@ -76,7 +76,7 @@ enum {

 #define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))

-void pat_init(void)
+void __cpuinit pat_init(void)
 {
 	u64 pat;

---
--- linus/arch/x86/kernel/cpu/mtrr/generic.c	2009-02-13 10:24:25.000000000 +0600
+++ rakib/arch/x86/kernel/cpu/mtrr/generic.c	2009-02-13 12:47:55.000000000 +0600
@@ -543,7 +543,7 @@ static void post_set(void) __releases(se
 	spin_unlock(&set_atomicity_lock);
 }

-static void generic_set_all(void)
+static void __cpuinit generic_set_all(void)
 {
 	unsigned long mask, count;
 	unsigned long flags;
