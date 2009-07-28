Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZG1RS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZG1RS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZG1RS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:26 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9627 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753392AbZG1RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DN-04-A2I-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/26] oprofile: oprofile_set_timeout(), return with error for invalid args
Date: Tue, 28 Jul 2009 19:07:07 +0200
Message-ID: <1248800846-25422-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:48.0056 (UTC) FILETIME=[543A9180:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return with -EINVAL for invalid parameters instead of setting the
default value in oprofile_set_timeout().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 7bc64af..42c9c76 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -196,6 +196,7 @@ post_sync:
 int oprofile_set_timeout(unsigned long val_msec)
 {
 	int err = 0;
+	unsigned long time_slice;
 
 	mutex_lock(&start_mutex);
 
@@ -209,9 +210,13 @@ int oprofile_set_timeout(unsigned long val_msec)
 		goto out;
 	}
 
-	timeout_jiffies = msecs_to_jiffies(val_msec);
-	if (timeout_jiffies == MAX_JIFFY_OFFSET)
-		timeout_jiffies = msecs_to_jiffies(MULTIPLEXING_TIMER_DEFAULT);
+	time_slice = msecs_to_jiffies(val_msec);
+	if (time_slice == MAX_JIFFY_OFFSET) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	timeout_jiffies = time_slice;
 
 out:
 	mutex_unlock(&start_mutex);
-- 
1.6.3.3


