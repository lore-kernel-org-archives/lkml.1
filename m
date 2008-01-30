Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYA3Byo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYA3Byo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYA3Byd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:54:33 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8490 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYA3Byc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:54:32 -0500
Date: Tue, 29 Jan 2008 19:53:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: fix for completion handling
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Kuan Luo <kluo@nvidia.com>,
       Allen Martin <AMartin@nvidia.com>
Message-id: <479FD88F.8090605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on an original patch from Kuan Luo of NVIDIA,
posted under subject "fixed a bug of adma in rhel4u5 with HDS7250SASUN500G".
His description follows. I've reworked it a bit to avoid some unnecessary
repeated checks but it should be functionally identical.

"The patch is to solve the error message "ata1: CPB flags CMD err,
flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
I tested this hd in 2.6.24-rc7 which needed to remove the mask in
blacklist to run the ncq and the same error also showed up. 

I traced the  bug and found that the interrupt finished a command (for
example, tag=0) when the driver got that adma status is
NV_ADMA_STAT_DONE  and  cpb->resp_flags is NV_CPB_RESP_DONE.
However, For this hd, the drive maybe didn't clear bit 0 at this moment.
It meaned the hardware  had not completely finished the command.
If at the same time  the driver freed the command(tag 0) and sended
another command (tag 0), the error happened.

The notifier register is 32-bit register containing notifier value.
Value is bit vector containing one bit per tag number (0-31) in
corresponding bit positions (bit 0 is for tag 0, etc). When bit is set
then ADMA indicates that command with corresponding tag number completed
execution.

So i added the check notifier code. Sometimes i saw that the notifier
reg set some bits  , but the adma status set NV_ADMA_STAT_CMD_COMPLETE
,not NV_ADMA_STAT_DONE. So i added the NV_ADMA_STAT_CMD_COMPLETE check
code."

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24-rc7-git3/drivers/ata/sata_nv.c	2008-01-11 17:32:40.000000000 -0600
+++ linux-2.6.24-rc7-git3edit/drivers/ata/sata_nv.c	2008-01-11 17:43:40.000000000 -0600
@@ -1011,14 +1011,20 @@
 			}
 
 			if (status & (NV_ADMA_STAT_DONE |
-				      NV_ADMA_STAT_CPBERR)) {
-				u32 check_commands;
+				      NV_ADMA_STAT_CPBERR |
+				      NV_ADMA_STAT_CMD_COMPLETE)) {
+				u32 check_commands = notifier_clears[i];
 				int pos, error = 0;
 
-				if (ata_tag_valid(ap->link.active_tag))
-					check_commands = 1 << ap->link.active_tag;
-				else
-					check_commands = ap->link.sactive;
+				if (status & NV_ADMA_STAT_CPBERR) {
+					/* Check all active commands */
+					if (ata_tag_valid(ap->link.active_tag))
+						check_commands = 1 <<
+							ap->link.active_tag;
+					else
+						check_commands = ap->
+							link.sactive;
+				}
 
 				/** Check CPBs for completed commands */
 				while ((pos = ffs(check_commands)) && !error) {

