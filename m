Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXCZXg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXCZXg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXCZXg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:36:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46521 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788AbXCZXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:36:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Mar 2007 01:36:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update/RFC] ieee1394: eth1394: don't autoload by hotplug when
 ohci1394 starts
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.c24f659c0675d7d5@s5r6.in-berlin.de>
Message-ID: <tkrat.ca2f973ffbe0b00c@s5r6.in-berlin.de>
References: <tkrat.c24f659c0675d7d5@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - add a new kernel config option which brings back the old behavior
>     for those who liked it.  We don't re-use the old config option
>     because then nobody would notice that there is a choice now.  This
>     new option is scheduled to be removed soon.
...
> Instead of keeping this until the proposed date of removal (June 2007),
> should I kill CONFIG_IEEE1394_AUTOLOAD_ETH1394 right away?
> 
> 
>  Documentation/feature-removal-schedule.txt |    9 +++
>  drivers/ieee1394/Kconfig                   |   49 ++++++++++++---------
>  drivers/ieee1394/config_roms.c             |   47 +++++++++++++++-----
>  drivers/ieee1394/config_roms.h             |   10 ++++
>  drivers/ieee1394/eth1394.c                 |    9 +++
>  5 files changed, 91 insertions(+), 33 deletions(-)


If I skip the feature-removal-schedule procedure, the resulting code is
a lot nicer. I prefer this updated patch and I consider it a candidate
for before 2.6.22-rc1.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: eth1394: don't autoload by hotplug when ohci1394 starts

Until now, ieee1394 put an IP-over-1394 capability entry into each new
host's config ROM.  As soon as the controller was initialized --- i.e.
right after modprobe ohci1394 --- this entry triggered a hotplug event
which typically caused auto-loading of eth1394.

This irritated or annoyed many users and distributors.  Of course they
could blacklist eth1394, but then ieee1394 wrongly advertized IP-over-
1394 capability to the FireWire bus.

Therefore
  - remove the offending kernel config option
    IEEE1394_CONFIG_ROM_IP1394,
  - let eth1394 add the ROM entry by itself, i.e. only after eth1394 was
    loaded.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=7793 .

Autoloading of eth1394 when an _external_ IP-over-1394 capable device is
discovered is _not_ affected by this patch.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

 drivers/ieee1394/Kconfig       |   29 +++---------
 drivers/ieee1394/config_roms.c |   76 ++++++---------------------------
 drivers/ieee1394/config_roms.h |    7 ++-
 drivers/ieee1394/eth1394.c     |    7 ++-
 drivers/ieee1394/hosts.c       |    3 -
 5 files changed, 36 insertions(+), 86 deletions(-)


Index: linux/drivers/ieee1394/Kconfig
===================================================================
--- linux.orig/drivers/ieee1394/Kconfig
+++ linux/drivers/ieee1394/Kconfig
@@ -36,23 +36,6 @@ config IEEE1394_VERBOSEDEBUG
 	  Say Y if you really want or need the debugging output, everyone
 	  else says N.
 
-config IEEE1394_EXTRA_CONFIG_ROMS
-	bool "Build in extra config rom entries for certain functionality"
-	depends on IEEE1394
-	help
-	  Some IEEE1394 functionality depends on extra config rom entries
-	  being available in the host adapters CSR. These options will
-	  allow you to choose which ones.
-
-config IEEE1394_CONFIG_ROM_IP1394
-	bool "IP-1394 Entry"
-	depends on IEEE1394_EXTRA_CONFIG_ROMS && IEEE1394
-	help
-	  Adds an entry for using IP-over-1394. If you want to use your
-	  IEEE1394 bus as a network for IP systems (including interacting
-	  with MacOSX and WinXP IP-over-1394), enable this option and the
-	  eth1394 option below.
-
 comment "Device Drivers"
 	depends on IEEE1394
 
@@ -122,11 +105,15 @@ config IEEE1394_SBP2_PHYS_DMA
 	  This option is buggy and currently broken on some architectures.
 	  If unsure, say N.
 
+config IEEE1394_ETH1394_ROM_ENTRY
+	depends on IEEE1394
+	bool
+	default n
+
 config IEEE1394_ETH1394
-	tristate "Ethernet over 1394"
+	tristate "IP over 1394"
 	depends on IEEE1394 && EXPERIMENTAL && INET
-	select IEEE1394_CONFIG_ROM_IP1394
-	select IEEE1394_EXTRA_CONFIG_ROMS
+	select IEEE1394_ETH1394_ROM_ENTRY
 	help
 	  This driver implements a functional majority of RFC 2734: IPv4 over
 	  1394.  It will provide IP connectivity with implementations of RFC
