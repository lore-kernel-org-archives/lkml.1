Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYCLRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYCLRVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYCLRUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:20:40 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:45674 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYCLRUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:20:39 -0400
Message-ID: <47D810C9.90309@panasas.com>
Date: Wed, 12 Mar 2008 19:20:09 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH ver3] isd200: Allocate sense_buffer for hacked up scsi_cmnd
References: <Pine.LNX.4.44L0.0803121109210.4595-100000@iolanthe.rowland.org>	 <47D7F5A3.9010004@panasas.com> <1205340884.2941.112.camel@localhost.localdomain> <47D80D60.3060006@panasas.com>
In-Reply-To: <47D80D60.3060006@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
own struct scsi_cmnd like here isd200, must also take care of their own
sense_buffer.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 4f2d143..971d13d 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1470,6 +1470,7 @@ static void isd200_free_info_ptrs(void *info_)
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
+		kfree(info->srb.sense_buffer);
 	}
 }
 
@@ -1495,7 +1496,9 @@ static int isd200_init_info(struct us_data *us)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		if (!info->id || !info->RegsBuf) {
+		info->srb.sense_buffer =
+				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
-- 
1.5.3.3


