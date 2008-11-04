Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYKDXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYKDXrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYKDXjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:16 -0500
Received: from mail.suse.de ([195.135.220.2]:47506 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbYKDXjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:14 -0500
Date: Tue, 4 Nov 2008 15:31:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 27/57] powerpc: fix i2c on PPC linkstation / kurobox
	machines
Message-ID: <20081104233157.GB659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-i2c-on-ppc-linkstation-kurobox-machines.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 22e181ba7f09197dd6f35a48013cb86289644eb6 upstream.

The i2c bus defn is broken on linkstation / kurobox machines since at
least 2.6.27. Fix it. Also remove CONFIG_SERIAL_OF_PLATFORM, which, if
enabled, breaks the serial console after the
"console handover: boot [udbg0] -> real [ttyS1]" message.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/configs/linkstation_defconfig       |    7 +++----
 arch/powerpc/platforms/embedded6xx/linkstation.c |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.27-rc4
-# Thu Aug 21 00:52:05 2008
+# Linux kernel version: 2.6.27
+# Fri Oct 24 00:42:39 2008
 #
 # CONFIG_PPC64 is not set
 
@@ -934,7 +934,7 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=4
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_JSM is not set
-CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_SERIAL_OF_PLATFORM is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -1211,7 +1211,6 @@ CONFIG_USB_STORAGE=m
 # CONFIG_USB_STORAGE_ALAUDA is not set
 # CONFIG_USB_STORAGE_ONETOUCH is not set
 # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_SIERRA is not set
 # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 # CONFIG_USB_LIBUSUAL is not set
 
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/initrd.h>
 #include <linux/mtd/physmap.h>
+#include <linux/of_platform.h>
 
 #include <asm/time.h>
 #include <asm/prom.h>
@@ -54,6 +55,19 @@ static struct mtd_partition linkstation_
 	},
 };
 
+static __initdata struct of_device_id of_bus_ids[] = {
+	{ .type = "soc", },
+	{ .compatible = "simple-bus", },
+	{},
+};
+
+static int __init declare_of_platform_devices(void)
+{
+	of_platform_bus_probe(NULL, of_bus_ids, NULL);
+	return 0;
+}
+machine_device_initcall(linkstation, declare_of_platform_devices);
+
 static int __init linkstation_add_bridge(struct device_node *dev)
 {
 #ifdef CONFIG_PCI

-- 
