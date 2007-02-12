Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXBLApI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXBLApI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932883AbXBLApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:45:07 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:4312 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbXBLApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:45:05 -0500
Date: Sun, 11 Feb 2007 18:36:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: handle SError status indication
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45CFB6A8.3010507@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ADMA-capable controllers provide a bit in the status register that appears
to indicate that the controller detected an SError condition. Update sata_nv
to detect this and trigger error handling in order to handle the fault.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- drivers/ata/sata_nv.c.before_serror	2007-02-11 17:49:27.000000000 -0600
+++ drivers/ata/sata_nv.c	2007-02-11 17:54:39.000000000 -0600
@@ -827,7 +827,8 @@ static irqreturn_t nv_adma_interrupt(int
 			/* freeze if hotplugged or controller error */
 			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
 					       NV_ADMA_STAT_HOTUNPLUG |
-					       NV_ADMA_STAT_TIMEOUT))) {
+					       NV_ADMA_STAT_TIMEOUT |
+					       NV_ADMA_STAT_SERROR))) {
 				struct ata_eh_info *ehi = &ap->eh_info;
 
 				ata_ehi_clear_desc(ehi);
@@ -841,6 +842,9 @@ static irqreturn_t nv_adma_interrupt(int
 				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
 					ata_ehi_hotplugged(ehi);
 					ata_ehi_push_desc(ehi, ": hot unplug");
+				} else if (status & NV_ADMA_STAT_SERROR) {
+					/* let libata analyze SError and figure out the cause */
+					ata_ehi_push_desc(ehi, ": SError");
 				}
 				ata_port_freeze(ap);
 				continue;

