Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0BGLbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:21 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44352 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0BGLbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wqdXws0X4VmCLgbFs93y7kF5Dkgj/YskieQC6WW+P3wTiISaiwJZXKa8lTnT/LnAXR
         mlbropAcrA8Fk7ws1PRwXjCTM/lve4qmUbkil4uJO5159bqBPmpNnf1iwjh/H9omD3+R
         Y0wuM6Ntvy+iyAkxh5VbAy2cSqhr603pk4C1g=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <stijn@stijn.telenet.be>
Subject: [PATCH 1/6] Move poll into perf_event and allow for wakeups when fd has not been mmap'd. This is useful when using read() to read out the current counter value.
Date: Sun,  7 Feb 2010 12:30:54 +0100
Message-Id: <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <stijn@stijn.telenet.be>

---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |   30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..827a221 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -538,7 +538,6 @@ struct perf_mmap_data {
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
 
-	atomic_t			poll;		/* POLL_ for wakeups */
 	atomic_t			events;		/* event_id limit       */
 
 	atomic_long_t			head;		/* write position    */
@@ -639,6 +638,7 @@ struct perf_event {
 	struct perf_mmap_data		*data;
 
 	/* poll related */
+	atomic_t			poll;		/* POLL_ for wakeups */
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e0eb4a2..42dc18d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1919,14 +1919,7 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct perf_mmap_data *data;
-	unsigned int events = POLL_HUP;
-
-	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (data)
-		events = atomic_xchg(&data->poll, 0);
-	rcu_read_unlock();
+	unsigned int events = atomic_xchg(&event->poll, 0);
 
 	poll_wait(file, &event->waitq, wait);
 
@@ -2680,16 +2673,20 @@ static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 	return true;
 }
 
-static void perf_output_wakeup(struct perf_output_handle *handle)
+static void __perf_output_wakeup(struct perf_event* event, int nmi)
 {
-	atomic_set(&handle->data->poll, POLL_IN);
+	atomic_set(&event->poll, POLLIN);
 
-	if (handle->nmi) {
-		handle->event->pending_wakeup = 1;
-		perf_pending_queue(&handle->event->pending,
-				   perf_pending_event);
+	if (nmi) {
+		event->pending_wakeup = 1;
+		perf_pending_queue(&event->pending, perf_pending_event);
 	} else
-		perf_event_wakeup(handle->event);
+		perf_event_wakeup(event);
+}
+
+static void perf_output_wakeup(struct perf_output_handle *handle)
+{
+	__perf_output_wakeup(handle->event, handle->nmi);
 }
 
 /*
@@ -3171,6 +3168,9 @@ static void perf_event_output(struct perf_event *event, int nmi,
 	struct perf_output_handle handle;
 	struct perf_event_header header;
 
+	if (!event->data)
+		return __perf_output_wakeup(event, nmi);
+
 	perf_prepare_sample(&header, data, event, regs);
 
 	if (perf_output_begin(&handle, event, header.size, nmi, 1))
-- 
1.6.6

