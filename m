Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbZAGW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbZAGW03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762222AbZAGWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:19 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49660 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762132AbZAGWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:15 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4GU6-02-XTA-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/18] oprofile: simplify add_sample()
Date: Wed, 7 Jan 2009 23:17:24 +0100
Message-ID: <1231366655-17837-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0350 (UTC) FILETIME=[7F2ACB60:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes add_us_sample() and simplifies add_sample(). Code
is much more readable now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index d295d92..0abe29e 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -392,11 +392,29 @@ static void add_sample_entry(unsigned long offset, unsigned long event)
 }
 
 
-static int add_us_sample(struct mm_struct *mm, struct op_sample *s)
+/*
+ * Add a sample to the global event buffer. If possible the
+ * sample is converted into a persistent dentry/offset pair
+ * for later lookup from userspace. Return 0 on failure.
+ */
+static int
+add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 {
 	unsigned long cookie;
 	off_t offset;
 
+	if (in_kernel) {
+		add_sample_entry(s->eip, s->event);
+		return 1;
+	}
+
+	/* add userspace sample */
+
+	if (!mm) {
+		atomic_inc(&oprofile_stats.sample_lost_no_mm);
+		return 0;
+	}
+
 	cookie = lookup_dcookie(mm, s->eip, &offset);
 
 	if (cookie == INVALID_COOKIE) {
@@ -415,25 +433,6 @@ static int add_us_sample(struct mm_struct *mm, struct op_sample *s)
 }
 
 
-/* Add a sample to the global event buffer. If possible the
- * sample is converted into a persistent dentry/offset pair
- * for later lookup from userspace.
- */
-static int
-add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
-{
-	if (in_kernel) {
-		add_sample_entry(s->eip, s->event);
-		return 1;
-	} else if (mm) {
-		return add_us_sample(mm, s);
-	} else {
-		atomic_inc(&oprofile_stats.sample_lost_no_mm);
-	}
-	return 0;
-}
-
-
 static void release_mm(struct mm_struct *mm)
 {
 	if (!mm)
-- 
1.6.0.1


