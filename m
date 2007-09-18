Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbXIRXIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbXIRXIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXIRXIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:08:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45672 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbXIRXIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:08:41 -0400
Message-ID: <46F05A74.2000005@garzik.org>
Date: Tue, 18 Sep 2007 19:08:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>	 <20070918113401.6a8a737f@the-village.bc.nu>	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>	 <46F0332D.3050704@garzik.org> <1190154053.6403.125.camel@localhost.localdomain>
In-Reply-To: <1190154053.6403.125.camel@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------000506090305050902010909"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000506090305050902010909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Benjamin Herrenschmidt wrote:
> On Tue, 2007-09-18 at 16:21 -0400, Jeff Garzik wrote:
>> A new pci_mmio_map() helper, to be used with 100% MMIO hardware, might
>> help eliminate confusion. 
> 
> Maybe not the best name in theory but at least would show that it
> relates to existing ioremap would be pci_ioremap()


Easy enough... 'pcimap' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

	Jeff



--------------000506090305050902010909
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

commit 6e09c71822f76c618353682bf295fc7588284521
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Sep 18 19:06:08 2007 -0400

    Add pci_ioremap() to generic iomap lib.
    
    (arches that don't wish to use lib/iomap.c's version may fill in their own)
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 include/asm-generic/iomap.h |    1 +
 lib/iomap.c                 |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

6e09c71822f76c618353682bf295fc7588284521
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index cde592f..611e6cf 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -63,6 +63,7 @@ extern void ioport_unmap(void __iomem *);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_ioremap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 #endif
diff --git a/lib/iomap.c b/lib/iomap.c
index 864f2ec..0338da0 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -275,9 +275,43 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	return NULL;
 }
 
+/**
+ * pci_ioremap - create a virtual mapping cookie for a memory-based PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of MMIO memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using read*() and write*().
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
+void __iomem *pci_ioremap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	unsigned long start = pci_resource_start(dev, bar);
+	unsigned long len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return NULL;
+	if (flags & IORESOURCE_MEM) {
+		if (flags & IORESOURCE_CACHEABLE)
+			return ioremap(start, len);
+		return ioremap_nocache(start, len);
+	}
+	/* What? */
+	return NULL;
+}
+
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
 EXPORT_SYMBOL(pci_iomap);
+EXPORT_SYMBOL(pci_ioremap);
 EXPORT_SYMBOL(pci_iounmap);

--------------000506090305050902010909--
