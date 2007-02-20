Return-Path: <linux-kernel-owner+w=401wt.eu-S965856AbXBTBGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856AbXBTBGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXBTBGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:06:15 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56367 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbXBTBFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:05:48 -0500
Date: Mon, 19 Feb 2007 19:03:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 4/5] sata_nv: Use notifier for completion checks
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45DA48CC.3090704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware provides us a notifier register that indicates what command
tags have completed. Use this to determine which CPBs to check, rather
than blindly checking all active CPBs. This should provide a minor
performance win, since if the controller has touched some of these
incomplete CPBs, accessing them will likely result in a cache miss.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-15 22:36:02.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c.delayandfixes	2007-02-19 17:00:14.000000000 -0600
@@ -853,22 +854,14 @@ static irqreturn_t nv_adma_interrupt(int
 
 			if (status & (NV_ADMA_STAT_DONE |
 				      NV_ADMA_STAT_CPBERR)) {
+				u32 check_commands = notifier | notifier_error;
+				int pos, error = 0;
 				/** Check CPBs for completed commands */
-
-				if (ata_tag_valid(ap->active_tag)) {
-					/* Non-NCQ command */
-					nv_adma_check_cpb(ap, ap->active_tag,
-						notifier_error & (1 << ap->active_tag));
-				} else {
-					int pos, error = 0;
-					u32 active = ap->sactive;
-
-					while ((pos = ffs(active)) && !error) {
-						pos--;
-						error = nv_adma_check_cpb(ap, pos,
-							notifier_error & (1 << pos) );
-						active &= ~(1 << pos );
-					}
+				while ((pos = ffs(check_commands)) && !error) {
+					pos--;
+					error = nv_adma_check_cpb(ap, pos,
+						notifier_error & (1 << pos) );
+					check_commands &= ~(1 << pos );
 				}
 			}
 		}

