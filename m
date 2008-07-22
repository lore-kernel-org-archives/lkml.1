Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbYGVTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbYGVTYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYGVTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:54 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15938 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYGVTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:51 -0400
X-BigFish: VPS26(z37d4jzzz10d3izzz32i87il43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VB-01-8PJ-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/24] OProfile: Moving increment_tail() in buffer_sync.c
Date: Tue, 22 Jul 2008 21:08:52 +0200
Message-ID: <1216753748-11261-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0449 (UTC) FILETIME=[71F47290:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 69a7327..615929f 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -268,6 +268,17 @@ lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 	return cookie;
 }
 
+static void increment_tail(struct oprofile_cpu_buffer *b)
+{
+	unsigned long new_tail = b->tail_pos + 1;
+
+	rmb();
+
+	if (new_tail < b->buffer_size)
+		b->tail_pos = new_tail;
+	else
+		b->tail_pos = 0;
+}
 
 static unsigned long last_cookie = INVALID_COOKIE;
 
@@ -417,19 +428,6 @@ static unsigned long get_slots(struct oprofile_cpu_buffer *b)
 }
 
 
-static void increment_tail(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
-- 
1.5.5.4


