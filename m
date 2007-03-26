Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbXCZWwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbXCZWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXCZWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:52:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43633 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794AbXCZWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:52:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Mar 2007 00:51:39 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: eth1394: don't autoload by hotplug when ohci1394
 starts
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c24f659c0675d7d5@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
  - let eth193 add the ROM entry by itself, i.e. only after eth1394 was
    loaded,
  - add a new kernel config option which brings back the old behavior
    for those who liked it.  We don't re-use the old config option
    because then nobody would notice that there is a choice now.  This
    new option is scheduled to be removed soon.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=7793 .

Autoloading of eth1394 when an _external_ IP-over-1394 capable device is
discovered is _not_ affected by this patch.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Instead of keeping this until the proposed date of removal (June 2007),
should I kill CONFIG_IEEE1394_AUTOLOAD_ETH1394 right away?


 Documentation/feature-removal-schedule.txt |    9 +++
 drivers/ieee1394/Kconfig                   |   49 ++++++++++++---------
 drivers/ieee1394/config_roms.c             |   47 +++++++++++++++-----
 drivers/ieee1394/config_roms.h             |   10 ++++
 drivers/ieee1394/eth1394.c                 |    9 +++
 5 files changed, 91 insertions(+), 33 deletions(-)

Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt
+++ linux/Documentation/feature-removal-schedule.txt
@@ -29,6 +29,15 @@ Who:	Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
+What:	eth1394 autoloading (CONFIG_IEEE1394_AUTOLOAD_ETH1394)
+When:	June 2007
+Why:	Can be emulated by adding the following lines to /etc/modprobe.conf:
+		install ohci1394 /sbin/modprobe eth1394; \
+				 /sbin/modprobe --ignore-install ohci1394"
+Who:	Stefan Richter <stefanr@s5r6.in-berlin.de>
+
+---------------------------
+
 What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
 When:	June 2007
 Why:	Deprecated in favour of the more efficient and robust rawiso interface.
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
@@ -135,6 +122,28 @@ config IEEE1394_ETH1394
 	  This driver is still considered experimental.  It does not yet support
 	  MCAP, therefore multicast support is significantly limited.
 
+	  The module is called eth1394 although it does not emulate Ethernet.
+
+config IEEE1394_AUTOLOAD_ETH1394
+	bool "Autoload IP over 1394 (deprecated)"
+	depends on IEEE1394_ETH1394
+	help
+	  This lets the ieee1394 base driver include an IP-over-1394 in the
+	  configuration ROM of each FireWire controller even before eth1394 was
+	  loaded.  As a result, a hotplug event will follow after initialization
+	  of the controller which will typically cause eth1394 to be loaded.
+	  The downsides are that the eth1394 networking interfaces may be
+	  created earlier than expected by the user, and that IP-over-1394
+	  capability will be advertized to remote FireWire peers even if loading
+	  of eth1394 was prevented.
+
+	  To get the same behaviour as in older kernels, either say Y, or add
+	  the line "install ohci1394 /sbin/modprobe eth1394; /sbin/modprobe
+	  --ignore-install ohci1394" to modprobe.conf and say N here.
+
+	  Regardless if you say Y or N, autoloading of eth1394 will still work
+	  if an external IP-over-1394 capable device is discovered on the bus.
+
 config IEEE1394_DV1394
 	tristate "OHCI-DV I/O support (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
Index: linux/drivers/ieee1394/config_roms.c
===================================================================
--- linux.orig/drivers/ieee1394/config_roms.c
+++ linux/drivers/ieee1394/config_roms.c
@@ -78,7 +78,7 @@ int hpsb_default_host_entry(struct hpsb_
 }
 
 
-#ifdef CONFIG_IEEE1394_CONFIG_ROM_IP1394
+#ifdef CONFIG_IEEE1394_ETH1394_ROM_ENTRY
 #include "eth1394.h"
 
 static struct csr1212_keyval *ip1394_ud;
@@ -154,22 +154,42 @@ static void config_rom_ip1394_remove(str
 	csr1212_detach_keyval_from_directory(host->csr.rom->root_kv, ip1394_ud);
 }
 
+#ifndef CONFIG_IEEE1394_AUTOLOAD_ETH1394
+void hpsb_config_rom_ip1394_add(struct hpsb_host *host)
+{
+	if (config_rom_ip1394_add(host) == 0) {
+		host->config_roms |= HPSB_CONFIG_ROM_ENTRY_IP1394;
+		host->update_config_rom = 1;
+	}
+}
+EXPORT_SYMBOL_GPL(hpsb_config_rom_ip1394_add);
+
+void hpsb_config_rom_ip1394_remove(struct hpsb_host *host)
+{
+	config_rom_ip1394_remove(host);
+	host->config_roms &= ~HPSB_CONFIG_ROM_ENTRY_IP1394;
+	host->update_config_rom = 1;
+}
+EXPORT_SYMBOL_GPL(hpsb_config_rom_ip1394_remove);
+#endif
+
 static struct hpsb_config_rom_entry ip1394_entry = {
 	.name		= "ip1394",
 	.init		= config_rom_ip1394_init,
+#ifdef CONFIG_IEEE1394_AUTOLOAD_ETH1394
 	.add		= config_rom_ip1394_add,
 	.remove		= config_rom_ip1394_remove,
+#endif
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
@@ -177,7 +197,7 @@ int hpsb_init_config_roms(void)
 {
 	int i, error = 0;
 
-	for (i = 0; config_rom_entries[i]; i++) {
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++) {
 		if (!config_rom_entries[i]->init)
 			continue;
 
@@ -186,8 +206,8 @@ int hpsb_init_config_roms(void)
 				 config_rom_entries[i]->name);
 			error = -1;
 		} else
-			HPSB_DEBUG("Initialized config rom entry `%s'",
-				   config_rom_entries[i]->name);
+			HPSB_VERBOSE("Initialized config rom entry `%s'",
+				     config_rom_entries[i]->name);
 	}
 
 	return error;
