Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZHMT77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZHMT77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbZHMT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:55 -0400
Received: from kroah.org ([198.145.64.141]:41864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbZHMT7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:31 2009
Message-Id: <20090813195131.830210237@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 49/74] firewire: sbp2: add support for disks >2 TB (and 16 bytes long CDBs)
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=firewire-sbp2-add-support-for-disks-2-tb.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit af2719415a5ceae06f2a6d33e78b555e64697fc8 upstream.

Increase the command ORB data structure to transport up to 16 bytes long
CDBs (instead of 12 bytes), and tell the SCSI mid layer about it.  This
is notably necessary for READ CAPACITY(16) and friends, i.e. support of
large disks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -190,6 +190,12 @@ struct sbp2_target {
 #define SBP2_CYCLE_LIMIT		(0xc8 << 12)	/* 200 125us cycles */
 
 /*
+ * There is no transport protocol limit to the CDB length,  but we implement
+ * a fixed length only.  16 bytes is enough for disks larger than 2 TB.
+ */
+#define SBP2_MAX_CDB_SIZE		16
+
+/*
  * The default maximum s/g segment size of a FireWire controller is
  * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
  * be quadlet-aligned, we set the length limit to 0xffff & ~3.
@@ -301,7 +307,7 @@ struct sbp2_command_orb {
 		struct sbp2_pointer next;
 		struct sbp2_pointer data_descriptor;
 		__be32 misc;
-		u8 command_block[12];
+		u8 command_block[SBP2_MAX_CDB_SIZE];
 	} request;
 	struct scsi_cmnd *cmd;
 	scsi_done_fn_t done;
@@ -1135,6 +1141,8 @@ static int sbp2_probe(struct device *dev
 	if (fw_device_enable_phys_dma(device) < 0)
 		goto fail_shost_put;
 
+	shost->max_cmd_len = SBP2_MAX_CDB_SIZE;
+
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 


