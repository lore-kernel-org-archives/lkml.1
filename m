Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYF0CXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYF0CXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYF0CWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:22:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:63768 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYF0CWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:22:54 -0400
Subject: [PATCH]: libata-scsi: Don't start hotplug work queue if hotplug is
	disabled
From: Chunbo Luo <chunbo.luo@windriver.com>
Reply-To: chunbo.luo@windriver.com
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Wind River
Date: Fri, 27 Jun 2008 10:20:46 +0800
Message-Id: <1214533246.6284.10.camel@pek-cluo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 27 Jun 2008 02:22:41.0111 (UTC) FILETIME=[ACD01E70:01C8D7FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

When ata_scsi_scan_host() scan device failed, it will start a work queue
unconditionally. This may cause some noisy messages. This patch fix this
problem.


---
commit 6c686a6814a805782c7ab48ad89352ee309e8c32
Author: Chunbo Luo <chunbo.luo@windriver.com>
Date:   Fri Jun 27 09:56:52 2008 +0800

    libata-scsi: Don't start hotplug work queue if hotplug is disabled
    
    Previously, queue_delayed_work() was started unconditionally, but if
    ATA_PFLAG_SCSI_HOTPLUG is not set and we do this, the work queue may
    cause multiple messages like this:
    
    ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
    
    So now,it is only started when the hotplug flag is actually set.
    
    Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 57a4364..7ed5bb3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3108,8 +3108,9 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
                                "                  switching to async\n");
        }
 
-       queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
-                          round_jiffies_relative(HZ));
+       if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
+               queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+                                  round_jiffies_relative(HZ));
 }
 
 /**
---


Best Regards
Chunbo
