Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZIWN4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZIWN4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZIWN4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:56:45 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:60342 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZIWN4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:56:44 -0400
Content-Disposition: inline
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: James.Bottomley@hansenpartnership.com, eric@andante.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi_lib.c: sleeping function called from invalid context
Date: Wed, 23 Sep 2009 17:58:47 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909231758.47612.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver scsi_lib.c might sleep in atomic context, because it calls 
scsi_device_put under spin_lock_irqsave.
drivers/scsi/scsi_lib.c:356:
	spin_lock_irqsave(shost->host_lock, flags);
	scsi_device_put(sdev);
Path to might_sleep macro from scsi_device_put:
1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
2. put_device calls kobject_put at ./drivers/base/core.c:1038 
3. kobject_put calls kref_put at ./lib/kobject.c
4. kref_put may call callback function kobject_release at ./lib/kref.c if 
refcount becomes zero, which might_sleep because it calls user event. Details:
	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
	4.3 kobject_uevent_env calls call_usermodehelper_exec at 
./include/linux/kmod.h:83
	4.4 call_usermodehelper_exec calls wait_for_completion at 
./kernel/kmod.c:481
	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692

Found by Linux Driver Verification project.

Delete wrong sleeping function calls.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./a/drivers/scsi/scsi_lib.c b/./b/drivers/scsi/scsi_lib.c
index f3c4089..a8f8e2f 100644
--- a/./a/drivers/scsi/scsi_lib.c
+++ b/./b/drivers/scsi/scsi_lib.c
@@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct scsi_device 
*current_sdev)
 
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		blk_run_queue(sdev->request_queue);
-		spin_lock_irqsave(shost->host_lock, flags);
 	
-		scsi_device_put(sdev);
+		scsi_device_put(sdev);	
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
  out:
 	spin_unlock_irqrestore(shost->host_lock, flags);

