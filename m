Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbXKNTsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbXKNTsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXKNTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:47:59 -0500
Received: from mail0.lsil.com ([147.145.40.20]:47956 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXKNTr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:47:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] MegaRAID SAS: Convert aen_mutex to the mutex API
Date: Wed, 14 Nov 2007 12:47:40 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501CE4C87@NAMAIL1.ad.lsil.com>
In-Reply-To: <20071027074846.GQ9824@traven>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] MegaRAID SAS: Convert aen_mutex to the mutex API
Thread-Index: AcgYbdIUU7COwoUDQjWqTZcg5XXP2QOiRXsw
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "DL-MegaRAID Linux" <megaraidlinux@lsi.com>,
       <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Nov 2007 19:47:42.0876 (UTC) FILETIME=[389EADC0:01C826F7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Thanks.

Bo Yang 

-----Original Message-----
From: Matthias Kaehlcke [mailto:matthias.kaehlcke@gmail.com] 
Sent: Saturday, October 27, 2007 3:49 AM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; Andrew Morton
Subject: [PATCH] MegaRAID SAS: Convert aen_mutex to the mutex API

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
@@ -2358,7 +2359,7 @@ megasas_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 
 	spin_lock_init(&instance->cmd_pool_lock);
 
-	sema_init(&instance->aen_mutex, 1);
+	mutex_init(&instance->aen_mutex);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
 	/*
@@ -2874,10 +2875,10 @@ static int megasas_mgmt_ioctl_aen(struct file
*file, unsigned long arg)
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
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.h
b/drivers/scsi/megaraid/megaraid_sas.h
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
