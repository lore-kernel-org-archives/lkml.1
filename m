Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZJKWSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZJKWSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZJKWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:17:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZJKWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:17:57 -0400
Message-ID: <4AD2594C.70003@kernel.org>
Date: Sun, 11 Oct 2009 15:16:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Brad Spengler <spender@grsecurity.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [RFC PATCH] ia64/pci: add ext pci config detection for SAL 3.2 less
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org> <4AD24766.7050205@kernel.org>
In-Reply-To: <4AD24766.7050205@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> Brad reported that his SGI 750 (Itanium 1) will crash from 2.6.26, and bisected
> to 
> 
> | commit: dfadd9edff498d767008edc6b2a6e86a7a19934d
> |
> |Many host bridges support a 4k config space, so check them directy
> |instead of using quirks to add them.
> |
> |We only need to do this extra check for host bridges at this point,
> |because only host bridges are known to have extended address space
> |without also having a PCI-X/PCI-E caps.  Other devices with this
> |property could be done with quirks (if there are any).
> |
> |As a bonus, we can remove the quirks for AMD host bridges with family
> |10h and 11h since they're not needed any more.
> |
> |With this patch, we can get correct pci cfg size of new Intel CPUs/IOHs
> |with host bridges.
> 
> it turns out for old IA64 without SAL 3.2 pci_cfg_space_size_ext will cause
> problem and those system didn't have PCI-X and PCI-E, so that function was
> not called before.
> 
> so don't call it in pci_cfg_sapce_size now.
> later call it after pci ops code in ia64 could detect and use raw_pci_ops
> and raw_pci_ext_ops according to SAL version.
> 

for 2.6.33...

[RFC PATCH] ia64/pci: add ext pci config detection for SAL 3.2 less

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index bf79155..12c6b70 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -44,7 +44,57 @@
 #define PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg)	\
 	(((u64) seg << 28) | (bus << 20) | (devfn << 12) | (reg))
 
-int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
+struct pci_raw_ops {
+	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val);
+	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val);
+};
+
+static int sal_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
+			int reg, int len, u32 *value)
+{
+	u64 addr, data = 0;
+	int mode, result;
+
+	if (!value || !seg || (bus > 255) || (devfn > 255) || (reg > 255))
+		return -EINVAL;
+
+	addr = PCI_SAL_ADDRESS(seg, bus, devfn, reg);
+	mode = 0;
+
+	result = ia64_sal_pci_config_read(addr, mode, len, &data);
+	if (result != 0)
+		return -EINVAL;
+
+	*value = (u32) data;
+	return 0;
+}
+
+static int sal_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
+			 int reg, int len, u32 value)
+{
+	u64 addr;
+	int mode, result;
+
+	if (!seg || (bus > 255) || (devfn > 255) || (reg > 255))
+		return -EINVAL;
+
+	addr = PCI_SAL_ADDRESS(seg, bus, devfn, reg);
+	mode = 0;
+
+	result = ia64_sal_pci_config_write(addr, mode, len, value);
+	if (result != 0)
+		return -EINVAL;
+	return 0;
+}
+
+static struct pci_raw_ops sal_pci_conf = {
+	.read =		sal_pci_read,
+	.write =	sal_pci_write,
+};
+
+static int sal_pci_ext_read(unsigned int seg, unsigned int bus, unsigned int devfn,
 	      int reg, int len, u32 *value)
 {
 	u64 addr, data = 0;
@@ -53,13 +103,9 @@ int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
 	if (!value || (seg > 65535) || (bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	if ((seg | reg) <= 255) {
-		addr = PCI_SAL_ADDRESS(seg, bus, devfn, reg);
-		mode = 0;
-	} else {
-		addr = PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg);
-		mode = 1;
-	}
+	addr = PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg);
+	mode = 1;
+
 	result = ia64_sal_pci_config_read(addr, mode, len, &data);
 	if (result != 0)
 		return -EINVAL;
@@ -68,7 +114,7 @@ int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
 	return 0;
 }
 
-int raw_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
+static int sal_pci_ext_write(unsigned int seg, unsigned int bus, unsigned int devfn,
 	       int reg, int len, u32 value)
 {
 	u64 addr;
@@ -77,19 +123,51 @@ int raw_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
 	if ((seg > 65535) || (bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	if ((seg | reg) <= 255) {
-		addr = PCI_SAL_ADDRESS(seg, bus, devfn, reg);
-		mode = 0;
-	} else {
-		addr = PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg);
-		mode = 1;
-	}
+	addr = PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg);
+	mode = 1;
+
 	result = ia64_sal_pci_config_write(addr, mode, len, value);
 	if (result != 0)
 		return -EINVAL;
 	return 0;
 }
 
+static struct pci_raw_ops sal_pci_ext_conf = {
+	.read =		sal_pci_ext_read,
+	.write =	sal_pci_ext_write,
+};
+
+static struct pci_raw_ops *raw_pci_ops = sal_pci_ops;
+static struct pci_raw_ops *raw_pci_ext_opsi = NULL;
+
+static __init int pci_arch_init(void)
+{
+	if (sal_revision >= SAL_VERSION_CODE(3,2))
+		raw_pci_ext_ops = sal_pci_ext_ops;
+}
+
+arch_initcall(pci_arch_init);
+
+int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
+	      int reg, int len, u32 *value)
+{
+	if (seg == 0 && reg < 256 && raw_pci_ops)
+		return raw_pci_ops->read(seg, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->read(seg, bus, devfn, reg, len, val);
+        return -EINVAL;
+}
+
+int raw_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
+	       int reg, int len, u32 value)
+{
+	if (seg == 0 && reg < 256 && raw_pci_ops)
+		return raw_pci_ops->write(seg, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->write(seg, bus, devfn, reg, len, val);
+        return -EINVAL;
+}
+
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
 							int size, u32 *value)
 {
