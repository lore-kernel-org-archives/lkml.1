Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073Ab0ANQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab0ANQK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985Ab0ANQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:10:25 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:34317 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754242Ab0ANQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:10:25 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 11:10:25 EST
Date: Thu, 14 Jan 2010 09:01:26 -0700
From: dougthompson@xmission.com
To: tom@vincze.org, mchehab@redhat.com, gregkh@suse.de,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: i5000_edac critical fix panic out of bounds 
Message-ID: <4b4f3fd6.uRcykZhMm6srfB1R%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tamas Vincze <tom@vincze.org>

Fix for BZ#14568

EDAC MC0: INTERNAL ERROR: channel-b out of range (4 >= 4)
Kernel panic - not syncing: EDAC MC0: Uncorrected Error  (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

This happens because FERR_NF_FBD bit 28 is not updated on i5000. Due to that,
both bits 28 and 29 may be equal to one, returning channel = 3. As this
value is invalid, EDAC core generates the panic.

Signed-off-by: Tamas Vincze <tom@vincze.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 i5000_edac.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc4/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/edac/i5000_edac.c	2010-01-14 08:37:33.000000000 -0700
+++ linux-2.6.33-rc4/drivers/edac/i5000_edac.c	2010-01-14 08:41:23.000000000 -0700
@@ -577,7 +577,13 @@ static void i5000_process_nonfatal_error
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
-		channel = branch;
+
+		/*
+		 * According with i5000 datasheet, bit 28 has no significance
+		 * for errors M4Err-M12Err and M17Err-M21Err, on FERR_NF_FBD
+		 */
+		channel = branch & 2;
+
 		bank = NREC_BANK(info->nrecmema);
 		rank = NREC_RANK(info->nrecmema);
 		rdwr = NREC_RDWR(info->nrecmema);
