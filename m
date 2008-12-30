Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYL3VlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYL3VlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYL3VlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:41:07 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:39967 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYL3VlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:41:06 -0500
Date: Tue, 30 Dec 2008 22:41:03 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: RFC: pci_write_bits*() convenience functions v.2
Message-ID: <20081230214103.GA5141@rere.qmqm.pl>
References: <20081223215938.GA32714@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081223215938.GA32714@rere.qmqm.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version of the pci_write_bits*() with error checking included.

I don't know if you like the #defined function generator, but at
least this avoids copy-and-paste errors in case this needs some
changes in the future.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 4b55ec6..f1f8b94 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -722,54 +722,6 @@ struct edac_pci_ctl_info {
 #define to_edac_pci_ctl_work(w) \
 		container_of(w, struct edac_pci_ctl_info,work)
 
-/* write all or some bits in a byte-register*/
-static inline void pci_write_bits8(struct pci_dev *pdev, int offset, u8 value,
-				   u8 mask)
-{
-	if (mask != 0xff) {
-		u8 buf;
-
-		pci_read_config_byte(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_byte(pdev, offset, value);
-}
-
-/* write all or some bits in a word-register*/
-static inline void pci_write_bits16(struct pci_dev *pdev, int offset,
-				    u16 value, u16 mask)
-{
-	if (mask != 0xffff) {
-		u16 buf;
-
-		pci_read_config_word(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_word(pdev, offset, value);
-}
-
-/* write all or some bits in a dword-register*/
-static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
-				    u32 value, u32 mask)
-{
-	if (mask != 0xffff) {
-		u32 buf;
-
-		pci_read_config_dword(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_dword(pdev, offset, value);
-}
-
 #endif				/* CONFIG_PCI */
 
 extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index feb4657..f5a4112 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -610,6 +610,28 @@ static inline int pci_write_config_dword(struct pci_dev *dev, int where,
 	return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
 }
 
+#define GEN_PCI_UPDATE_FUNC(t,b)					\
+static inline int pci_write_bits##b(struct pci_dev *dev, int where,	\
+	u##b value, u##b mask)						\
+{									\
+	u##b buf;							\
+	int err;							\
+									\
+	err = pci_read_config_##t(dev, where, &buf);			\
+	if (err)							\
+		return err;						\
+									\
+	buf &= ~mask;							\
+	buf |= value;							\
+									\
+	return pci_write_config_##t(dev, where, buf);			\
+}
+
+GEN_PCI_UPDATE_FUNC(byte, 8)
+GEN_PCI_UPDATE_FUNC(word, 16)
+GEN_PCI_UPDATE_FUNC(dword, 32)
+#undef GEN_PCI_UPDATE_FUNC
+
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);
