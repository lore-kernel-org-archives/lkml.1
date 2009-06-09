Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbZFIIq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbZFIIq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZFIIqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:46:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758851AbZFIIqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:46:48 -0400
Message-ID: <4A2E211A.3030303@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 16:45:14 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/19] io-controller: Common flat fair queuing code in
 elevaotor layer
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1244513342-11758-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +ssize_t elv_slice_idle_store(struct request_queue *q, const char *name,
> +			  size_t count)
> +{
> +	struct elv_fq_data *efqd;
> +	unsigned int data;
> +	unsigned long flags;
> +
> +	char *p = (char *)name;
> +
> +	data = simple_strtoul(p, &p, 10);
> +
> +	if (data < 0)

Hi Vivek,

data can never be less than zero. Same problems also exist for other sysfs entry.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   40 +++++++++++++---------------------------
 block/elevator-fq.h |    6 +++---
 2 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 42d4279..8027f4c 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2643,32 +2643,27 @@ ssize_t elv_fairness_store(struct request_queue *q, const char *name,
 ssize_t elv_slice_idle_show(struct request_queue *q, char *name)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	efqd = &q->elevator->efqd;
 	data = jiffies_to_msecs(efqd->elv_slice_idle);
 	spin_unlock_irqrestore(q->queue_lock, flags);
-	return sprintf(name, "%d\n", data);
+	return sprintf(name, "%lu\n", data);
 }
 
 ssize_t elv_slice_idle_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
-		data = 0;
-	else if (data > INT_MAX)
-		data = INT_MAX;
-
 	data = msecs_to_jiffies(data);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2683,32 +2678,27 @@ ssize_t elv_slice_idle_store(struct request_queue *q, const char *name,
 ssize_t elv_async_slice_idle_show(struct request_queue *q, char *name)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	efqd = &q->elevator->efqd;
 	data = jiffies_to_msecs(efqd->elv_async_slice_idle);
 	spin_unlock_irqrestore(q->queue_lock, flags);
-	return sprintf(name, "%d\n", data);
+	return sprintf(name, "%lu\n", data);
 }
 
 ssize_t elv_async_slice_idle_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
-		data = 0;
-	else if (data > INT_MAX)
-		data = INT_MAX;
-
 	data = msecs_to_jiffies(data);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2730,24 +2720,22 @@ ssize_t elv_slice_sync_show(struct request_queue *q, char *name)
 	efqd = &q->elevator->efqd;
 	data = efqd->elv_slice[1];
 	spin_unlock_irqrestore(q->queue_lock, flags);
-	return sprintf(name, "%d\n", data);
+	return sprintf(name, "%lu\n", data);
 }
 
 ssize_t elv_slice_sync_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
-		data = 0;
 	/* 100ms is the limit for now*/
-	else if (data > 100)
+	if (data > 100)
 		data = 100;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2762,31 +2750,29 @@ ssize_t elv_slice_sync_store(struct request_queue *q, const char *name,
 ssize_t elv_slice_async_show(struct request_queue *q, char *name)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	efqd = &q->elevator->efqd;
 	data = efqd->elv_slice[0];
 	spin_unlock_irqrestore(q->queue_lock, flags);
-	return sprintf(name, "%d\n", data);
+	return sprintf(name, "%lu\n", data);
 }
 
 ssize_t elv_slice_async_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
-		data = 0;
 	/* 100ms is the limit for now*/
-	else if (data > 100)
+	if (data > 100)
 		data = 100;
 
 	spin_lock_irqsave(q->queue_lock, flags);
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 4fe843a..46e4dbc 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -338,13 +338,13 @@ struct elv_fq_data {
 	 * have any notion of anticipation/idling. As of now, these are the
 	 * users of this functionality.
 	 */
-	unsigned int elv_slice_idle;
+	unsigned long elv_slice_idle;
 	/* idle slice for async queue */
-	unsigned int elv_async_slice_idle;
+	unsigned long elv_async_slice_idle;
 	struct timer_list idle_slice_timer;
 	struct work_struct unplug_work;
 
-	unsigned int elv_slice[2];
+	unsigned long elv_slice[2];
 
 	/* Fields for keeping track of average disk rate */
 	unsigned long rate_sectors; /* number of sectors finished */
-- 
1.5.4.rc3


