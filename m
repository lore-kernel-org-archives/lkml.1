Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXC3XMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXC3XMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXC3XLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:11:40 -0400
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:2362 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933058AbXC3XLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:11:38 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 19:11:38 EDT
Date: Fri, 30 Mar 2007 15:21:38 -0700
From: "Ed Lin" <ed.lin@promise.com>
To: "linux-scsi" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "james.Bottomley" <james.Bottomley@SteelEye.com>,
       "jeff" <jeff@garzik.org>, "promise_linux" <promise_linux@promise.com>
Subject: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
X-mailer: Foxmail 5.0 [en]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
X-OriginalArrivalTime: 30 Mar 2007 22:21:43.0828 (UTC) FILETIME=[CC0F4D40:01C77319]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After reset completed, the scsi error handler sends out START_STOP
and TEST_UNIT_READY to the device. For 'normal' devices these
commands will be handled by firmware. However, because the RAID
console only interfaces to scsi mid layer, the firmware will not process
these commands for it. This will make the console to be offlined right
after reset. Add the handling in driver to fix this problem.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1e8d7ac..9465f35 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -605,6 +605,14 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			stex_invalid_field(cmd, done);
 		return 0;
 	}
+	case TEST_UNIT_READY:
+	case START_STOP:
+		if (id == ST_MAX_ARRAY_SUPPORTED) {
+			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			done(cmd);
+			return 0;
+		}
+		break;
 	case INQUIRY:
 		if (id != ST_MAX_ARRAY_SUPPORTED)
 			break;


