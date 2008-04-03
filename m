Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbYDCTpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbYDCTpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762793AbYDCTia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:38:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:27661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762979AbYDCTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gVGJ6X0tQzrLKsNCHZVHGh121MQnMplxaAnlta6qS16BesPODywbpFqaNb3dn2T0Ks5vlyj3bNr681dsKa3v85RL1HF4UQkq5uIioSUqldTpEhSVaCm7wred9zwnSxNqaAc+dh5f+vnPXNtMfVtCux3W9+WHCGAnq8w3dF5Zxps=
Subject: [PATCH] mtd/chips: add missing set_current_state() to
	cfi_{amdstd,staa}_sync()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 03 Apr 2008 21:38:23 +0200
Message-Id: <1207251503.6300.9.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [mtd/chips] add missing set_current_state() to cfi_{amdstd,staa}_sync()

cfi_amdstd_sync() and cfi_staa_sync() call schedule() without changing
task's state appropriately.

In case of e.g. chip->state == FL_ERASING, cfi_*_sync() will be busy-looping
either redundantly for a fixed interval of time (for SCHED_NORMAL tasks) or
possibly endlessly (for RT tasks and UP).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index d072e87..458d477 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1763,6 +1763,7 @@ static void cfi_amdstd_sync (struct mtd_info *mtd)
 
 		default:
 			/* Not an idle state */
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
 			spin_unlock(chip->mutex);
diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index b344ff8..492e2ab 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -1015,6 +1015,7 @@ static void cfi_staa_sync (struct mtd_info *mtd)
 
 		default:
 			/* Not an idle state */
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
 			spin_unlock_bh(chip->mutex);


