Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXEOEE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXEOEE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXEOEEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:04:21 -0400
Received: from ozlabs.org ([203.10.76.45]:45151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbXEOEEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:04:21 -0400
To: Paul Mackerras <paulus@samba.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd.bergmann@de.ibm.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 15 May 2007 14:03:50 +1000
Subject: [PATCH 1/2] powerpc: Add spinlock to request_phb_iospace()
Message-Id: <20070515040419.D8F14DDEA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

request_phb_iospace() can be called from different CPUs at init
time (at least with my next patch) and thus needs a spinlock. As
for the next patch, this is a temporary workaround for 2.6.22
issues until my rewrite of IO mappings is ready (for 2.6.23)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 arch/powerpc/mm/pgtable_64.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-cell/arch/powerpc/mm/pgtable_64.c
===================================================================
--- linux-cell.orig/arch/powerpc/mm/pgtable_64.c	2007-05-15 13:17:59.000000000 +1000
+++ linux-cell/arch/powerpc/mm/pgtable_64.c	2007-05-15 13:18:32.000000000 +1000
@@ -322,6 +322,8 @@ EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(__iounmap);
 
+static DEFINE_SPINLOCK(phb_io_lock);
+
 void __iomem * reserve_phb_iospace(unsigned long size)
 {
 	void __iomem *virt_addr;
@@ -329,8 +331,10 @@ void __iomem * reserve_phb_iospace(unsig
 	if (phbs_io_bot >= IMALLOC_BASE) 
 		panic("reserve_phb_iospace(): phb io space overflow\n");
 			
+	spin_lock(&phb_io_lock);
 	virt_addr = (void __iomem *) phbs_io_bot;
 	phbs_io_bot += size;
+	spin_unlock(&phb_io_lock);
 
 	return virt_addr;
 }