@@ -135,6 +122,8 @@ config IEEE1394_ETH1394
 	  This driver is still considered experimental.  It does not yet support
 	  MCAP, therefore multicast support is significantly limited.
 
+	  The module is called eth1394 although it does not emulate Ethernet.
+
 config IEEE1394_DV1394
 	tristate "OHCI-DV I/O support (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
Index: linux/drivers/ieee1394/config_roms.c
===================================================================
--- linux.orig/drivers/ieee1394/config_roms.c
+++ linux/drivers/ieee1394/config_roms.c
@@ -26,12 +26,6 @@ struct hpsb_config_rom_entry {
 	/* Base initialization, called at module load */
 	int (*init)(void);
 
-	/* Add entry to specified host */
-	int (*add)(struct hpsb_host *host);
-
-	/* Remove entry from specified host */
-	void (*remove)(struct hpsb_host *host);
-
 	/* Cleanup called at module exit */
 	void (*cleanup)(void);
 
@@ -78,7 +72,7 @@ int hpsb_default_host_entry(struct hpsb_
 }
 
 
-#ifdef CONFIG_IEEE1394_CONFIG_ROM_IP1394
+#ifdef CONFIG_IEEE1394_ETH1394_ROM_ENTRY
 #include "eth1394.h"
 
 static struct csr1212_keyval *ip1394_ud;
@@ -137,7 +131,7 @@ static void config_rom_ip1394_cleanup(vo
 	}
 }
 
-static int config_rom_ip1394_add(struct hpsb_host *host)
+int hpsb_config_rom_ip1394_add(struct hpsb_host *host)
 {
 	if (!ip1394_ud)
 		return -ENODEV;
@@ -146,30 +140,33 @@ static int config_rom_ip1394_add(struct 
 					       ip1394_ud) != CSR1212_SUCCESS)
 		return -ENOMEM;
 
+	host->config_roms |= HPSB_CONFIG_ROM_ENTRY_IP1394;
+	host->update_config_rom = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hpsb_config_rom_ip1394_add);
 
-static void config_rom_ip1394_remove(struct hpsb_host *host)
+void hpsb_config_rom_ip1394_remove(struct hpsb_host *host)
 {
 	csr1212_detach_keyval_from_directory(host->csr.rom->root_kv, ip1394_ud);
+	host->config_roms &= ~HPSB_CONFIG_ROM_ENTRY_IP1394;
+	host->update_config_rom = 1;
 }
+EXPORT_SYMBOL_GPL(hpsb_config_rom_ip1394_remove);
 
 static struct hpsb_config_rom_entry ip1394_entry = {
 	.name		= "ip1394",
 	.init		= config_rom_ip1394_init,
-	.add		= config_rom_ip1394_add,
-	.remove		= config_rom_ip1394_remove,
 	.cleanup	= config_rom_ip1394_cleanup,
 	.flag		= HPSB_CONFIG_ROM_ENTRY_IP1394,
 };
-#endif /* CONFIG_IEEE1394_CONFIG_ROM_IP1394 */
 
+#endif /* CONFIG_IEEE1394_ETH1394_ROM_ENTRY */
 
 static struct hpsb_config_rom_entry *const config_rom_entries[] = {
-#ifdef CONFIG_IEEE1394_CONFIG_ROM_IP1394
+#ifdef CONFIG_IEEE1394_ETH1394_ROM_ENTRY
 	&ip1394_entry,
 #endif
-	NULL,
 };
 
 /* Initialize all config roms */
@@ -177,18 +174,12 @@ int hpsb_init_config_roms(void)
 {
 	int i, error = 0;
 
-	for (i = 0; config_rom_entries[i]; i++) {
-		if (!config_rom_entries[i]->init)
-			continue;
-
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++)
 		if (config_rom_entries[i]->init()) {
 			HPSB_ERR("Failed to initialize config rom entry `%s'",
 				 config_rom_entries[i]->name);
 			error = -1;
-		} else
-			HPSB_DEBUG("Initialized config rom entry `%s'",
-				   config_rom_entries[i]->name);
-	}
+		}
 
 	return error;
 }
