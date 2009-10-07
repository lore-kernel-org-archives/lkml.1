Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbZJGJAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbZJGJAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbZJGJAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:00:51 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60668 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014AbZJGJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kf91pbtUUC97C8zhha6/HV+/Q7SjPo4/YcCj69QDXViIDOisuYdHYwuoeyhjaIMPSK
         ZFXpq9dU/tDYeVkFoV6QkayVPXSmvSGB8gG2ZFsV5xnLD7q6jaaBw1QiRGSEJsHDZnn0
         EC/PsYZNovM9mVu0+nWfWlK+yAYGT+3FYAt6c=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: fix think time allowed for seekers
Date: Wed, 7 Oct 2009 11:00:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc3cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071100.07980.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ enables idle only for processes that think less than the allowed
idle time. Since idle time is lower for seeky queues, we should use the
correct value in the comparison.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 55bb8ca..4c795a2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1997,7 +1997,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	    (!cfqd->cfq_latency && cfqd->hw_tag && CIC_SEEKY(cic)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
-		if (cic->ttime_mean > cfqd->cfq_slice_idle)
+		unsigned int slice_idle = cfqd->cfq_slice_idle;
+		if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
+			slice_idle = msecs_to_jiffies(CFQ_MIN_TT);
+		if (cic->ttime_mean > slice_idle)
 			enable_idle = 0;
 		else
 			enable_idle = 1;
-- 
1.6.2.5


