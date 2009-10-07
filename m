Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZJGVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZJGVRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZJGVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:17:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:59980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZJGVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=RQGCxhgdEg0uRdAsLn4+J69QqqHHVcktVXfKmscTjRD8d5x9x5O4wEwe9UdGnVP3Pf
         MjZIPxOCSdAI0lMq6m6kc9bAjZCQ1Ecn2nqvUSOFW/kjo73LnFwbAJ25izusra+g/MdX
         yDLe81vzDBDpaprOTZTpWuNikwJgTeoMkebr0=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH v2] cfq-iosched: avoid probable slice overrun when idling
Date: Wed, 7 Oct 2009 23:15:41 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc3cz; KDE/4.2.4; i686; ; )
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
References: <200910071059.01146.czoccolo@gmail.com> <20091007175112.GI8703@kernel.dk> <4e5e476b0910071230x4adf48eava152bebb149d53e4@mail.gmail.com>
In-Reply-To: <4e5e476b0910071230x4adf48eava152bebb149d53e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910072315.42047.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle timer is not armed if remaining slice is less than average think
time.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b35cc56..af1d621 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1099,6 +1099,14 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
 		return;
 
+	/*
+	 * think time is greater than remaining time slice
+	 * don't idle, to avoid overrunnig the time slice
+	 */
+	if (sample_valid(cic->ttime_samples) &&
+		(cfqq->slice_end - jiffies < cic->ttime_mean))
+		return;
+
 	cfq_mark_cfqq_wait_request(cfqq);
 
 	/*
-- 
1.6.2.5


