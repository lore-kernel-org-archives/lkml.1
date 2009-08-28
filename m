Return-Path: <linux-kernel-owner+w=401wt.eu-S1751163AbZH1BPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbZH1BPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZH1BPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:15:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZH1BPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:15:44 -0400
Message-ID: <4A972F19.4090408@cn.fujitsu.com>
Date: Fri, 28 Aug 2009 09:12:57 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 11/24] io-controller: Introduce group idling
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-12-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-150567-188019-139010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> @@ -2201,13 +2362,44 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  		 * mean seek distance, give them a chance to run instead
>  		 * of idling.
>  		 */
> -		if (elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq))
> +		if (elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq)) {
> +			/*
> +			 * This is the last empty queue in the group and it
> +			 * has consumed its slice. If we expire it right away
> +			 * group might loose its share. Wait for an extra
> +			 * group_idle period for a request before queue
> +			 * expires.
> +			 */
> +			if (elv_iog_should_idle(ioq)) {
> +				elv_iog_arm_slice_timer(q, iog, 1);
> +				goto done;
> +			}
> +

Hi Vivek,

I think we shouldn't arm idle timer on iog again, if it's already on.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index a4161c2..04f646f 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3116,7 +3116,8 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			 * group_idle period for a request before queue
 			 * expires.
 			 */
-			if (elv_iog_should_idle(ioq)) {
+			if (elv_iog_should_idle(ioq) &&
+			    !elv_iog_wait_busy(iog)) {
 				elv_iog_arm_slice_timer(q, iog, 1);
 				goto done;
 			}
-- 
1.5.4.rc3



