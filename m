Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbYCVCkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbYCVCkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYCVCiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:38:20 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18672 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbYCVCiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:references:to:date:message-id:sender;
        b=kfmLl/KentWf7uV7AnYmW2spE4iiHWSGqG7HfzwHqzlg5lYteK1gXXpac05JLUpfgrbHDmmapGM5tvdaEdEV+Ev+5whtlm6fpRbLZOHucsDipVt2p6c5+MSD0QMe/QwEmqPCciO8Z5/M267ar0GQoZ3UQry90I2zxrgMnfSZqfk=
Subject: [RFC][PATCH 8/9] cgroups: block: cfq: I/O bandwidth controlling subsystem for CGroups based on CFQ
From: Vasily Tarasov <vtaras@openvz.org>
References: <1203058414.042372.2088.nullmailer@me>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org
Date: Fri, 15 Feb 2008 01:59:55 -0500
Message-Id: <1203058795.616463.2151.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

Configurable cgroup time slice support.

Signed-off-by: Vasily Tarasov <vtaras@openvz.org>

---

--- linux-2.6.25-rc5-mm1/block/cfq-iosched.c.slice	2008-02-15 01:11:45.000000000 -0500
+++ linux-2.6.25-rc5-mm1/block/cfq-iosched.c	2008-02-15 01:12:22.000000000 -0500
@@ -2150,6 +2150,7 @@ SHOW_FUNCTION(cfq_slice_idle_show, cfqd-
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
+SHOW_FUNCTION(cfq_cgrp_slice_show, cfqd->cfqio_cgrp_slice, 1);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -2181,6 +2182,7 @@ STORE_FUNCTION(cfq_slice_sync_store, &cf
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
+STORE_FUNCTION(cfq_cgrp_slice_store, &cfqd->cfqio_cgrp_slice, 1, UINT_MAX, 1);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -2196,6 +2198,7 @@ static struct elv_fs_entry cfq_attrs[] =
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(cgrp_slice),
 	__ATTR_NULL
 };
 
