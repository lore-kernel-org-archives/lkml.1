Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYDJABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYDJABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbYDJABQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:01:16 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:15400 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755809AbYDJABO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:01:14 -0400
Date: Wed, 09 Apr 2008 18:01:10 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] EDAC Fix module initialization on several modules 2nd time
Message-ID: <47fd58c6.gfMITPTNZaL8HDMA%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <h.mitake@gmail.com>

diff against 2.6.25-rc8-mm1

I implmented opstate_init() as a inline function in linux/edac.h .

added calling opstate_init() to:
	i82443bxgx_edac.c
	i82860_edac.c
	i82875p_edac.c 
	i82975x_edac.c 

I wrote a fixed patch of
edac-fix-module-initialization-on-several-modules.patch,
and tested building 2.6.25-rc7 with applying this. It was succeed.
I think the patch is now correct.

Hitoshi

Resubmit of this patch, after Hitoshi, corrected .h include issue
which caused compilation errors with 'make allmodconfig'

This is a good refactor to reduce the initialization code to a single
point of implementaton, and then just call that code from each of the
modules to setup proper state

doug t

Cc:             Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by:	Hitoshi Mitake <h.mitake@gmail.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/amd76x_edac.c     |    7 +++++++
 drivers/edac/e752x_edac.c      |   15 +++++----------
 drivers/edac/e7xxx_edac.c      |   13 +++----------
 drivers/edac/i3000_edac.c      |   13 ++++---------
 drivers/edac/i5000_edac.c      |   14 ++++----------
 drivers/edac/i82443bxgx_edac.c |    7 +++++++
 drivers/edac/i82860_edac.c     |    7 +++++++
 drivers/edac/i82875p_edac.c    |    9 +++++++++
 drivers/edac/i82975x_edac.c    |    8 +++++++-
 drivers/edac/pasemi_edac.c     |    6 ++++++
 drivers/edac/r82600_edac.c     |    7 +++++++
 include/linux/edac.h           |   14 +++++++++++++-
 12 files changed, 79 insertions(+), 41 deletions(-)

Index: linux-2.6.25-rc8-mm1/drivers/edac/amd76x_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/amd76x_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/amd76x_edac.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define AMD76X_REVISION	" Ver: 2.0.2 "  __DATE__
@@ -344,6 +345,9 @@ static struct pci_driver amd76x_driver =
 
 static int __init amd76x_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&amd76x_driver);
 }
 
