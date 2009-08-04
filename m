Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZHDCF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZHDCF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbZHDCF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:05:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZHDCF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:05:56 -0400
Message-ID: <4A779719.1070900@ds.jp.nec.com>
Date: Mon, 03 Aug 2009 22:04:09 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH] io-controller: implement per group request allocation
 limitation
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A569FC5.7090801@cn.fujitsu.com>
In-Reply-To: <4A569FC5.7090801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng wrote, on 07/09/2009 09:56 PM:
> Hi Vivek,
>
> This patch exports a cgroup based per group request limits interface.
> and removes the global one. Now we can use this interface to perform
> different request allocation limitation for different groups.
>
> Signed-off-by: Gui Jianfeng<guijianfeng@cn.fujitsu.com>
(snip)

Hi Jianfeng,

If this helps, again.

A patch posted from Gui Jianfeng on 2009/07/09 adds per-cgroup
nr_requests control by io.nr_group_requests.  The patch missed to update
iog->nr_congestion_{on|off} and this patch adds the missing-link.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
  block/elevator-fq.c |   11 +++++++++++
  1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 673e490..316bd8d 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1607,6 +1607,10 @@ static int io_cgroup_nr_requests_write(struct cgroup *cgroup,
  					u64 val)
  {
  	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct elv_fq_data *efqd;
+	struct request_queue *q;
+	struct hlist_node *n;
  
  	if (val < BLKDEV_MIN_RQ)
  		val = BLKDEV_MIN_RQ;
@@ -1618,6 +1622,13 @@ static int io_cgroup_nr_requests_write(struct cgroup *cgroup,
  
  	spin_lock_irq(&iocg->lock);
  	iocg->nr_group_requests = (unsigned long)val;
+	hlist_for_each_entry(iog, n, &iocg->group_data, group_node) {
+		rcu_read_lock();
+		efqd = rcu_dereference(iog->key);
+		q = efqd->queue;
+		rcu_read_unlock();
+		elv_io_group_congestion_threshold(q, iog);
+	}
  	spin_unlock_irq(&iocg->lock);
  
  	cgroup_unlock();
-- 
1.6.2.5


-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