@@ -198,10 +218,9 @@ void hpsb_cleanup_config_roms(void)
 {
 	int i;
 
-	for (i = 0; config_rom_entries[i]; i++) {
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++)
 		if (config_rom_entries[i]->cleanup)
 			config_rom_entries[i]->cleanup();
-	}
 }
 
 /* Add extra config roms to specified host */
@@ -209,7 +228,10 @@ int hpsb_add_extra_config_roms(struct hp
 {
 	int i, error = 0;
 
-	for (i = 0; config_rom_entries[i]; i++) {
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++) {
+		if (!config_rom_entries[i]->add)
+			continue;
+
 		if (config_rom_entries[i]->add(host)) {
 			HPSB_ERR("fw-host%d: Failed to attach config rom entry `%s'",
 				 host->id, config_rom_entries[i]->name);
@@ -228,8 +250,9 @@ void hpsb_remove_extra_config_roms(struc
 {
 	int i;
 
-	for (i = 0; config_rom_entries[i]; i++) {
-		if (!(host->config_roms & config_rom_entries[i]->flag))
+	for (i = 0; i < ARRAY_SIZE(config_rom_entries); i++) {
+		if (!(host->config_roms & config_rom_entries[i]->flag) ||
+		    !config_rom_entries[i]->remove)
 			continue;
 
 		config_rom_entries[i]->remove(host);
Index: linux/drivers/ieee1394/config_roms.h
===================================================================
--- linux.orig/drivers/ieee1394/config_roms.h
+++ linux/drivers/ieee1394/config_roms.h
@@ -13,4 +13,14 @@ void hpsb_remove_extra_config_roms(struc
  * entry. Available in the host->config_roms member. */
 #define HPSB_CONFIG_ROM_ENTRY_IP1394		0x00000001
 
+#ifdef CONFIG_IEEE1394_ETH1394_ROM_ENTRY
+#    ifdef CONFIG_IEEE1394_AUTOLOAD_ETH1394
+#	define hpsb_config_rom_ip1394_add(host)     do {} while (0)
+#	define hpsb_config_rom_ip1394_remove(host)  do {} while (0)
+#    else
+void hpsb_config_rom_ip1394_add(struct hpsb_host *host);
+void hpsb_config_rom_ip1394_remove(struct hpsb_host *host);
+#    endif
+#endif
+
 #endif /* _IEEE1394_CONFIG_ROMS_H */
Index: linux/drivers/ieee1394/eth1394.c
===================================================================
--- linux.orig/drivers/ieee1394/eth1394.c
+++ linux/drivers/ieee1394/eth1394.c
@@ -561,8 +561,12 @@ static void ether1394_add_host (struct h
 	struct eth1394_priv *priv;
 	u64 fifo_addr;
 
-	if (!(host->config_roms & HPSB_CONFIG_ROM_ENTRY_IP1394))
+	hpsb_config_rom_ip1394_add(host);
+
+	if (!(host->config_roms & HPSB_CONFIG_ROM_ENTRY_IP1394)) {
+		ETH1394_PRINT_G(KERN_ERR, "missing IP-over-1394 ROM entry\n");
 		return;
+	}
 
 	fifo_addr = hpsb_allocate_and_register_addrspace(
 			&eth1394_highlevel, host, &addr_ops,
@@ -570,6 +574,7 @@ static void ether1394_add_host (struct h
 			CSR1212_INVALID_ADDR_SPACE, CSR1212_INVALID_ADDR_SPACE);
 	if (fifo_addr == CSR1212_INVALID_ADDR_SPACE) {
 		ETH1394_PRINT_G(KERN_ERR, "Cannot register CSR space\n");
+		hpsb_config_rom_ip1394_remove(host);
 		return;
 	}
 
@@ -649,6 +654,7 @@ out:
 	if (hi)
 		hpsb_destroy_hostinfo(&eth1394_highlevel, host);
 	hpsb_unregister_addrspace(&eth1394_highlevel, host, fifo_addr);
+	hpsb_config_rom_ip1394_remove(host);
 }
 
 /* Remove a card from our list */
@@ -662,6 +668,7 @@ static void ether1394_remove_host (struc
 		return;
 	priv = netdev_priv(hi->dev);
 	hpsb_unregister_addrspace(&eth1394_highlevel, host, priv->local_fifo);
+	hpsb_config_rom_ip1394_remove(host);
 	if (priv->iso)
 		hpsb_iso_shutdown(priv->iso);
 	unregister_netdev(hi->dev);

-- 
Stefan Richter
-=====-=-=== --== ==-==
http://arcgraph.de/sr/

