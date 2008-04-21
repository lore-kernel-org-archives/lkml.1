Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYDUHyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYDUHyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYDUHyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:54:36 -0400
Received: from hall2.aurel32.net ([91.121.138.14]:47090 "EHLO
	hall2.aurel32.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYDUHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:54:35 -0400
Date: Mon, 21 Apr 2008 09:54:33 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] BCM47xx: Add platform specific PCI code
Message-ID: <20080421075433.GA3966@hall2.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Ralf Baechle <ralf@linux-mips.org>, Michael Buesch <mb@bu3sch.de>,
	linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, ported from OpenWRT SVN, defines pcibios_map_irq() and
pcibios_plat_dev_init() for the BCM47xx platform.

It fixes the regression introduced by commit
aab547ce0d1493d400b6468c521a0137cd8c1edf.
---
 arch/mips/pci/Makefile      |    1 +
 arch/mips/pci/pci-bcm47xx.c |   58 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/pci/pci-bcm47xx.c

diff --git a/arch/mips/pci/Makefile b/arch/mips/pci/Makefile
index ed0c076..64ba3fa 100644
--- a/arch/mips/pci/Makefile
+++ b/arch/mips/pci/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MIPS_TX3927)	+= ops-tx3927.o
 obj-$(CONFIG_PCI_VR41XX)	+= ops-vr41xx.o pci-vr41xx.o
 obj-$(CONFIG_NEC_CMBVR4133)	+= fixup-vr4133.o
 obj-$(CONFIG_MARKEINS)		+= ops-emma2rh.o pci-emma2rh.o fixup-emma2rh.o
+obj-$(CONFIG_BCM47XX)		+= pci-bcm47xx.o
 
 #
 # These are still pretty much in the old state, watch, go blind.
diff --git a/arch/mips/pci/pci-bcm47xx.c b/arch/mips/pci/pci-bcm47xx.c
new file mode 100644
index 0000000..64ccb4f
--- /dev/null
+++ b/arch/mips/pci/pci-bcm47xx.c
@@ -0,0 +1,58 @@
+/*
+ *  Copyright (C) 2008 Michael Buesch <mb@bu3sch.de>
+ *  Copyright (C) 2008 Aurelien Jarno <aurelien@aurel32.net>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/ssb/ssb.h>
+
+int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	int res;
+
+	res = ssb_pcibios_map_irq(dev, slot, pin);
+	if (res < 0) {
+		printk(KERN_ALERT "PCI: Failed to map IRQ of device %s\n",
+		       dev->dev.bus_id);
+		return 0;
+	}
+	/* IRQ-0 and IRQ-1 are software interrupts. */
+	WARN_ON((res == 0) || (res == 1));
+
+	return res;
+}
+
+int pcibios_plat_dev_init(struct pci_dev *dev)
+{
+	int err;
+
+	err = ssb_pcibios_plat_dev_init(dev);
+	if (err) {
+		printk(KERN_ALERT "PCI: Failed to init device %s\n",
+		       pci_name(dev));
+	}
+
+	return err;
+}
+
-- 
1.5.5


-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
