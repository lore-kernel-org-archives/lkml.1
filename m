Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZFIH6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZFIH6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZFIH6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:58:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbZFIH6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:58:17 -0400
Message-ID: <4A2E15B6.8030001@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 15:56:38 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 08/18] io-controller: idle for sometime on sync queue
 before expiring it
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-9-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +ssize_t elv_fairness_store(struct request_queue *q, const char *name,
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
> +		data = 0;
> +	else if (data > INT_MAX)
> +		data = INT_MAX;

  Hi Vivek,

  data might overflow on 64 bit systems. In addition, since "fairness" is nothing 
  more than a switch, just let it be.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   10 +++++-----
 block/elevator-fq.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 655162b..42d4279 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2605,7 +2605,7 @@ static inline int is_root_group_ioq(struct request_queue *q,
 ssize_t elv_fairness_show(struct request_queue *q, char *name)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2619,17 +2619,17 @@ ssize_t elv_fairness_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	struct elv_fq_data *efqd;
-	unsigned int data;
+	unsigned long data;
 	unsigned long flags;
 
 	char *p = (char *)name;
 
 	data = simple_strtoul(p, &p, 10);
 
-	if (data < 0)
+	if (!data)
 		data = 0;
-	else if (data > INT_MAX)
-		data = INT_MAX;
+	else
+		data = 1;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	efqd = &q->elevator->efqd;
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index b2bb11a..4fe843a 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -359,7 +359,7 @@ struct elv_fq_data {
 	 * throughput and focus more on providing fairness for sync
 	 * queues.
 	 */
-	int fairness;
+	unsigned long fairness;
 };
 
 extern int elv_slice_idle;
-- 
1.5.4.rc3


