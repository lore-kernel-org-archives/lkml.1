Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZHMTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZHMTr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbZHMTrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:53 -0400
Received: from kroah.org ([198.145.64.141]:36738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbZHMTrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:37 2009
Message-Id: <20090813194337.191574540@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 12/28] ieee1394: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=ieee1394-sbp2-add-support-for-disks-2-tb.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit ebbb16bffa646f853899ef3fdc0ac7abab888703 upstream.

Increase the command ORB data structure to transport up to 16 bytes long
CDBs (instead of 12 bytes), and tell the SCSI mid layer about it.  This
is notably necessary for READ CAPACITY(16) and friends, i.e. support of
large disks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/sbp2.c |    1 +
 drivers/ieee1394/sbp2.h |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -874,6 +874,7 @@ static struct sbp2_lu *sbp2_alloc_device
 	}
 
 	shost->hostdata[0] = (unsigned long)lu;
+	shost->max_cmd_len = SBP2_MAX_CDB_SIZE;
 
 	if (!scsi_add_host(shost, &ud->device)) {
 		lu->shost = shost;
--- a/drivers/ieee1394/sbp2.h
+++ b/drivers/ieee1394/sbp2.h
@@ -25,6 +25,12 @@
 #define SBP2_DEVICE_NAME		"sbp2"
 
 /*
+ * There is no transport protocol limit to the CDB length,  but we implement
+ * a fixed length only.  16 bytes is enough for disks larger than 2 TB.
+ */
+#define SBP2_MAX_CDB_SIZE		16
+
+/*
  * SBP-2 specific definitions
  */
 
@@ -51,7 +57,7 @@ struct sbp2_command_orb {
 	u32 data_descriptor_hi;
 	u32 data_descriptor_lo;
 	u32 misc;
-	u8 cdb[12];
+	u8 cdb[SBP2_MAX_CDB_SIZE];
 } __attribute__((packed));
 
 #define SBP2_LOGIN_REQUEST		0x0


