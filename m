Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYJEWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYJEWRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYJEWQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:16:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:18920 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYJEWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ZTo6iBg1N5HSD8rD7m72si9WLRoxDZ1OsvnWH2MB8yqlImkpn24lYIsg/r8XnJJmRG
         aMpxzcuJcDRrzSazcodkKSmQcdUcK8NIOknLGbKUY/uKlPoT73f3mT3VJan0n2YOiWqt
         T8h5mW6VNOt04VNWpKXIR9N39SjcOm3cXsCq8=
Message-ID: <4b6fba110810051516q72f890e2x8805dd7a0753a8ba@mail.gmail.com>
Date: Sun, 5 Oct 2008 18:16:57 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix infinite loop in INFTL_foldchain() in drivers/mtd/inftlcore.c
Cc: gerg@snapgear.com, dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 6aff882e75043d47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch to fix an infinite loop in the last loop of
INFTL_foldchain() in drivers/mtd/inftlcore.c modified against Linus'
kernel tree.  If INFTL_formatblock() fails repeatedly, this last loop
will go forever because PUtable[thisEUN] is only checked against
BLOCK_NIL and not BLOCK_RESERVED, and if the block fails to format,
PUtable[prevEUN] is not set to BLOCK_NIL.

This will update the in memory copy of the PUchain, but it should be
verified that when the system reboots and the inftl device is
remounted, that the code will properly construct the PUchain from the
device.  I do not have the expertise to verify this myself, so perhaps
somebody else should.  A couple other people and I will try to take a
look at it over the next couple days, but make no guarantees.

-Daniel


Patch:
--------------------------

>From 8f1275749768d316788194cc198093b00f85d0d6 Mon Sep 17 00:00:00 2001
From: Daniel Rosenthal <danielrosenthal@acm.org>
Date: Sun, 5 Oct 2008 17:43:10 -0400
Subject: [PATCH] Fix infinite loop in INFTL_foldchain in
drivers/mtd/inftlcore.c.


Signed-off-by: Daniel Rosenthal <danielrosenthal@acm.org>
---
 drivers/mtd/inftlcore.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index c4f9d33..50ce138 100644
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -388,6 +388,10 @@ static u16 INFTL_foldchain(struct INFTLrecord
*inftl, unsigned thisVUC, unsigned
 		if (thisEUN == targetEUN)
 			break;

+		/* Unlink the last block from the chain. */
+		inftl->PUtable[prevEUN] = BLOCK_NIL;
+
+		/* Now try to erase it. */
 		if (INFTL_formatblock(inftl, thisEUN) < 0) {
 			/*
 			 * Could not erase : mark block as reserved.
@@ -396,7 +400,6 @@ static u16 INFTL_foldchain(struct INFTLrecord
*inftl, unsigned thisVUC, unsigned
 		} else {
 			/* Correctly erased : mark it as free */
 			inftl->PUtable[thisEUN] = BLOCK_FREE;
-			inftl->PUtable[prevEUN] = BLOCK_NIL;
 			inftl->numfreeEUNs++;
 		}
 	}
-- 
1.5.6.4
