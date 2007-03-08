Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXCHJYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXCHJYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030400AbXCHJYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:24:03 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12581 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030389AbXCHJYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:24:00 -0500
Date: Thu, 8 Mar 2007 17:22:07 +0800
From: Joe Jin <joe.jin@oracle.com>
To: akpm@osdl.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       haobo.zhou@oracle.com
Subject: [PATCH] [scsi]: Add offline state checking while dispatch a scsi cmd
Message-ID: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While a scsi device hw error occured, device's status maybe setting 
to SDEV_OFFLINE, So at scsi_dispatch_cmd function, we should checking
if device have offline, if yes, do nothing and just return error to
user directly.


Signed-off-by: Joe Jin <lkmaillist@gmail.com>
--
--- linux-2.6.21-rc2/drivers/scsi/scsi.c.orig	2007-03-08 16:50:14.000000000 +0800
+++ linux-2.6.21-rc2/drivers/scsi/scsi.c	2007-03-08 16:52:45.000000000 +0800
@@ -486,10 +486,12 @@
 	int rtn = 0;
 
 	/* check if the device is still usable */
-	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
-		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
-		 * returns an immediate error upwards, and signals
-		 * that the device is no longer present */
+	if (unlikely(cmd->device->sdev_state == SDEV_DEL || 
+		     cmd->device->sdev_state == SDEV_OFFLINE)) {
+		/* in SDEV_DEL or SDEV_OFFLINE we error all commands. 
+		 * DID_NO_CONNECT returns an immediate error upwards,
+		 * and signals that the device is no longer present 
+		 */
 		cmd->result = DID_NO_CONNECT << 16;
 		atomic_inc(&cmd->device->iorequest_cnt);
 		__scsi_done(cmd);

