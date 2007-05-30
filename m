Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXE3ISq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXE3ISq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXE3ISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:18:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXE3ISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:18:31 -0400
Date: Wed, 30 May 2007 04:16:43 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] qla2xxx: fix timeout in qla2x00_down_timeout
Message-ID: <20070530081643.GA29004@nostromo.devel.redhat.com>
Mail-Followup-To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

iterations is unsigned, so it is impossible to get out of the loop
and return -ETIMEDOUT.

Signed-off-by: Bill Nottingham <notting@redhat.com>

---

If the intention *is* to never fall out of the end of the loop, ignore
this, and just replace it with do {} while (1);.

--- drivers/scsi/qla2xxx/qla_os.c.foo	2007-05-30 04:07:52.000000000 -0400
+++ drivers/scsi/qla2xxx/qla_os.c	2007-05-30 04:08:31.000000000 -0400
@@ -2587,15 +2587,15 @@ qla2x00_down_timeout(struct semaphore *s
 	unsigned int iterations = jiffies_to_msecs(timeout)/100;
 
 	do {
 		if (!down_trylock(sema))
 			return 0;
 		if (msleep_interruptible(step))
 			break;
-	} while (--iterations >= 0);
+	} while (--iterations > 0);
 
 	return -ETIMEDOUT;
 }
 
 /* Firmware interface routines. */
 
 #define FW_BLOBS	5