@@ -358,3 +362,6 @@ module_exit(amd76x_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh");
 MODULE_DESCRIPTION("MC support for AMD 76x memory controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/e752x_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/e752x_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/e752x_edac.c
@@ -1117,16 +1117,6 @@ static int e752x_probe1(struct pci_dev *
 	debugf0("%s(): mci\n", __func__);
 	debugf0("Starting Probe1\n");
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
 	 * assume the BIOS has reserved it for a reason and is expecting
 	 * exclusive access, we take care not to violate that assumption and
@@ -1303,6 +1293,10 @@ static int __init e752x_init(void)
 	int pci_rc;
 
 	debugf3("%s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&e752x_driver);
 	return (pci_rc < 0) ? pci_rc : 0;
 }
@@ -1323,6 +1317,7 @@ MODULE_DESCRIPTION("MC support for Intel
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as hidden:"
 		 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
+
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
Index: linux-2.6.25-rc8-mm1/drivers/edac/e7xxx_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/e7xxx_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/e7xxx_edac.c
@@ -414,16 +414,6 @@ static int e7xxx_probe1(struct pci_dev *
 
 	debugf0("%s(): mci\n", __func__);
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
@@ -565,6 +555,9 @@ static struct pci_driver e7xxx_driver = 
 
 static int __init e7xxx_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&e7xxx_driver);
 }
 
Index: linux-2.6.25-rc8-mm1/drivers/edac/i3000_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i3000_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i3000_edac.c
@@ -326,15 +326,6 @@ static int i3000_probe1(struct pci_dev *
 		return -ENODEV;
 	}
 
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
 	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
 	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
@@ -503,6 +494,10 @@ static int __init i3000_init(void)
 	int pci_rc;
 
 	debugf3("MC: %s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i3000_driver);
 	if (pci_rc < 0)
 		goto fail0;
Index: linux-2.6.25-rc8-mm1/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i5000_edac.c
@@ -1286,16 +1286,6 @@ static int i5000_probe1(struct pci_dev *
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	/* Ask the devices for the number of CSROWS and CHANNELS so
 	 * that we can calculate the memory resources, etc
 	 *
@@ -1478,6 +1468,9 @@ static int __init i5000_init(void)
 
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i5000_driver);
 
 	return (pci_rc < 0) ? pci_rc : 0;
@@ -1501,5 +1494,6 @@ MODULE_AUTHOR
     ("Linux Networx (http://lnxi.com) Doug Thompson <norsk5@xmission.com>");
 MODULE_DESCRIPTION("MC Driver for Intel I5000 memory controllers - "
 		I5000_REVISION);
+
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/i82443bxgx_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i82443bxgx_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i82443bxgx_edac.c
@@ -29,6 +29,7 @@
 
 #include <linux/slab.h>
 
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82443_REVISION	"0.1"
@@ -386,6 +387,9 @@ static struct pci_driver i82443bxgx_edac
 
 static int __init i82443bxgx_edacmc_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&i82443bxgx_edacmc_driver);
 }
 
@@ -400,3 +404,6 @@ module_exit(i82443bxgx_edacmc_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD");
 MODULE_DESCRIPTION("EDAC MC support for Intel 82443BX/GX memory controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/i82860_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i82860_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i82860_edac.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define  I82860_REVISION " Ver: 2.0.2 " __DATE__
@@ -294,6 +295,9 @@ static int __init i82860_init(void)
 
 	debugf3("%s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	if ((pci_rc = pci_register_driver(&i82860_driver)) < 0)
 		goto fail0;
 
@@ -345,3 +349,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com) "
 		"Ben Woodard <woodard@redhat.com>");
 MODULE_DESCRIPTION("ECC support for Intel 82860 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/i82875p_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i82875p_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i82875p_edac.c
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82875P_REVISION	" Ver: 2.0.2 " __DATE__
@@ -393,6 +394,7 @@ static int i82875p_probe1(struct pci_dev
 	struct i82875p_error_info discard;
 
 	debugf0("%s()\n", __func__);
+
 	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
 
 	if (i82875p_setup_overfl_dev(pdev, &ovrfl_pdev, &ovrfl_window))
@@ -532,6 +534,10 @@ static int __init i82875p_init(void)
 	int pci_rc;
 
 	debugf3("%s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i82875p_driver);
 
 	if (pci_rc < 0)
@@ -586,3 +592,6 @@ module_exit(i82875p_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh");
 MODULE_DESCRIPTION("MC support for Intel 82875 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/i82975x_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/i82975x_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/i82975x_edac.c
@@ -14,7 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82975X_REVISION	" Ver: 1.0.0 " __DATE__
@@ -611,6 +611,9 @@ static int __init i82975x_init(void)
 
 	debugf3("%s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i82975x_driver);
 	if (pci_rc < 0)
 		goto fail0;
@@ -664,3 +667,6 @@ module_exit(i82975x_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arvind R. <arvind@acarlab.com>");
 MODULE_DESCRIPTION("MC support for Intel 82975 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/drivers/edac/pasemi_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/pasemi_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/pasemi_edac.c
@@ -284,6 +284,9 @@ static struct pci_driver pasemi_edac_dri
 
 static int __init pasemi_edac_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&pasemi_edac_driver);
 }
 
@@ -298,3 +301,6 @@ module_exit(pasemi_edac_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Egor Martovetsky <egor@pasemi.com>");
 MODULE_DESCRIPTION("MC support for PA Semi PWRficient memory controller");
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
+
Index: linux-2.6.25-rc8-mm1/drivers/edac/r82600_edac.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/drivers/edac/r82600_edac.c
+++ linux-2.6.25-rc8-mm1/drivers/edac/r82600_edac.c
@@ -20,6 +20,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define R82600_REVISION	" Ver: 2.0.2 " __DATE__
@@ -393,6 +394,9 @@ static struct pci_driver r82600_driver =
 
 static int __init r82600_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&r82600_driver);
 }
 
@@ -412,3 +416,6 @@ MODULE_DESCRIPTION("MC support for Radis
 module_param(disable_hardware_scrub, bool, 0644);
 MODULE_PARM_DESC(disable_hardware_scrub,
 		 "If set, disable the chipset's automatic scrub for CEs");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
Index: linux-2.6.25-rc8-mm1/include/linux/edac.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/include/linux/edac.h
+++ linux-2.6.25-rc8-mm1/include/linux/edac.h
@@ -3,7 +3,7 @@
  *
  * Author: Dave Jiang <djiang@mvista.com>
  *
- * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
+ * 2006-2008 (c) MontaVista Software, Inc. This file is licensed under
  * the terms of the GNU General Public License version 2. This program
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
@@ -26,4 +26,16 @@ extern atomic_t edac_handlers;
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
 
+static inline void opstate_init(void)
+{
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+	}
+	return;
+}
+
 #endif
