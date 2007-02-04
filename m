Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXBDVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXBDVlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXBDVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:41:39 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:35935 "EHLO
	pd5mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXBDVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:41:38 -0500
Date: Sun, 04 Feb 2007 13:40:31 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: [PATCH] Fix MTRR compat ioctl
To: rgooch@atnf.csiro.au
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0702041328150.31479@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The MTRR compat code wasn't calling the lowlevel MTRR setup due to a 
switch block not handling the compat case.

Before:
(WW) I810(0): Failed to set up write-combining range (0xd0000000,0x10000000)

After:
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x5f700000 (1527MB), size=   1MB: uncachable, count=1
reg03: base=0x5f800000 (1528MB), size=   8MB: uncachable, count=1
reg04: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>

Index: arch/i386/kernel/cpu/mtrr/if.c
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc6-mm1/arch/i386/kernel/cpu/mtrr/if.c,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 if.c
--- arch/i386/kernel/cpu/mtrr/if.c	30 Jan 2007 05:28:30 -0000	1.1.1.1
+++ arch/i386/kernel/cpu/mtrr/if.c	4 Feb 2007 21:36:57 -0000
@@ -158,8 +158,9 @@ mtrr_ioctl(struct file *file, unsigned i
 	struct mtrr_sentry sentry;
 	struct mtrr_gentry gentry;
 	void __user *arg = (void __user *) __arg;
+	unsigned int compat_cmd = cmd;
 
-	switch (cmd) {
+	switch (compat_cmd) {
 	case MTRRIOC_ADD_ENTRY:
 	case MTRRIOC_SET_ENTRY:
 	case MTRRIOC_DEL_ENTRY:
@@ -177,14 +178,20 @@ mtrr_ioctl(struct file *file, unsigned i
 			return -EFAULT;
 		break;
 #ifdef CONFIG_COMPAT
-	case MTRRIOC32_ADD_ENTRY:
-	case MTRRIOC32_SET_ENTRY:
-	case MTRRIOC32_DEL_ENTRY:
-	case MTRRIOC32_KILL_ENTRY:
-	case MTRRIOC32_ADD_PAGE_ENTRY:
-	case MTRRIOC32_SET_PAGE_ENTRY:
-	case MTRRIOC32_DEL_PAGE_ENTRY:
-	case MTRRIOC32_KILL_PAGE_ENTRY: {
+#define MTRR_COMPAT_OP(op, type)\
+	case MTRRIOC32_##op:	\
+	cmd = MTRRIOC_##op;	\
+	goto compat_get_##type
+
+	MTRR_COMPAT_OP(ADD_ENTRY, sentry);
+	MTRR_COMPAT_OP(SET_ENTRY, sentry);
+	MTRR_COMPAT_OP(DEL_ENTRY, sentry);
+	MTRR_COMPAT_OP(KILL_ENTRY, sentry);
+	MTRR_COMPAT_OP(ADD_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(SET_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(DEL_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(KILL_PAGE_ENTRY, sentry);
+compat_get_sentry: {
 		struct mtrr_sentry32 __user *s32 = (struct mtrr_sentry32 __user *)__arg;
 		err = get_user(sentry.base, &s32->base);
 		err |= get_user(sentry.size, &s32->size);
@@ -193,8 +200,9 @@ mtrr_ioctl(struct file *file, unsigned i
 			return err;
 		break;
 	}
-	case MTRRIOC32_GET_ENTRY:
-	case MTRRIOC32_GET_PAGE_ENTRY: {
+	MTRR_COMPAT_OP(GET_ENTRY, gentry);
+	MTRR_COMPAT_OP(GET_PAGE_ENTRY, gentry);
+compat_get_gentry: {
 		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = get_user(gentry.regnum, &g32->regnum);
 		err |= get_user(gentry.base, &g32->base);
@@ -204,6 +212,7 @@ mtrr_ioctl(struct file *file, unsigned i
 			return err;
 		break;
 	}
+#undef MTRR_COMPAT_OP
 #endif
 	}
 
@@ -317,7 +326,7 @@ mtrr_ioctl(struct file *file, unsigned i
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch(compat_cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))
