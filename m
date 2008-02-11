Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYBKIfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYBKIfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYBKIfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:35:09 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:53883 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYBKIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=tShRzD/BfU0rnsZSATaMuR7m3en1FdjuCXXuwfsLVeDpOouF46vR9IbJCDiYyZE1mT2nG81lpnnAAKr3YsTH3cKdIuRxayioa8tHCdjKnu+sHfTFVRUVUWXF879pml3HrTQ4MYBO3QDsCWNTZUmXN+TIqETEianQ9BBsn0Xz5LU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/4] ide: add generic packet command representation ide_atapi_pc
Date: Mon, 11 Feb 2008 09:34:37 +0100
Message-Id: <1202718880-1793-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new struct unifies ide{-floppy,-tape,-scsi}'s view of a packet command. For now,
it represents the common denominator between the three drivers while adding driver-
specific members at the end of the struct which will be merged/simplified into the
generic ATAPI handling code in later steps, or removed completely.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 include/linux/ide.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index e4eddd4..aae98d7 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -629,6 +629,53 @@ typedef struct ide_settings_s {
 
 int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
 
+struct ide_atapi_pc {
+	/* actual packet bytes */
+	u8 c[12];
+	/* incremented on each retry */
+	int retries;
+	int error;
+
+	/* bytes to transfer */
+	int req_xfer;
+	/* bytes actually transferred */
+	int xferred;
+
+	/* data buffer */
+	u8 *buf;
+	/* current buffer position */
+	u8 *cur_pos;
+	int buf_size;
+	/* missing/available data on the current buffer */
+	int b_count;
+
+	/* the corresponding request */
+	struct request *rq;
+
+	unsigned long flags;
+
+	/*
+	 * those are more or less driver-specific and some of them are subject
+	 * to change/removal later.
+	 */
+	u8 pc_buf[256];
+	void (*idefloppy_callback) (ide_drive_t *);
+	ide_startstop_t (*idetape_callback) (ide_drive_t *);
+
+	/* idetape only */
+	struct idetape_bh *bh;
+	char *b_data;
+
+	/* idescsi only for now */
+	struct scatterlist *sg;
+	unsigned int sg_cnt;
+
+	struct scsi_cmnd *scsi_cmd;
+	void (*done) (struct scsi_cmnd *);
+
+	unsigned long timeout;
+};
+
 /*
  * /proc/ide interface
  */
-- 
1.5.3.7

