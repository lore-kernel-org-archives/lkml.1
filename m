Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbXGRJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbXGRJdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbXGRJct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:32:49 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54322 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbXGRJcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:32:47 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "lkml List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] fake the NUMA SLIT
Date: Wed, 18 Jul 2007 11:30:58 +0200
User-Agent: KMail/1.9.7
cc: gregkh@suse.de, "Andreas Kleen" <ak@suse.de>, lenb@kernel.org,
       "Christoph Lameter" <clameter@sgi.com>
References: <200707181130.01861.joachim.deguara@amd.com>
In-Reply-To: <200707181130.01861.joachim.deguara@amd.com>
MIME-Version: 1.0
Message-ID: <200707181130.58945.joachim.deguara@amd.com>
X-OriginalArrivalTime: 18 Jul 2007 09:32:25.0171 (UTC)
 FILETIME=[8CCBB230:01C7C91E]
X-WSS-ID: 6A8301A50X81901213-11-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most x86 NUMA systems do not have a SLIT provided by them from the BIOS.  We 
want to fake this by either creating one or copying the original.  The reason 
to do this is so to later be able to alter it. 

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
--
Index: kernel/drivers/acpi/numa.c
===================================================================
--- kernel.orig/drivers/acpi/numa.c
+++ kernel/drivers/acpi/numa.c
@@ -228,6 +228,28 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
+int __init acpi_numa_slit_fixup(void)
+{
+	/* either no SLIT table from ACPI so we create one or we just copy*/
+	struct acpi_table_slit *fake_slit;
+	u32 localities = num_online_nodes();
+	int i, j, slitsize;
+
+	slitsize = sizeof(struct acpi_table_slit) + localities * localities - 1;
+	fake_slit = kmalloc(slitsize, GFP_KERNEL);
+	if (!fake_slit)
+		return -ENOMEM;
+
+	fake_slit->locality_count = localities;
+	for (i = 0; i < localities; i++)
+		for (j = 0; j < localities; j++)
+			fake_slit->entry[i*localities + j] = node_distance(i,j);
+
+	acpi_numa_slit_init(fake_slit);
+
+	return 0;
+}
+
 int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long pxm;
Index: kernel/drivers/acpi/bus.c
===================================================================
--- kernel.orig/drivers/acpi/bus.c
+++ kernel/drivers/acpi/bus.c
@@ -650,6 +650,10 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
+#ifdef CONFIG_ACPI_NUMA
+	acpi_numa_slit_fixup();
+#endif
+
 	return;
 
       error0:



