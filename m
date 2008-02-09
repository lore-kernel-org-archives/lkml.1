Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYBITnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYBITnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYBITnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:43:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:17501 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYBITnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=hCtU/RZx1JI5J8VoeG7XIT0uP9b+vseSAYssq5+SpJf078mliGgqln2lpewTrlRQJ0JsMqVmmpxGgSNMhy0qfzrkkBY3alnSwOHMIR+v6oBw8so6k1tlwy8QQ7T17Y0zt8Fker+gsTIo/8/G80cU4ONF8zM62TTy6p5myQTEYmE=
Date: Sat, 9 Feb 2008 20:42:48 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide-tape: move all struct and other defs at the top
Message-ID: <20080209194247.GE23177@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <20080206052343.GA14349@gollum.tnic> <20080206052715.GB14349@gollum.tnic> <200802091725.29207.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802091725.29207.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

thanks for the update earlier. I'll look into blk_{get,put}_request later and
try it on idefloppy. In the meantime, here are the patches as requested:

---
>From 0d91862fc802d6f5aa79947b2685de6c209236f2 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 9 Feb 2008 19:48:13 +0100
Subject: [PATCH 1/2] ide-tape: move all struct and other defs at the top

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  107 ++++++++++++++++++++++++-----------------------
 1 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b3269d7..1fff560 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -225,6 +225,61 @@ typedef struct idetape_packet_command_s {
 /* Data direction */
 #define	PC_WRITING			5
 
+/* Tape door status */
+#define DOOR_UNLOCKED			0
+#define DOOR_LOCKED			1
+#define DOOR_EXPLICITLY_LOCKED		2
+
+/*
+ *	Tape flag bits values.
+ */
+#define IDETAPE_IGNORE_DSC		0
+/* 0 When the tape position is unknown */
+#define IDETAPE_ADDRESS_VALID		1
+#define IDETAPE_BUSY			2	/* Device already opened */
+/* Error detected in a pipeline stage */
+#define IDETAPE_PIPELINE_ERROR		3
+/* Attempt to auto-detect the current user block size */
+#define IDETAPE_DETECT_BS		4
+#define IDETAPE_FILEMARK		5	/* Currently on a filemark */
+#define IDETAPE_DRQ_INTERRUPT		6	/* DRQ interrupt device */
+#define IDETAPE_READ_ERROR		7
+#define IDETAPE_PIPELINE_ACTIVE		8	/* pipeline active */
+/* 0 = no tape is loaded, so we don't rewind after ejecting */
+#define IDETAPE_MEDIUM_PRESENT		9
+
+/* Some defines for the SPACE command */
+#define IDETAPE_SPACE_OVER_FILEMARK	1
+#define IDETAPE_SPACE_TO_EOD		3
+
+/* Some defines for the LOAD UNLOAD command */
+#define IDETAPE_LU_LOAD_MASK		1
+#define IDETAPE_LU_RETENSION_MASK	2
+#define IDETAPE_LU_EOT_MASK		4
+
+/*
+ * Special requests for our block device strategy routine.
+ *
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
+ */
+
+enum {
+	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
+	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
+	REQ_IDETAPE_READ	= (1 << 2),
+	REQ_IDETAPE_WRITE	= (1 << 3),
+};
+
+/* Error codes returned in rq->errors to the higher part of the driver. */
+#define	IDETAPE_ERROR_GENERAL		101
+#define	IDETAPE_ERROR_FILEMARK		102
+#define	IDETAPE_ERROR_EOD		103
+
+/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
+#define IDETAPE_BLOCK_DESCRIPTOR	0
+#define	IDETAPE_CAPABILITIES_PAGE	0x2a
+
 /* A pipeline stage. */
 typedef struct idetape_stage_s {
 	struct request rq;			/* The corresponding request */
@@ -446,58 +501,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/* Tape door status */
-#define DOOR_UNLOCKED			0
-#define DOOR_LOCKED			1
-#define DOOR_EXPLICITLY_LOCKED		2
-
-/*
- *	Tape flag bits values.
- */
-#define IDETAPE_IGNORE_DSC		0
-#define IDETAPE_ADDRESS_VALID		1	/* 0 When the tape position is unknown */
-#define IDETAPE_BUSY			2	/* Device already opened */
-#define IDETAPE_PIPELINE_ERROR		3	/* Error detected in a pipeline stage */
-#define IDETAPE_DETECT_BS		4	/* Attempt to auto-detect the current user block size */
-#define IDETAPE_FILEMARK		5	/* Currently on a filemark */
-#define IDETAPE_DRQ_INTERRUPT		6	/* DRQ interrupt device */
-#define IDETAPE_READ_ERROR		7
-#define IDETAPE_PIPELINE_ACTIVE		8	/* pipeline active */
-/* 0 = no tape is loaded, so we don't rewind after ejecting */
-#define IDETAPE_MEDIUM_PRESENT		9
-
-/* Some defines for the SPACE command */
-#define IDETAPE_SPACE_OVER_FILEMARK	1
-#define IDETAPE_SPACE_TO_EOD		3
-
-/* Some defines for the LOAD UNLOAD command */
-#define IDETAPE_LU_LOAD_MASK		1
-#define IDETAPE_LU_RETENSION_MASK	2
-#define IDETAPE_LU_EOT_MASK		4
-
-/*
- * Special requests for our block device strategy routine.
- *
- * In order to service a character device command, we add special requests to
- * the tail of our block device request queue and wait for their completion.
- */
-
-enum {
-	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
-	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
-	REQ_IDETAPE_READ	= (1 << 2),
-	REQ_IDETAPE_WRITE	= (1 << 3),
-};
-
-/* Error codes returned in rq->errors to the higher part of the driver. */
-#define	IDETAPE_ERROR_GENERAL		101
-#define	IDETAPE_ERROR_FILEMARK		102
-#define	IDETAPE_ERROR_EOD		103
-
-/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
-#define IDETAPE_BLOCK_DESCRIPTOR	0
-#define	IDETAPE_CAPABILITIES_PAGE	0x2a
-
 /*
  * The variables below are used for the character device interface. Additional
  * state variables are defined in our ide_drive_t structure.
-- 
1.5.3.7



-- 
Regards/Gruﬂ,
    Boris.
