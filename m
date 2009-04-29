Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbZD2Wog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbZD2Wog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbZD2WWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:22:08 -0400
Received: from kroah.org ([198.145.64.141]:40825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760497AbZD2WV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:31 2009
Message-Id: <20090429220931.285231983@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [patch 56/58] ACPI: EC: Add some basic check for ECDT data
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=acpi-ec-add-some-basic-check-for-ecdt-data.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit c5279dee26c0e8d7c4200993bfc4b540d2469598 upstream.

One more ASUS comes with empty ECDT, add a guard for it...

http://bugzilla.kernel.org/show_bug.cgi?id=11880

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -968,7 +968,6 @@ static const struct acpi_device_id ec_de
 
 int __init acpi_ec_ecdt_probe(void)
 {
-	int ret;
 	acpi_status status;
 	struct acpi_table_ecdt *ecdt_ptr;
 
@@ -996,30 +995,32 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->gpe = ecdt_ptr->gpe;
 		boot_ec->handle = ACPI_ROOT_OBJECT;
 		acpi_get_handle(ACPI_ROOT_OBJECT, ecdt_ptr->id, &boot_ec->handle);
-	} else {
-		/* This workaround is needed only on some broken machines,
-		 * which require early EC, but fail to provide ECDT */
-		acpi_handle x;
-		printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
-		status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
-						boot_ec, NULL);
-		/* Check that acpi_get_devices actually find something */
-		if (ACPI_FAILURE(status) || !boot_ec->handle)
-			goto error;
-		/* We really need to limit this workaround, the only ASUS,
-		 * which needs it, has fake EC._INI method, so use it as flag.
-		 * Keep boot_ec struct as it will be needed soon.
-		 */
-		if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &x)))
-			return -ENODEV;
+		/* Add some basic check against completely broken table */
+		if (boot_ec->data_addr != boot_ec->command_addr)
+			goto install;
+	/* fall through */
 	}
-
-	ret = ec_install_handlers(boot_ec);
-	if (!ret) {
+	/* This workaround is needed only on some broken machines,
+	 * which require early EC, but fail to provide ECDT */
+	acpi_handle x;
+	printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
+	status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
+					boot_ec, NULL);
+	/* Check that acpi_get_devices actually find something */
+	if (ACPI_FAILURE(status) || !boot_ec->handle)
+		goto error;
+	/* We really need to limit this workaround, the only ASUS,
+	 * which needs it, has fake EC._INI method, so use it as flag.
+	 * Keep boot_ec struct as it will be needed soon.
+	 */
+	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &x)))
+		return -ENODEV;
+install:
+	if (!ec_install_handlers(boot_ec)) {
 		first_ec = boot_ec;
 		return 0;
 	}
-      error:
+error:
 	kfree(boot_ec);
 	boot_ec = NULL;
 	return -ENODEV;


