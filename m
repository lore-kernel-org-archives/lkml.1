Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZEEDrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZEEDrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZEEDq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:46:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:42091 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbZEEDq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:46:26 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: akpm@linux-foundation.org, bluesmoke-devel@lists.sourceforge.net
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] EDAC: CPC925 MC check fixup
Date: Tue,  5 May 2009 11:45:48 +0800
Message-Id: <1241495148-15166-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1241495148-15166-1-git-send-email-qingtao.cao@windriver.com>
References: <1241495148-15166-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 05 May 2009 03:45:07.0192 (UTC) FILETIME=[E1CA2F80:01C9CD33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an obvious bug in CPC925 Memory Controller's check routine - 
edac_mc_handle_ue() should have been called for UECC errors and 
edac_mc_handle_ce() for CECC errors.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/cpc925_edac.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 2ad6465..8c54196 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -544,17 +544,16 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	/* Revert column/row addresses into page frame number, etc */
 	cpc925_mc_get_pfn(mci, mear, &pfn, &offset, &csrow);
 
-	if (apiexcp & UECC_EXCP_DETECTED) {
-		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
+	if (apiexcp & CECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
 		edac_mc_handle_ce(mci, pfn, offset, syndrome,
 				  csrow, channel, mci->ctl_name);
 	}
 
-	if (apiexcp & CECC_EXCP_DETECTED) {
-		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
-		edac_mc_handle_ue(mci, pfn, offset,
-				  csrow, mci->ctl_name);
+	if (apiexcp & UECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
+		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
-- 
1.5.6.2

