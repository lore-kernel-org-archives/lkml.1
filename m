Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXGaHFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXGaHFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXGaHFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:05:46 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:21406 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXGaHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from:sender;
        b=Y72Yu696yAkR0AiR6Gl1TGQAAtdz4jz+USRxMPjdZ+iYBqTaODKVgQ1WMFvl9tr+T00egAOdnsbuEKwFZedPogI0FJnENTzoFPcPIyaA3OYUwAyK1383GeGCrAXVnPHAmhZcftwYe0OLwSWiS6RjrLx3ZFt/9CHtozPWzb9cTY0=
Date: Tue, 31 Jul 2007 15:05:38 +0800
To: linux-kernel@vger.kernel.org
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/3] coredump: re-implement suid_dumpable using a flag
Message-ID: <20070731070538.GD2412@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731070238.GA2412@kernel.sg>
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hidehiro-san re-implemented suid_dumpable using a pair of bit flags. But
since we no longer permitting users to call prctl(PR_SET_DUMPABLE, 2),
there is no need to waste a bit of mm_struct.flags for something that will
never be used.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/exec.c             |   42 +++++-------------------------------------
 include/linux/sched.h |   13 ++++++-------
 2 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 60b4080..0f30b94 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1666,53 +1666,21 @@ fail:
 }
 
 /*
- * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
- * these bits are not changed atomically.  So get_dumpable can observe the
- * intermediate state.  To avoid doing unexpected behavior, get get_dumpable
- * return either old dumpable or new one by paying attention to the order of
- * modifying the bits.
- *
- * dumpable |   mm->flags (binary)
- * old  new | initial interim  final
- * ---------+-----------------------
- *  0    1  |   00      01      01
- *  0    2  |   00      10(*)   11
- *  1    0  |   01      00      00
- *  1    2  |   01      11      11
- *  2    0  |   11      10(*)   00
- *  2    1  |   11      11      01
- *
- * (*) get_dumpable regards interim value of 10 as 11.
+ * set_dumpable converts traditional two-value dumpable to one flag and
+ * stores it in mm->flags. It modifies the lower bit of mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
-	switch (value) {
-	case 0:
+	if (value == 0)
 		clear_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case 1:
-		set_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case 2:
-		set_bit(MMF_DUMP_SECURELY, &mm->flags);
-		smp_wmb();
+	else if (value == 1)
 		set_bit(MMF_DUMPABLE, &mm->flags);
-		break;
-	}
 }
 EXPORT_SYMBOL_GPL(set_dumpable);
 
 int get_dumpable(struct mm_struct *mm)
 {
-	int ret;
-
-	ret = mm->flags & 0x3;
-	return (ret >= 2) ? 2 : ret;
+	return (mm->flags & 0x1);
 }
 
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2e49027..8a0092d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -350,15 +350,14 @@ extern int get_dumpable(struct mm_struct *mm);
 
 /* mm flags */
 /* dumpable bits */
-#define MMF_DUMPABLE      0  /* core dump is permitted */
-#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
-#define MMF_DUMPABLE_BITS 2
+#define MMF_DUMPABLE		0  /* core dump is permitted */
+#define MMF_DUMPABLE_BITS	1
 
 /* coredump filter bits */
-#define MMF_DUMP_ANON_PRIVATE	2
-#define MMF_DUMP_ANON_SHARED	3
-#define MMF_DUMP_MAPPED_PRIVATE	4
-#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_ANON_PRIVATE	1
+#define MMF_DUMP_ANON_SHARED	2
+#define MMF_DUMP_MAPPED_PRIVATE	3
+#define MMF_DUMP_MAPPED_SHARED	4
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
 #define MMF_DUMP_FILTER_BITS	4
 #define MMF_DUMP_FILTER_MASK \

