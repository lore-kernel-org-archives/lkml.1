Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbXJ0Hsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbXJ0Hsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXJ0Hsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:48:35 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:54104 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXJ0Hse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:48:34 -0400
Date: Sat, 27 Oct 2007 09:48:46 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MegaRAID SAS: Convert aen_mutex to the mutex API
Message-ID: <20071027074846.GQ9824@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MegaRAID SAS: Convert aen_mutex to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

index e3c5c52..3ad379f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -31,6 +31,7 @@
 #include <linux/moduleparam.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/uio.h>
@@ -2358,7 +2359,7 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	spin_lock_init(&instance->cmd_pool_lock);
 
-	sema_init(&instance->aen_mutex, 1);
+	mutex_init(&instance->aen_mutex);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
 	/*
@@ -2874,10 +2875,10 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	if (!instance)
 		return -ENODEV;
 
-	down(&instance->aen_mutex);
+	mutex_lock(&instance->aen_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
 				     aen.class_locale_word);
-	up(&instance->aen_mutex);
+	mutex_unlock(&instance->aen_mutex);
 	return error;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4dffc91..08c74c9 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1089,7 +1089,7 @@ struct megasas_instance {
 	struct megasas_evt_detail *evt_detail;
 	dma_addr_t evt_detail_h;
 	struct megasas_cmd *aen_cmd;
-	struct semaphore aen_mutex;
+	struct mutex aen_mutex;
 	struct semaphore ioctl_sem;
 
 	struct Scsi_Host *host;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera.
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