@@ -198,43 +189,6 @@ void hpsb_cleanup_config_roms(void)
 {
 	int i;
 
-	for (i = 0; config_rom_entries[i]; i++) {
-		if (config_rom_entries[i]->cleanup)
-			config_rom_entries[i]->cleanup();
-	}
-}
-
-/* Add extra config roms to specified host */
-int hpsb_add_extra_config_roms(struct hpsb_host *host)
-{
-	int i, error = 0;
-
-	for (i = 0; config_rom_entries[i]; i++) {
-		if (config_rom_entries[i]->add(host)) {
-			HPSB_ERR("fw-host%d: Failed to attach config rom entry `%s'",
-				 host->id, config_rom_entries[i]->name);
-			error = -1;
-		} else {
-			host->config_roms |= config_rom_entries[i]->flag;
-			host->update_config_rom = 1;
-		}
-	}
-
-	return error;
-}
-
-/* Remove extra config roms from specified host */
-void hpsb_remove_extra_config_roms(struct hpsb_host *host)
-{
-	int i;
-
-	for (i = 0; config_rom_entries[i]; i++) {
-		if (!(host->config_roms & config_rom_entries[i]->flag))
-			continue;
-
-		config_rom_entries[i]->remove(host);
-
-		host->config_roms &= ~config_rom_entries[i]->flag;
-		host->update_config_rom = 1;
-	}
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++)
+		config_rom_entries[i]->cleanup();
 }
Index: linux/drivers/ieee1394/config_roms.h
===================================================================
--- linux.orig/drivers/ieee1394/config_roms.h
+++ linux/drivers/ieee1394/config_roms.h
@@ -6,11 +6,14 @@ struct hpsb_host;
 int hpsb_default_host_entry(struct hpsb_host *host);
 int hpsb_init_config_roms(void);
 void hpsb_cleanup_config_roms(void);
-int hpsb_add_extra_config_roms(struct hpsb_host *host);
-void hpsb_remove_extra_config_roms(struct hpsb_host *host);
 
 /* List of flags to check if a host contains a certain extra config rom
  * entry. Available in the host->config_roms member. */
 #define HPSB_CONFIG_ROM_ENTRY_IP1394		0x00000001
 
+#ifdef CONFIG_IEEE1394_ETH1394_ROM_ENTRY
+int hpsb_config_rom_ip1394_add(struct hpsb_host *host);
+void hpsb_config_rom_ip1394_remove(struct hpsb_host *host);
+#endif
+
 #endif /* _IEEE1394_CONFIG_ROMS_H */
Index: linux/drivers/ieee1394/eth1394.c
===================================================================
--- linux.orig/drivers/ieee1394/eth1394.c
+++ linux/drivers/ieee1394/eth1394.c
@@ -561,8 +561,10 @@ static void ether1394_add_host (struct h
 	struct eth1394_priv *priv;
 	u64 fifo_addr;
 
-	if (!(host->config_roms & HPSB_CONFIG_ROM_ENTRY_IP1394))
+	if (hpsb_config_rom_ip1394_add(host) != 0) {
+		ETH1394_PRINT_G(KERN_ERR, "Can't add IP-over-1394 ROM entry\n");
 		return;
+	}
 
 	fifo_addr = hpsb_allocate_and_register_addrspace(
 			&eth1394_highlevel, host, &addr_ops,
@@ -570,6 +572,7 @@ static void ether1394_add_host (struct h
 			CSR1212_INVALID_ADDR_SPACE, CSR1212_INVALID_ADDR_SPACE);
 	if (fifo_addr == CSR1212_INVALID_ADDR_SPACE) {
 		ETH1394_PRINT_G(KERN_ERR, "Cannot register CSR space\n");
+		hpsb_config_rom_ip1394_remove(host);
 		return;
 	}
 
@@ -649,6 +652,7 @@ out:
 	if (hi)
 		hpsb_destroy_hostinfo(&eth1394_highlevel, host);
 	hpsb_unregister_addrspace(&eth1394_highlevel, host, fifo_addr);
+	hpsb_config_rom_ip1394_remove(host);
 }
 
 /* Remove a card from our list */
@@ -662,6 +666,7 @@ static void ether1394_remove_host (struc
 		return;
 	priv = netdev_priv(hi->dev);
 	hpsb_unregister_addrspace(&eth1394_highlevel, host, priv->local_fifo);
+	hpsb_config_rom_ip1394_remove(host);
 	if (priv->iso)
 		hpsb_iso_shutdown(priv->iso);
 	unregister_netdev(hi->dev);
Index: linux/drivers/ieee1394/hosts.c
===================================================================
--- linux.orig/drivers/ieee1394/hosts.c
+++ linux/drivers/ieee1394/hosts.c
@@ -180,7 +180,7 @@ int hpsb_add_host(struct hpsb_host *host
 {
 	if (hpsb_default_host_entry(host))
 		return -ENOMEM;
-	hpsb_add_extra_config_roms(host);
+
 	highlevel_add_host(host);
 	return 0;
 }
@@ -202,7 +202,6 @@ void hpsb_remove_host(struct hpsb_host *
 
 	host->driver = &dummy_driver;
 	highlevel_remove_host(host);
-	hpsb_remove_extra_config_roms(host);
 
 	class_device_unregister(&host->class_dev);
 	device_unregister(&host->device);



-- 
Stefan Richter
-=====-=-=== --== ==-==
http://arcgraph.de/sr/

