Return-Path: <linux-kernel-owner+w=401wt.eu-S1763204AbYF0S0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763204AbYF0S0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbYF0SZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:50 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11696 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756563AbYF0SZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:49 -0400
Date: Fri, 27 Jun 2008 12:13:38 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 10/13] EDAC core fix added newline to sysfs dimm labels
Message-ID: <48652dd2.ta+2XWbG/aD+2pRz%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

The channel DIMM label does not seem to be
used much in the edac code.  However, where
it is used (in the core code), it is assumed
to not have a newline embedded.  This leaves
the sysfs file newline free which looks funny
when cat'ing it.  Here we just add the trailing
newline to the sysfs chX_dimm_label output...

[Doug Thompson note: the DIMM label is one of the primary uses of EDAC. User
space daemon scripts, edac-utils@sourceforge, populate the DIMM label fields,
via /sys/devices/system/edac attributes, with the silk screen labels of
the motherboard in use. dmidecode access BIOS tables, but BIOS tables
are well known to be incorrect and useless in these respects. edac-utils
will strip off any newlines before its use of the output, when displaying
DIMM slot silk screen labels.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/edac_mc_sysfs.c |    6 ++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
@@ -178,7 +178,11 @@ static ssize_t csrow_edac_mode_show(stru
 static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
 				char *data, int channel)
 {
-	return snprintf(data, EDAC_MC_LABEL_LEN, "%s",
+	/* if field has not been initialized, there is nothing to send */
+	if (!csrow->channels[channel].label[0])
+		return 0;
+
+	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n",
 			csrow->channels[channel].label);
 }
 
