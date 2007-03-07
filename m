Return-Path: <linux-kernel-owner+w=401wt.eu-S1422841AbXCGRRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422841AbXCGRRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422897AbXCGRRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:43695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422841AbXCGRRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:46 -0500
Message-Id: <20070307171608.234112934@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, ak@suse.de
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, zwane@infradead.org
Subject: [patch 082/101] Fix MTRR compat ioctl
Content-Disposition: inline; filename=fix-mtrr-compat-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zwane Mwaikambo <zwane@infradead.org>

The MTRR compat code wasn't calling the lowlevel MTRR setup due to a switch
block not handling the compat case.

Before:
(WW) I810(0): Failed to set up write-combining range (0xd0000000,0x10000000)

After:
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x5f700000 (1527MB), size=   1MB: uncachable, count=1
reg03: base=0x5f800000 (1528MB), size=   8MB: uncachable, count=1
reg04: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/cpu/mtrr/if.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- linux-2.6.20.1.orig/arch/i386/kernel/cpu/mtrr/if.c
+++ linux-2.6.20.1/arch/i386/kernel/cpu/mtrr/if.c
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
 
@@ -287,7 +296,7 @@ mtrr_ioctl(struct file *file, unsigned i
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch(compat_cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))

--
