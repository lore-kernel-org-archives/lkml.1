Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZIRD64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZIRD64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZIRD6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:58:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53838 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZIRD6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:58:53 -0400
Message-ID: <4AB30508.6010206@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 11:56:56 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] io-controller: Fix another bug that causing system hanging
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-12-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...

>   * If io scheduler has functionality of keeping track of close cooperator, check
>   * with it if it has got a closely co-operating queue.
> @@ -2057,6 +2171,7 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  {
>  	struct elv_fq_data *efqd = q->elevator->efqd;
>  	struct io_queue *new_ioq = NULL, *ioq = elv_active_ioq(q->elevator);
> +	struct io_group *iog;
>  
>  	if (!elv_nr_busy_ioq(q->elevator))
>  		return NULL;
> @@ -2064,6 +2179,8 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  	if (ioq == NULL)
>  		goto new_queue;
>  
> +	iog = ioq_to_io_group(ioq);
> +
>  	/*
>  	 * Force dispatch. Continue to dispatch from current queue as long
>  	 * as it has requests.
> @@ -2075,11 +2192,47 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  			goto expire;
>  	}
>  
> +	/* We are waiting for this group to become busy before it expires.*/
> +	if (elv_iog_wait_busy(iog)) {
> +		ioq = NULL;
> +		goto keep_queue;
> +	}
> +
>  	/*
>  	 * The active queue has run out of time, expire it and select new.
>  	 */
> -	if (elv_ioq_slice_used(ioq) && !elv_ioq_must_dispatch(ioq))
> -		goto expire;
> +	if ((elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq))
> +	     && !elv_ioq_must_dispatch(ioq)) {
> +		/*
> +		 * Queue has used up its slice. Wait busy is not on otherwise
> +		 * we wouldn't have been here. If this group will be deleted
> +		 * after the queue expiry, then make sure we have onece
> +		 * done wait busy on the group in an attempt to make it
> +		 * backlogged.
> +		 *
> +		 * Following check helps in two conditions.
> +		 * - If there are requests dispatched from the queue and
> +		 *   select_ioq() comes before a request completed from the
> +		 *   queue and got a chance to arm any of the idle timers.
> +		 *
> +		 * - If at request completion time slice had not expired and
> +		 *   we armed either a ioq timer or group timer but when
> +		 *   select_ioq() hits, slice has expired and it will expire
> +		 *   the queue without doing busy wait on group.
> +		 *
> +		 * In similar situations cfq lets delte the queue even if
> +		 * idle timer is armed. That does not impact fairness in non
> +		 * hierarhical setup due to weighted slice lengths. But in
> +		 * hierarchical setup where group slice lengths are derived
> +		 * from queue and is not proportional to group's weight, it
> +		 * harms the fairness of the group.
> +		 */
> +		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog)) {

Hi Vivek,

Here is another bug which will cause task hanging when accessing into a certain disk.
For the moment, last ioq(corresponding CGroup has been removed) is optimized not to 
expire unitl another ioq get backlogged. Here just checking "iog_wait_busy_done" flag
is not sufficient, because idle timer can be inactive at that moment. This will cause
the ioq keeping service all the time and won't stop, causing the whole system hanging. 
This patch adds extra check for "iog_wait_busy" to make sure that the idle timer is 
pending, and this ioq will be expired after timer is up.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 40d0eb5..c039ba2 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3364,7 +3364,8 @@ void *elv_select_ioq(struct request_queue *q, int force)
 		 * harms the fairness of the group.
 		 */
 		slice_expired = 1;
-		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog)) {
+		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog) &&
+		    elv_iog_wait_busy(iog)) {
 			ioq = NULL;
 			goto keep_queue;
 		} else
-- 
1.5.4.rc3




