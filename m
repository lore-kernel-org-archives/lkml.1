Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbXGIH1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbXGIH1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXGIHZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:25:51 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:46773 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbXGIHZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:25:50 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4][Doc] Document pci_iomap()
Date: Sun, 8 Jul 2007 18:09:19 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>
References: <200707081754.03824.eike-kernel@sf-tec.de>
In-Reply-To: <200707081754.03824.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081809.20312.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This useful interface is hardly mentioned anywhere in the in-tree
documentation.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 2cb2450818804edcbcb1486a4df0db06e5d49969
tree 2c53fbd2e0be832767446a8684561200b437a695
parent 288a3f1fd00365669ed9ad725b15ff67004cee0a
author Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 14 Aug 2006 14:20:30 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 14 Aug 2006 14:20:30 +0200

 Documentation/DocBook/deviceiobook.tmpl |    1 +
 include/asm-i386/io.h                   |    3 +++
 lib/iomap.c                             |   15 ++++++++++++++-
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/deviceiobook.tmpl b/Documentation/DocBook/deviceiobook.tmpl
index 90ed23d..4f85515 100644
--- a/Documentation/DocBook/deviceiobook.tmpl
+++ b/Documentation/DocBook/deviceiobook.tmpl
@@ -317,6 +317,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_lock, flags)
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
 !Einclude/asm-i386/io.h
+!Elib/iomap.c
   </chapter>
 
 </book>
diff --git a/include/asm-i386/io.h b/include/asm-i386/io.h
index b3724fe..e176483 100644
--- a/include/asm-i386/io.h
+++ b/include/asm-i386/io.h
@@ -112,6 +112,9 @@ extern void __iomem * __ioremap(unsigned long offset, unsigned long size, unsign
  * writew/writel functions and the other mmio helpers. The returned
  * address is not guaranteed to be usable directly as a virtual
  * address. 
+ *
+ * If the area you are trying to map is a PCI BAR you should have a
+ * look on pci_iomap().
  */
 
 static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
diff --git a/lib/iomap.c b/lib/iomap.c
index 55689c5..8de891d 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -202,7 +202,20 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide 
+ * the details if this is a MMIO or PIO address space and will just do what 
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to 
+ * the complete BAR without checking for their length first pass %0 here.
+ **/
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
