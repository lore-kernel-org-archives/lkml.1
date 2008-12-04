Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYLDGpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYLDGpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYLDGnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:58967 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbYLDGnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=s6X5SKB+1eguRjySOKHVq4faRyO6f6mJiE2MnMFGdi2L0hOKg3akGW0qLm36894rp2
         hEIlC9CdfJe+AarZVZh9+KAi+YwZQF541aAFxa/8Ar/8TevcTrxyBB7t/DKHmsq+yoNL
         p71SKRxhff3svQepHGqPbK1v54191RKz3nw44=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 6/6] ide-atapi: teach ide atapi about drive->waiting_for_dma
Date: Thu,  4 Dec 2008 07:43:29 +0100
Message-Id: <1228373010-20249-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition, we wait for DRQ to be asserted by repeatedly polling
device status no matter what DRQ type each device implements.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index bb867a0..a43bed3 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -543,6 +543,11 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		return startstop;
 	}
 
+	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+		if (drive->dma)
+			drive->waiting_for_dma = 1;
+	}
+
 	ireason = ide_read_ireason(drive);
 	if (drive->media == ide_tape &&
 	    (drive->dev_flags & IDE_DFLAG_SCSI) == 0)
@@ -639,6 +644,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+		if (drive->dma)
+			drive->waiting_for_dma = 0;
 		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
 				    timeout, expiry);
 		return ide_started;
-- 
1.6.0.4

