Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbYJRTHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbYJRTHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYJRTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:47330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYJRTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:27 -0400
Date: Sat, 18 Oct 2008 11:34:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 12/17] USB: EHCI: log a warning if ehci-hcd is not loaded
	first
Message-ID: <20081018183424.GM14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ehci-log-a-warning-if-ehci-hcd-is-not-loaded-first.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 9beeee6584b9aa4f9192055512411484a2a624df upstream

This patch (as1139) adds a warning to the system log whenever ehci-hcd
is loaded after ohci-hcd or uhci-hcd.  Nowadays most distributions are
pretty good about not doing this; maybe the warning will help convince
anyone still doing it wrong.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c      |    4 ++++
 drivers/usb/core/hcd.h      |    6 ++++++
 drivers/usb/host/ehci-hcd.c |   15 +++++++++++++--
 drivers/usb/host/ohci-hcd.c |    3 +++
 drivers/usb/host/uhci-hcd.c |    3 +++
 5 files changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -81,6 +81,10 @@
 
 /*-------------------------------------------------------------------------*/
 
+/* Keep track of which host controller drivers are loaded */
+unsigned long usb_hcds_loaded;
+EXPORT_SYMBOL_GPL(usb_hcds_loaded);
+
 /* host controllers we manage */
 LIST_HEAD (usb_bus_list);
 EXPORT_SYMBOL_GPL (usb_bus_list);
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -482,4 +482,10 @@ static inline void usbmon_urb_complete(s
  */
 extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 
+/* Keep track of which host controller drivers are loaded */
+#define USB_UHCI_LOADED		0
+#define USB_OHCI_LOADED		1
+#define USB_EHCI_LOADED		2
+extern unsigned long usb_hcds_loaded;
+
 #endif /* __KERNEL__ */
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1049,6 +1049,12 @@ static int __init ehci_hcd_init(void)
 {
 	int retval = 0;
 
+	set_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
+	if (test_bit(USB_UHCI_LOADED, &usb_hcds_loaded) ||
+			test_bit(USB_OHCI_LOADED, &usb_hcds_loaded))
+		printk(KERN_WARNING "Warning! ehci_hcd should always be loaded"
+				" before uhci_hcd and ohci_hcd, not after\n");
+
 	pr_debug("%s: block sizes: qh %Zd qtd %Zd itd %Zd sitd %Zd\n",
 		 hcd_name,
 		 sizeof(struct ehci_qh), sizeof(struct ehci_qtd),
@@ -1056,8 +1062,10 @@ static int __init ehci_hcd_init(void)
 
 #ifdef DEBUG
 	ehci_debug_root = debugfs_create_dir("ehci", NULL);
-	if (!ehci_debug_root)
-		return -ENOENT;
+	if (!ehci_debug_root) {
+		retval = -ENOENT;
+		goto err_debug;
+	}
 #endif
 
 #ifdef PLATFORM_DRIVER
@@ -1104,7 +1112,9 @@ clean0:
 #ifdef DEBUG
 	debugfs_remove(ehci_debug_root);
 	ehci_debug_root = NULL;
+err_debug:
 #endif
+	clear_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
 	return retval;
 }
 module_init(ehci_hcd_init);
@@ -1126,6 +1136,7 @@ static void __exit ehci_hcd_cleanup(void
 #ifdef DEBUG
 	debugfs_remove(ehci_debug_root);
 #endif
+	clear_bit(USB_EHCI_LOADED, &usb_hcds_loaded);
 }
 module_exit(ehci_hcd_cleanup);
 
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1098,6 +1098,7 @@ static int __init ohci_hcd_mod_init(void
 	printk (KERN_DEBUG "%s: " DRIVER_INFO "\n", hcd_name);
 	pr_debug ("%s: block sizes: ed %Zd td %Zd\n", hcd_name,
 		sizeof (struct ed), sizeof (struct td));
+	set_bit(USB_OHCI_LOADED, &usb_hcds_loaded);
 
 #ifdef DEBUG
 	ohci_debug_root = debugfs_create_dir("ohci", NULL);
@@ -1184,6 +1185,7 @@ static int __init ohci_hcd_mod_init(void
  error_debug:
 #endif
 
+	clear_bit(USB_OHCI_LOADED, &usb_hcds_loaded);
 	return retval;
 }
 module_init(ohci_hcd_mod_init);
@@ -1214,6 +1216,7 @@ static void __exit ohci_hcd_mod_exit(voi
 #ifdef DEBUG
 	debugfs_remove(ohci_debug_root);
 #endif
+	clear_bit(USB_OHCI_LOADED, &usb_hcds_loaded);
 }
 module_exit(ohci_hcd_mod_exit);
 
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -953,6 +953,7 @@ static int __init uhci_hcd_init(void)
 
 	printk(KERN_INFO DRIVER_DESC " " DRIVER_VERSION "%s\n",
 			ignore_oc ? ", overcurrent ignored" : "");
+	set_bit(USB_UHCI_LOADED, &usb_hcds_loaded);
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -988,6 +989,7 @@ debug_failed:
 
 errbuf_failed:
 
+	clear_bit(USB_UHCI_LOADED, &usb_hcds_loaded);
 	return retval;
 }
 
@@ -997,6 +999,7 @@ static void __exit uhci_hcd_cleanup(void
 	kmem_cache_destroy(uhci_up_cachep);
 	debugfs_remove(uhci_debugfs_root);
 	kfree(errbuf);
+	clear_bit(USB_UHCI_LOADED, &usb_hcds_loaded);
 }
 
 module_init(uhci_hcd_init);

-- 
