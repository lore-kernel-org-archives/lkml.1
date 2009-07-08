Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZGHCRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZGHCRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZGHCR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:17:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59557 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbZGHCRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:17:24 -0400
Message-ID: <4A54018C.5090804@cn.fujitsu.com>
Date: Wed, 08 Jul 2009 10:16:44 +0800
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
Subject: Re: [PATCH 11/25] io-controller: Export disk time used and nr sectors
 dipatched through cgroups
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1246564917-19603-12-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  
> +static int io_cgroup_disk_time_read(struct cgroup *cgroup,
> +				struct cftype *cftype, struct seq_file *m)
> +{
> +	struct io_cgroup *iocg;
> +	struct io_group *iog;
> +	struct hlist_node *n;
> +
> +	if (!cgroup_lock_live_group(cgroup))
> +		return -ENODEV;
> +
> +	iocg = cgroup_to_io_cgroup(cgroup);
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> +		/*
> +		 * There might be groups which are not functional and
> +		 * waiting to be reclaimed upon cgoup deletion.
> +		 */
> +		if (iog->key) {
> +			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +					MINOR(iog->dev),
> +					iog->entity.total_service);

Hi Vivek,

Let io.disk_*'s outputs conform with io.policy's.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 7c83d1e..29392e7 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1631,7 +1631,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev),
 					iog->entity.total_service);
 		}
@@ -1661,7 +1661,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev),
 					iog->entity.total_sector_service);
 		}
@@ -1692,7 +1692,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev), iog->queue,
 					iog->queue_duration);
 		}
@@ -1722,7 +1722,7 @@ static int io_cgroup_disk_dequeue_read(struct cgroup *cgroup,
 		 * waiting to be reclaimed upon cgoup deletion.
 		 */
 		if (iog->key) {
-			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
 					MINOR(iog->dev), iog->dequeue);
 		}
 	}
-- 
1.5.4.rc3


