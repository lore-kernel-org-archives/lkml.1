Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZJBQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZJBQwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZJBQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:52:08 -0400
Received: from kroah.org ([198.145.64.141]:38634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZJBQwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:52:05 -0400
Date: Fri, 2 Oct 2009 09:42:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Robert de Rooy <robert.de.rooy@gmail.com>
Subject: [31/30] thinkpad-acpi: fix incorrect use of
 TPACPI_BRGHT_MODE_ECNVRAM
Message-ID: <20091002164213.GA3711@kroah.com>
References: <20091001233504.GA17709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001233504.GA17709@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

HBRV-based default selection of backlight control strategy didn't work
well, at least the X41 defines it but doesn't use it and I don't think
it will stop there.  Switch to a blacklist, and make sure only Radeon-
based models get ECNVRAM.

Symptoms of incorrect backlight mode selection are:

1. Non-working backlight control through sysfs;

2. Backlight gets reset to the lowest level at every shutdown, reboot
   and when thinkpad-acpi gets unloaded;

This fixes a regression in 2.6.30, bugzilla #13826.  This fix is
already present on 2.6.31.

This is a minimal patch for 2.6.30-stable, based on mainline
commits: 050df107c408a3df048524b3783a5fc6d4dccfdb,
	 7d95a3d564901e88ed42810f054e579874151999,
	 59fe4fe34d7afdf63208124f313be9056feaa2f4,
	 6da25bf51689a5cc60370d30275dbb9e6852e0cb

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Reported-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Reported-by: Robert de Rooy <robert.de.rooy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   74 ++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 13 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -286,6 +286,8 @@ struct thinkpad_id_data {
 
 	u16 bios_model;		/* Big Endian, TP-1Y = 0x5931, 0 = unknown */
 	u16 ec_model;
+	u16 bios_release;	/* 1ZETK1WW = 0x314b, 0 = unknown */
+	u16 ec_release;
 
 	char *model_str;	/* ThinkPad T43 */
 	char *nummodel_str;	/* 9384A9C for a 9384-A9C model */
@@ -362,6 +364,45 @@ static void tpacpi_log_usertask(const ch
 		} \
 	} while (0)
 
+#define TPACPI_MATCH_ANY		0xffffU
+#define TPACPI_MATCH_UNKNOWN		0U
+
+/* TPID('1', 'Y') == 0x5931 */
+#define TPID(__c1, __c2) (((__c2) << 8) | (__c1))
+
+#define TPACPI_Q_IBM(__id1, __id2, __quirk)	\
+	{ .vendor = PCI_VENDOR_ID_IBM,		\
+	  .bios = TPID(__id1, __id2),		\
+	  .ec = TPACPI_MATCH_ANY,		\
+	  .quirks = (__quirk) }
+
+struct tpacpi_quirk {
+	unsigned int vendor;
+	u16 bios;
+	u16 ec;
+	unsigned long quirks;
+};
+
+static unsigned long __init tpacpi_check_quirks(
+			const struct tpacpi_quirk *qlist,
+			unsigned int qlist_size)
+{
+	while (qlist_size) {
+		if ((qlist->vendor == thinkpad_id.vendor ||
+				qlist->vendor == TPACPI_MATCH_ANY) &&
+		    (qlist->bios == thinkpad_id.bios_model ||
+				qlist->bios == TPACPI_MATCH_ANY) &&
+		    (qlist->ec == thinkpad_id.ec_model ||
+				qlist->ec == TPACPI_MATCH_ANY))
+			return qlist->quirks;
+
+		qlist_size--;
+		qlist++;
+	}
+	return 0;
+}
+
+
 /****************************************************************************
  ****************************************************************************
  *
@@ -5757,14 +5798,27 @@ static struct backlight_ops ibm_backligh
 
 /* --------------------------------------------------------------------- */
 
+#define TPACPI_BRGHT_Q_EC	0x0002  /* Should or must use EC HBRV */
+
+static const struct tpacpi_quirk brightness_quirk_table[] __initconst = {
+	TPACPI_Q_IBM('1', 'Y', TPACPI_BRGHT_Q_EC),
+	TPACPI_Q_IBM('1', 'Q', TPACPI_BRGHT_Q_EC),
+	TPACPI_Q_IBM('7', '6', TPACPI_BRGHT_Q_EC),
+	TPACPI_Q_IBM('7', '8', TPACPI_BRGHT_Q_EC),
+};
+
 static int __init brightness_init(struct ibm_init_struct *iibm)
 {
 	int b;
+	unsigned long quirks;
 
 	vdbg_printk(TPACPI_DBG_INIT, "initializing brightness subdriver\n");
 
 	mutex_init(&brightness_mutex);
 
+	quirks = tpacpi_check_quirks(brightness_quirk_table,
+				ARRAY_SIZE(brightness_quirk_table));
+
 	/*
 	 * We always attempt to detect acpi support, so as to switch
 	 * Lenovo Vista BIOS to ACPI brightness mode even if we are not
@@ -5821,19 +5875,9 @@ static int __init brightness_init(struct
 	/* TPACPI_BRGHT_MODE_AUTO not implemented yet, just use default */
 	if (brightness_mode == TPACPI_BRGHT_MODE_AUTO ||
 	    brightness_mode == TPACPI_BRGHT_MODE_MAX) {
-		if (thinkpad_id.vendor == PCI_VENDOR_ID_IBM) {
-			/*
-			 * IBM models that define HBRV probably have
-			 * EC-based backlight level control
-			 */
-			if (acpi_evalf(ec_handle, NULL, "HBRV", "qd"))
-				/* T40-T43, R50-R52, R50e, R51e, X31-X41 */
-				brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
-			else
-				/* all other IBM ThinkPads */
-				brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
-		} else
-			/* All Lenovo ThinkPads */
+		if (quirks & TPACPI_BRGHT_Q_EC)
+			brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
+		else
 			brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
 
 		dbg_printk(TPACPI_DBG_BRGHT,
@@ -7387,6 +7431,8 @@ static int __must_check __init get_think
 		return 0;
 	tp->bios_model = tp->bios_version_str[0]
 			 | (tp->bios_version_str[1] << 8);
+	tp->bios_release = (tp->bios_version_str[4] << 8)
+			 | tp->bios_version_str[5];
 
 	/*
 	 * ThinkPad T23 or newer, A31 or newer, R50e or newer,
@@ -7407,6 +7453,8 @@ static int __must_check __init get_think
 				return -ENOMEM;
 			tp->ec_model = ec_fw_string[0]
 					| (ec_fw_string[1] << 8);
+			tp->ec_release = (ec_fw_string[4] << 8)
+					| ec_fw_string[5];
 			break;
 		}
 	}
