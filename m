Return-Path: <linux-kernel-owner+w=401wt.eu-S2992625AbXCBRDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992625AbXCBRDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992626AbXCBRDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:03:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992625AbXCBRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:03:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=DVGmsMtPCdw6AVXo6HxdoiZzcpYLwodZZQUfGsEAkjfxMz7mMC16hGWtSGjLQlxAx
	2y97ae9/YAW+YAriDbzVg==
Date: Fri, 2 Mar 2007 09:03:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch -mm] x86_64: fake numa cmdline flag fix
In-Reply-To: <1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0703020901510.14893@chino.kir.corp.google.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
 <1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we only reference 'cmdline' on CONFIG_NUMA_EMU.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/numa.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -524,22 +524,28 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 { 
 	unsigned long start_addr = start_pfn << PAGE_SHIFT;
 	unsigned long end_addr = end_pfn << PAGE_SHIFT;
+	int numa_fake = 0;
 	int i;
 
+#ifdef CONFIG_NUMA_EMU
+	/* Determine if we have a numa=fake command line */
+	if (cmdline != 0)
+		numa_fake = 1;
+#endif
+
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && !cmdline && !acpi_scan_nodes(start_addr, end_addr))
+	if (!numa_off && !numa_fake && !acpi_scan_nodes(start_addr, end_addr))
  		return;
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, cmdline != 0))
-		if (cmdline == 0)
+	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, numa_fake))
+		if (!numa_fake)
 			return;
 #endif
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline)
-	{
+	if (numa_fake) {
 		numa_emu = !numa_emulation(start_pfn, end_pfn);
 		if (numa_emu)
 			return;
