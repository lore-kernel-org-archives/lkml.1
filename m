Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXJSQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXJSQps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbXJSQpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:45:38 -0400
Received: from grex.cyberspace.org ([216.86.77.194]:14929 "EHLO
	grex.cyberspace.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbXJSQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:45:38 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 12:45:38 EDT
Date: Fri, 19 Oct 2007 12:17:00 -0400
From: Roopesh <roopesh@cyberspace.org>
To: linux-kernel@vger.kernel.org
Subject: MMC: CRC Errors with 2GB cards
Message-ID: <20071019161700.GA19254@grex.cyberspace.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi, 

 I am seeing a lot of CRC errors happening with CMD25 on a couple 
 of Transcend 2GB cards (specifiation version 1.1).  However, if 
 I apply the following patch, I see no errors being reported


--- linux-2.6.22/drivers/mmc/card/block.c	2007-09-27 14:59:44.000000000 +0530
+++ linux-tao/drivers/mmc/card/block.c	2007-10-19 20:53:52.000000000 +0530
@@ -298,6 +298,7 @@
 		}
 
 		if (rq_data_dir(req) != READ) {
+			/* Wait for the card to to be in transfer state*/
 			do {
 				int err;
 
@@ -310,8 +311,8 @@
 					       req->rq_disk->disk_name, err);
 					goto cmd_err;
 				}
-			} while (!(cmd.resp[0] & R1_READY_FOR_DATA));
-
+			} while (!(R1_CURRENT_STATE(cmd.resp[0]) == 4)); 
+			
 #if 0
 			if (cmd.resp[0] & ~0x00000900)
 				printk(KERN_ERR "%s: status = %08x\n",


 I noticed that at times the card is not actually in transfer 
 state when it recieves the second consecutive 
 MULTIPLE_BLOCK_WRITE cmd.  As per the simplified specification 
 available, all class 4 commands including CMD25 can be issued 
 only in tra state, though its also specified that READY_FOR_DATA 
 indicates whether the card can accept new data.

 I am just wondering if I have set of broken cards.  Any pointers 
 in this regard?

 Thanks and Regards,
 Roopesh.
