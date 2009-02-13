Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbZBMElN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbZBMElN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZBMEk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:40:57 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:32915 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZBMEk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:40:57 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, pq@iki.fi, mingo@elte.hu,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 2/2] tracing: add checks for printing pci devices in mmiotrace.
Date: Thu, 12 Feb 2009 20:42:21 -0500
Message-Id: <1234489341-18630-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1234489192-18594-1-git-send-email-wenji.huang@oracle.com>
References: <1234489192-18594-1-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4994F9C3.013A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to provide checking return value of trace_seq_printf
so as to keep completeness of mmio_print_pcidev.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_mmiotrace.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index c401b90..ebb0b61 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -56,17 +56,19 @@ static void mmio_trace_start(struct trace_array *tr)
 	mmio_reset_data(tr);
 }
 
-static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+static enum print_line_t mmio_print_pcidev(struct trace_seq *s,
+					   const struct pci_dev *dev)
 {
 	int ret = 0;
 	int i;
 	resource_size_t start, end;
 	const struct pci_driver *drv = pci_dev_driver(dev);
 
-	/* XXX: incomplete checks for trace_seq_printf() return value */
-	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+	ret = trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
 				dev->bus->number, dev->devfn,
 				dev->vendor, dev->device, dev->irq);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 	/*
 	 * XXX: is pci_resource_to_user() appropriate, since we are
 	 * supposed to interpret the __ioremap() phys_addr argument based on
@@ -74,21 +76,25 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 	 */
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		ret = trace_seq_printf(s, " %llx",
 			(unsigned long long)(start |
 			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
-	}
-	for (i = 0; i < 7; i++) {
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		ret = trace_seq_printf(s, " %llx",
 			dev->resource[i].start < dev->resource[i].end ?
 			(unsigned long long)(end - start) + 1 : 0);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
 	}
 	if (drv)
-		ret += trace_seq_printf(s, " %s\n", drv->name);
+		ret = trace_seq_printf(s, " %s\n", drv->name);
 	else
-		ret += trace_seq_printf(s, " \n");
-	return ret;
+		ret = trace_seq_printf(s, " \n");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
 }
 
 static void destroy_header_iter(struct header_iter *hiter)
-- 
1.5.6

