Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZKCJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZKCJwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZKCJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:52:36 -0500
Received: from relay.parallels.com ([195.214.232.42]:34147 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZKCJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:52:34 -0500
X-Greylist: delayed 941 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 04:52:34 EST
From: "Denis V. Lunev" <den@openvz.org>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 1/2] Crash in linux kernel when disconnecting usb storage
Date: Tue, 3 Nov 2009 12:36:35 +0300
Message-ID: <1257240996-23118-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

__scsi_remove_device() in scsi_forget_host() is executed out of scan_mutex
and races with scsi_destroy_sdev() <- scsi_sysfs_add_devices()
<- scsi_finish_async_scan(). The result is use after free and/or
double free, oops.

The fix is simple, move scsi_forget_host() under scan_mutex.

scsi_forget_host() is just sequence of __scsi_remove_device().
All another calls of __scsi_remove_device() are made under scan_mutex.
So that it is safe.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: James E.J. Bottomley <James.Bottomley@suse.de>
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5fd2da4..c968cc3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -164,8 +164,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
 	scsi_forget_host(shost);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-- 
1.6.4.4

