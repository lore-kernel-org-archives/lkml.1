Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYCVClL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYCVClL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbYCVCiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:38:25 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18672 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbYCVCiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:references:to:date:message-id:sender;
        b=DaAI+dKC4T0keY+yeF30rgWKD1sXQRtfR/6x/uGxKrTfSIEm8l0b0l21TbKG10A9hQVHkkSJjPHsfn6G0KSjKbuNw6aytn7v52d6UbdWcEYy6+odYvl/lOfeq1e25k82e0yrBjLUDW2XH3fNBI1TCwbh0SoUZ6d8umdX5XxqEoU=
Subject: [RFC][PATCH 7/9] cgroups: block: cfq: I/O bandwidth controlling subsystem for CGroups based on CFQ
From: Vasily Tarasov <vtaras@openvz.org>
References: <1203058414.042372.2088.nullmailer@me>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org
Date: Fri, 15 Feb 2008 01:59:53 -0500
Message-Id: <1203058793.823542.2149.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

Takes into account requests that are in driver now. Before that we switched
cgroup if there were no requests to service in this cgroup. Now we also
check that there are no requests from this cgroups currently processed by
driver and only in this case allow switching.

Signed-off-by: Vasily Tarasov <vtaras@openvz.org>

---

--- linux-2.6.25-rc5-mm1/include/linux/cfq-iosched.h.rqindrv	2008-02-15 01:10:42.000000000 -0500
+++ linux-2.6.25-rc5-mm1/include/linux/cfq-iosched.h	2008-02-15 01:11:45.000000000 -0500
@@ -57,6 +57,7 @@ struct cfqio_cgroup_data {
 	/* rr list of queues with requests */
 	struct cfq_rb_root	service_tree;
 	unsigned long		rqnum;
+	unsigned long		on_dispatch;
 };
 
 /*
--- linux-2.6.25-rc5-mm1/block/cfq-iosched.c.rqindrv	2008-02-15 01:10:42.000000000 -0500
+++ linux-2.6.25-rc5-mm1/block/cfq-iosched.c	2008-02-15 01:11:45.000000000 -0500
@@ -823,6 +823,7 @@ static void cfq_dispatch_insert(struct r
 
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
+	cfqq->cfqio_cgrp->on_dispatch++;
 	elv_dispatch_sort(q, rq);
 
 	if (cfq_cfqq_sync(cfqq))
@@ -1775,6 +1776,7 @@ static void cfq_completed_request(struct
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
+	cfqq->cfqio_cgrp->on_dispatch--;
 
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight--;
--- linux-2.6.25-rc5-mm1/block/cfqio-cgroup.c.rqindrv	2008-02-15 01:10:42.000000000 -0500
+++ linux-2.6.25-rc5-mm1/block/cfqio-cgroup.c	2008-02-15 01:11:45.000000000 -0500
@@ -54,7 +54,8 @@ static inline void set_active_cgrp(struc
 void cfqio_cgrp_schedule_active(struct cfq_data *cfqd)
 {
 	if (cfqio_cgrp_expired(cfqd) || !cfqd->active_cfqio_cgroup ||
-				!cfqd->active_cfqio_cgroup->rqnum)
+		(!cfqd->active_cfqio_cgroup->rqnum &&
+			!cfqd->active_cfqio_cgroup->on_dispatch))
 		set_active_cgrp(cfqd);
 }
 
