Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbZJITtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbZJITtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbZJITtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:49:21 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:57108 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934185AbZJITtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:49:20 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzzz1202hzzz32i2a8I87h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KR9IZZ-04-9FN-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       David Rientjes <rientjes@google.com>,
       Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] oprofile: warn on freeing event buffer too early
Date: Fri, 9 Oct 2009 21:33:30 +0200
Message-ID: <1255116810-26514-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <20091009160532.GD638@erda.amd.com>
References: <20091009160532.GD638@erda.amd.com>
X-OriginalArrivalTime: 09 Oct 2009 19:47:57.0016 (UTC) FILETIME=[66248580:01CA4919]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A race shouldn't happen since all workqueues or handlers are canceled
or flushed before the event buffer is freed. A warning is triggered
now if the buffer is freed too early.

Also, this patch adds some comments about event buffer protection,
reworks some code and adds code to clear buffer_pos during alloc and
free of the event buffer.

Cc: David Rientjes <rientjes@google.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/event_buffer.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index c38adb3..5df60a6 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -35,17 +35,22 @@ static size_t buffer_pos;
 /* atomic_t because wait_event checks it outside of buffer_mutex */
 static atomic_t buffer_ready = ATOMIC_INIT(0);
 
-/* Add an entry to the event buffer. When we
- * get near to the end we wake up the process
- * sleeping on the read() of the file.
+/*
+ * Add an entry to the event buffer. When we get near to the end we
+ * wake up the process sleeping on the read() of the file. To protect
+ * the event_buffer this function may only be called when buffer_mutex
+ * is set.
  */
 void add_event_entry(unsigned long value)
 {
 	/*
-	 * catch potential error
+	 * This shouldn't happen since all workqueues or handlers are
+	 * canceled or flushed before the event buffer is freed.
 	 */
-	if (!event_buffer)
+	if (!event_buffer) {
+		WARN_ON_ONCE(1);
 		return;
+	}
 
 	if (buffer_pos == buffer_size) {
 		atomic_inc(&oprofile_stats.event_lost_overflow);
@@ -75,7 +80,6 @@ void wake_up_buffer_waiter(void)
 
 int alloc_event_buffer(void)
 {
-	int err = -ENOMEM;
 	unsigned long flags;
 
 	spin_lock_irqsave(&oprofilefs_lock, flags);
@@ -86,13 +90,12 @@ int alloc_event_buffer(void)
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
 
+	buffer_pos = 0;
 	event_buffer = vmalloc(sizeof(unsigned long) * buffer_size);
 	if (!event_buffer)
-		goto out;
+		return -ENOMEM;
 
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 
 
@@ -100,6 +103,7 @@ void free_event_buffer(void)
 {
 	mutex_lock(&buffer_mutex);
 	vfree(event_buffer);
+	buffer_pos = 0;
 	event_buffer = NULL;
 	mutex_unlock(&buffer_mutex);
 }
@@ -174,6 +178,7 @@ static ssize_t event_buffer_read(struct file *file, char __user *buf,
 
 	mutex_lock(&buffer_mutex);
 
+	/* May happen if the buffer is freed during pending reads. */
 	if (!event_buffer) {
 		retval = -EINTR;
 		goto out;
-- 
1.6.5.rc2


