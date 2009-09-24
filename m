Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZIXBMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZIXBMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZIXBMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:12:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZIXBMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:12:43 -0400
Message-ID: <4ABAC6F9.9060406@cn.fujitsu.com>
Date: Thu, 24 Sep 2009 09:10:17 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [PATCH] io-controller: Fix task hanging when there are more	than
 one groups
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA4B905.8010801@cn.fujitsu.com> <20090908191941.GF15974@redhat.com> <4AA75B71.5060109@cn.fujitsu.com> <20090909150537.GD8256@redhat.com> <4AA9A4BE.30005@cn.fujitsu.com> <20090915033739.GA4054@redhat.com>
In-Reply-To: <20090915033739.GA4054@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Currently, we just set this flag when anticipating next request.
So make sure we remove this flag also in this case.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/as-iosched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 5868e72..7a64232 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -728,9 +728,10 @@ static void as_antic_stop(struct as_data *ad)
 	as_log(ad, "as_antic_stop antic_status=%d", ad->antic_status);
 
 	if (status == ANTIC_WAIT_REQ || status == ANTIC_WAIT_NEXT) {
-		if (status == ANTIC_WAIT_NEXT)
+		if (status == ANTIC_WAIT_NEXT) {
 			del_timer(&ad->antic_timer);
-		as_clear_active_asq_wait_request(ad);
+			as_clear_active_asq_wait_request(ad);
+		}
 		ad->antic_status = ANTIC_FINISHED;
 		/* see as_work_handler */
 		kblockd_schedule_work(ad->q, &ad->antic_work);
-- 
1.5.4.rc3


