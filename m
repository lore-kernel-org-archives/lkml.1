Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXH2El6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXH2El6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXH2Elv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:41:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39580 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751336AbXH2Elu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:41:50 -0400
Message-ID: <46D4F905.6080908@suse.de>
Date: Wed, 29 Aug 2007 08:41:41 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.23-rc4: BAD regression
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
In-Reply-To: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
Content-Type: multipart/mixed;
 boundary="------------060502070903050009010303"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060502070903050009010303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Daniel,
Does this patch help you, or do we need to revert the whole thing?

Sorry for the trouble,
Alex.
Daniel Ritz wrote:
> tried that one on my old toshiba tecra 8000 laptop, almost killing it.
> the fan doesn't work any more...type 'make' and see the box dying.
> luckily my CPU doesn't commit suicide...bisected it to that one:
>
> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
> commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Aug 3 17:52:48 2007 -0400
>
>     ACPI: EC: If ECDT is not found, look up EC in DSDT.
>
>     Some ASUS laptops access EC space from device _INI methods, but do not
>     provide ECDT for early EC setup. In order to make them function properly,
>     there is a need to find EC is DSDT before any _INI is called.
>
>     Similar functionality was turned on by acpi_fake_ecdt=1 command line
>     before. Now it is on all the time.
>
>     http://bugzilla.kernel.org/show_bug.cgi?id=8598
>
>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>     Signed-off-by: Len Brown <len.brown@intel.com>
>   


--------------060502070903050009010303
Content-Type: text/x-patch;
 name="drop_ec_early_init_from_DSDT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drop_ec_early_init_from_DSDT.patch"

Drop early init of EC from DSDT patch

From: Alexey Starikovskiy <astarikovskiy@suse.de>


---

 drivers/acpi/ec.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 43749c8..e28f5b2 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -876,20 +876,13 @@ int __init acpi_ec_ecdt_probe(void)
 	 */
 	status = acpi_get_table(ACPI_SIG_ECDT, 1,
 				(struct acpi_table_header **)&ecdt_ptr);
-	if (ACPI_SUCCESS(status)) {
-		printk(KERN_INFO PREFIX "EC description table is found, configuring boot EC\n\n");
-		boot_ec->command_addr = ecdt_ptr->control.address;
-		boot_ec->data_addr = ecdt_ptr->data.address;
-		boot_ec->gpe = ecdt_ptr->gpe;
-		boot_ec->handle = ACPI_ROOT_OBJECT;
-	} else {
-		printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
-		status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
-						boot_ec, NULL);
-		if (ACPI_FAILURE(status))
-			goto error;
-	}
-
+	if (ACPI_FAILURE(status))
+		goto error;
+	printk(KERN_INFO PREFIX "EC description table is found, configuring boot EC\n");
+	boot_ec->command_addr = ecdt_ptr->control.address;
+	boot_ec->data_addr = ecdt_ptr->data.address;
+	boot_ec->gpe = ecdt_ptr->gpe;
+	boot_ec->handle = ACPI_ROOT_OBJECT;
 	ret = ec_install_handlers(boot_ec);
 	if (!ret) {
 		first_ec = boot_ec;

--------------060502070903050009010303--
