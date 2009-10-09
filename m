Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbZJITsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbZJITsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbZJITsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:48:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13004 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587AbZJITst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:48:49 -0400
X-SpamScore: 9
X-BigFish: VPS9(zza4b1ozz1202hzzz32i2a8I6bh87h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KR9J00-03-1KF-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       David Rientjes <rientjes@google.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] oprofile: fix race condition in event_buffer free
Date: Fri, 9 Oct 2009 21:33:29 +0200
Message-ID: <1255116810-26514-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <20091009160532.GD638@erda.amd.com>
References: <20091009160532.GD638@erda.amd.com>
X-OriginalArrivalTime: 09 Oct 2009 19:47:57.0001 (UTC) FILETIME=[66223B90:01CA4919]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

Looking at the 2.6.31-rc9 code, it appears there is a race condition
in the event_buffer cleanup code path (shutdown). This could lead to
kernel panic as some CPUs may be operating on the event buffer AFTER
it has been freed. The attached patch solves the problem and makes
sure CPUs check if the buffer is not NULL before they access it as
some may have been spinning on the mutex while the buffer was being
freed.

The race may happen if the buffer is freed during pending reads. But
it is not clear why there are races in add_event_entry() since all
workqueues or handlers are canceled or flushed before the event buffer
is freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/event_buffer.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 2b7ae36..c38adb3 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -41,6 +41,12 @@ static atomic_t buffer_ready = ATOMIC_INIT(0);
  */
 void add_event_entry(unsigned long value)
 {
+	/*
+	 * catch potential error
+	 */
+	if (!event_buffer)
+		return;
+
 	if (buffer_pos == buffer_size) {
 		atomic_inc(&oprofile_stats.event_lost_overflow);
 		return;
@@ -92,9 +98,10 @@ out:
 
 void free_event_buffer(void)
 {
+	mutex_lock(&buffer_mutex);
 	vfree(event_buffer);
-
 	event_buffer = NULL;
+	mutex_unlock(&buffer_mutex);
 }
 
 
@@ -167,6 +174,11 @@ static ssize_t event_buffer_read(struct file *file, char __user *buf,
 
 	mutex_lock(&buffer_mutex);
 
+	if (!event_buffer) {
+		retval = -EINTR;
+		goto out;
+	}
+
 	atomic_set(&buffer_ready, 0);
 
 	retval = -EFAULT;
-- 
1.6.5.rc2


