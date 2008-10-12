Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYJLXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYJLXp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYJLXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:45:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53703 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbYJLXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:45:17 -0400
Date: Sun, 12 Oct 2008 19:45:11 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: async function call test users
Message-ID: <20081012194511.64cdd9e4@infradead.org>
In-Reply-To: <20081012194427.2e21c22e@infradead.org>
References: <20081012194427.2e21c22e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not for merge! Just for "show that it works"
diff --git a/Makefile b/Makefile
index 16e3fbb..2402f6b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION =
+EXTRAVERSION = -async
 NAME = Rotary Wombat
 
 # *DOCUMENTATION*
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b1c723f..f93c3c9 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -896,6 +896,12 @@ static int __init acpi_battery_init(void)
 	return 0;
 }
 
+static int acpi_battery_init_prime(void)
+{
+	call_async(ASYNC_POOL_MISC, 0, acpi_battery_init);
+	return 0;
+}
+
 static void __exit acpi_battery_exit(void)
 {
 	acpi_bus_unregister_driver(&acpi_battery_driver);
@@ -904,5 +910,5 @@ static void __exit acpi_battery_exit(void)
 #endif
 }
 
-module_init(acpi_battery_init);
+module_init(acpi_battery_init_prime);
 module_exit(acpi_battery_exit);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1ee9499..0205eca 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5937,10 +5937,7 @@ int ata_host_activate(struct ata_host *host, int irq,
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_desc(host->ports[i], "irq %d", irq);
 
-	rc = ata_host_register(host, sht);
-	/* if failed, just free the IRQ and leave ports alone */
-	if (rc)
-		devm_free_irq(host->dev, irq, host);
+	call_async(ASYNC_POOL_SCSI, 2, ata_host_register, host, sht);
 
 	return rc;
 }



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
