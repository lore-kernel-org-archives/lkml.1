Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZC0HAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZC0HAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZC0HAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:00:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZC0HAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:00:22 -0400
Message-ID: <49CC791A.10008@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 14:58:34 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: [PATCH] IO Controller: No need to stop idling in as
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1236823015-4183-11-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:

>  		.elevator_alloc_sched_queue_fn = as_alloc_as_queue,
>  		.elevator_free_sched_queue_fn = as_free_as_queue,
> +#ifdef CONFIG_IOSCHED_AS_HIER
> +		.elevator_expire_ioq_fn =       as_expire_ioq,
> +		.elevator_active_ioq_set_fn =   as_active_ioq_set,
>  	},
> -
> +	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,

  Hi Vivek,

  I found the IO Controller doesn't work in as.
  I dig into this issue, and notice that you stop idling in as. IMHO, this will cause
  active ioq is always expired when tring to choose a new ioq to serve(elv_fq_select_ioq). 
  Because idling is disabled, active ioq can't be kept anymore.
  So i just get rid of ELV_IOSCHED_DONT_IDLE, and it works fine this time.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/as-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 27c14a7..499c521 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1689,7 +1689,7 @@ static struct elevator_type iosched_as = {
 		.elevator_expire_ioq_fn =       as_expire_ioq,
 		.elevator_active_ioq_set_fn =   as_active_ioq_set,
 	},
-	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ | ELV_IOSCHED_DONT_IDLE,
+	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
 #else
 	},
 #endif
-- 
1.5.4.rc3


