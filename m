Return-Path: <linux-kernel-owner+w=401wt.eu-S966426AbZLHVj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966426AbZLHVj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965722AbZLHVjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:39:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16988 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965711AbZLHVjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:39:54 -0500
Subject: [PATCH] cciss: Fix bad scsi status reporting.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
       linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Tue, 08 Dec 2009 15:41:51 -0600
Message-ID: <20091208214151.23672.1572.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Fix bad scsi status reporting.  The SCSI status needs to
be shifted left 1 bit, and only needs to be set once.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 5d0e46d..75a9ca9 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -728,9 +728,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	/* cmd->result |= (GOOD < 1); */		/* status byte */
-
-	cmd->result |= (ei->ScsiStatus);
+	cmd->result |= (ei->ScsiStatus << 1);
 	/* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
 
 	/* copy the sense data whether we need to or not. */
@@ -747,18 +745,8 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
-				if( ei->ScsiStatus)
-                		{
-#if 0
-                    			printk(KERN_WARNING "cciss: cmd %p "
-					"has SCSI Status = %x\n",
-                        			cp,  
-						ei->ScsiStatus); 
-#endif
-					cmd->result |= (ei->ScsiStatus << 1);
-                		}
-				else {  /* scsi status is zero??? How??? */
-					
+				if (ei->ScsiStatus == 0)
+					cmd->result = DID_NO_CONNECT << 16;
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen
 	   if, for example, a 4100 backplane loses power and the tape
@@ -766,9 +754,6 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 	   kind because we can't show that it wasn't. We will make it
 	   look like selection timeout since that is the most common
 	   reason for this to occur, and it's severe enough. */
-
-					cmd->result = DID_NO_CONNECT << 16;
-				}
 			break;
 			case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
 			break;

