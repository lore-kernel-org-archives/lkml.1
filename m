Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZAXSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZAXSsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbZAXSsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:48:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57678 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZAXSsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:48:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:46:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
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
 drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -92,6 +92,10 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
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
@@ -104,6 +108,7 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
 #define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
 #define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_POWER_CONDITION	0x20
+#define SBP2_WORKAROUND_NO_PAGE_TABLES	0x40
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 static int sbp2_param_workarounds;
@@ -116,6 +121,7 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", set power condition in start stop unit = "
 				  __stringify(SBP2_WORKAROUND_POWER_CONDITION)
+	", no page tables = "     __stringify(SBP2_WORKAROUND_NO_PAGE_TABLES)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -325,7 +331,7 @@ struct sbp2_command_orb {
 static const struct {
 	u32 firmware_revision;
 	u32 model;
-	unsigned int workarounds;
+	unsigned workarounds;
 } sbp2_workarounds_table[] = {
 	/* DViCO Momobay CX-1 with TSB42AA9 bridge */ {
 		.firmware_revision	= 0x002800,
@@ -360,15 +366,17 @@ static const struct {
 		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
-
 	/*
-	 * There are iPods (2nd gen, 3rd gen) with model_id == 0, but
-	 * these iPods do not feature the read_capacity bug according
-	 * to one report.  Read_capacity behaviour as well as model_id
-	 * could change due to Apple-supplied firmware updates though.
+	 * iPod 2nd generation: needs no-page-tables workaround
+	 * iPod 3rd generation: needs fix-capacity workaround
 	 */
-
-	/* iPod 4th generation. */ {
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_NO_PAGE_TABLES |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
@@ -1540,6 +1548,9 @@ static int sbp2_scsi_slave_configure(str
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_NO_PAGE_TABLES)
+		blk_queue_max_hw_segments(sdev->request_queue, 1);
+
 	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
 
 	return 0;

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

