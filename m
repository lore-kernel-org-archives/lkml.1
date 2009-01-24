Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZAXSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZAXSqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZAXSqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:46:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZAXSqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:46:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:45:53 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFT 6/7] ieee1394: sbp2: add workarounds for 2nd and 3rd
 generation iPods
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.9cf7aabbf7a0af4a@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to https://bugs.launchpad.net/bugs/294391
  - 3rd generation iPods need the "fix capacity" workaround after all
    (apparently they crash after the last sector was accessed),
  - 2nd generation iPods need the "128 kB maximum request size"
    workaround.

Furthermore, Kristian Høgsberg mentioned that 2nd generation iPods
treat page tables (scatter-gather lists) as data buffers, i.e. ignore
the page_table_present bit of command block ORBs.  If this is true, then
the 128 kB limit is not a sufficient workaround; instead we have to
guarantee that all requests have only a single s/g element.  This could
be up to 64 kByte - 4 Bytes in size.  But I expect the block layer to
typically emit much smaller elements than that, alas.

Alas both iPod generations feature the same model ID in the config ROM,
hence we can only define a shared quirks list entry for them.  This is
bad since
  - the "fix capacity" workaround prevents access to the very last
    sector if a device does not actually have this bug,
  - the "no page tables" workaround dramatically reduces throughput,
    e.g. from 25 to 9 MB/s without gap count optimization, and from 36
    11 MB/s with gap count optimization (as per hdparm with a regular
    3.5" S400 disk on an i686 PC without IOMMU).  Whether this matters
    with the already slow iPod disk is not yet known.

This patch needs testing by somebody who has the hardware:
  - Do 2nd and 3rd gen. iPods actually have a model_id == 0, or do they
    have in fact no model_id at all?
  - Does the "fix capacity" workaround harm usage of 2nd gen. iPods?
  - Is the "no page tables" workaround really necessary for 2nd gen.
    iPods, or is the 128k limit sufficient as reported for the Ubuntu
    8.10 kernel?
  - How badly does the "no page tables" workaround affect throughput of
    3rd gen. iPods which don't need it?

A side note:  Apple computers in target mode (or at least an x86 Mac
mini) don't have firmware_version and model_id, hence none of the iPod
quirks list entries is active for them.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   17 +++++++++++++++++
 drivers/ieee1394/sbp2.h |    1 +
 2 files changed, 18 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -191,6 +191,10 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
  *   sd_mod on suspend, resume, and shutdown (if manage_start_stop is on).
  *   Some disks need this to spin down or to resume properly.
  *
+ * - no page tables
+ *   Limit data buffers to a single scatter/ gather element for buggy devices
+ *   which ignore the page_table_present bit in command block ORBs.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -206,6 +210,7 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", set power condition in start stop unit = "
 				  __stringify(SBP2_WORKAROUND_POWER_CONDITION)
+	", no page tables = "     __stringify(SBP2_WORKAROUND_NO_PAGE_TABLES)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -395,6 +400,16 @@ static const struct {
 		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/*
+	 * iPod 2nd generation: needs no-page-tables workaround
+	 * iPod 3rd generation: needs fix-capacity workaround
+	 */
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_NO_PAGE_TABLES |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,
@@ -2011,6 +2026,8 @@ static int sbp2scsi_slave_configure(stru
 		sdev->start_stop_pwr_cond = 1;
 	if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+	if (lu->workarounds & SBP2_WORKAROUND_NO_PAGE_TABLES)
+		blk_queue_max_hw_segments(sdev->request_queue, 1);
 
 	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
 	return 0;
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -335,6 +335,7 @@ enum sbp2lu_state_types {
 #define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
 #define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_POWER_CONDITION	0x20
+#define SBP2_WORKAROUND_NO_PAGE_TABLES	0x40
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 #endif /* SBP2_H */

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

