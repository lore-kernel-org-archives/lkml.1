Return-Path: <linux-kernel-owner+w=401wt.eu-S1765600AbYCSXle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765600AbYCSXle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYCSWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:10:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762077AbYCSWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:10:19 -0400
Date: Wed, 19 Mar 2008 18:10:37 -0500 (EST)
Message-Id: <20080319.181037.78496647.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com,
       linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [RFC PATCH 08/13] dm: add target interfaces
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds target interfaces for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/device-mapper.h |   12 ++++++++++++
 1 files changed, 12 insertions(+)

Index: 2.6.25-rc5/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/device-mapper.h
+++ 2.6.25-rc5/include/linux/device-mapper.h
@@ -10,6 +10,7 @@
 
 #ifdef __KERNEL__
 
+struct request;
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -45,6 +46,9 @@ typedef void (*dm_dtr_fn) (struct dm_tar
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
 
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
+				  union map_info *map_context);
+
 /*
  * Returns:
  * < 0 : error (currently ignored)
@@ -57,6 +61,10 @@ typedef int (*dm_endio_fn) (struct dm_ta
 			    struct bio *bio, int error,
 			    union map_info *map_context);
 
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+				    struct request *clone, int error,
+				    union map_info *map_context);
+
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
@@ -71,6 +79,7 @@ typedef int (*dm_message_fn) (struct dm_
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 			    struct file *filp, unsigned int cmd,
 			    unsigned long arg);
+typedef int (*dm_congested_fn) (struct dm_target *ti);
 
 void dm_error(const char *message);
 
@@ -98,7 +107,9 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
+	dm_request_endio_fn rq_end_io;
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
@@ -107,6 +118,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
+	dm_congested_fn congested;
 };
 
 struct io_restrictions {
