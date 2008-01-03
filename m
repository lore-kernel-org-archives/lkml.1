Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYACV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYACV6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYACV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:58:31 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11148 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209AbYACV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:58:30 -0500
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 16:58:30 EST
Date: Thu, 03 Jan 2008 14:30:40 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/4] drivers-edac-i3000-missing-init-code
Message-ID: <477d5400.O/eAFb+hV2LJimEv%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Hitoshi Mitake <h.mitake@gmail.com> 

This is patch for i3000_edac.c . If you think this is useful, please use it!

There is a missing sequence of initialization code during startup.

Signed-off-by:	Hitoshi Mitake <h.mitake@gmail.com> 
Signed-off-by:	Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by:	Doug Thompson <dougthompson@xmisson.com>
---

Index: linux-2.6.24-rc5-mm1/drivers/edac/i3000_edac.c
===================================================================
--- linux-2.6.24-rc5-mm1.orig/drivers/edac/i3000_edac.c
+++ linux-2.6.24-rc5-mm1/drivers/edac/i3000_edac.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I3000_REVISION		"1.1"
@@ -318,6 +319,15 @@ static int i3000_probe1(struct pci_dev *
 		return -ENODEV;
 	}
 
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
+	}
+
 	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
 	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
 	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
@@ -537,3 +547,6 @@ module_exit(i3000_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Akamai Technologies Arthur Ulfeldt/Jason Uhlenkott");
 MODULE_DESCRIPTION("MC support for Intel 3000 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
