Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYFYSWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYFYSWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYFYSWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:22:42 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52584 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYFYSWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:22:41 -0400
Subject: Re: [PATCH 2/2] acpi based pci gap caluculation v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Zhao Yakui <yakui.zhao@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lenb@kernel.org
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1214413073.27577.67.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1214333326.27577.28.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214362159.9800.28.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
	 <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242304q43987059xb203dd1ac75b7583@mail.gmail.com>
	 <1214383095.9800.85.camel@yakui_zhao.sh.intel.com>
	 <1214413073.27577.67.camel@promb-2n-dhcp368.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Jun 2008 11:22:40 -0700
Message-Id: <1214418160.27577.87.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 09:57 -0700, Alok Kataria wrote:

> While writing this mail i figured out that, instead of searching from
> start_addr of _CRS to 2^32 we should just search till *end_addr* of _CRS resource.
> I will send a patch to that effect. 
> 
> Thanks,
> Alok
> 

Ingo, Please also apply this patch to the tip/out-of-tree
--

Incremental patch . This patch passes the pci producer resources
end_addr (got from _CRS) to the e820_search_gap function. 
Without this patch the code will always search from the producer regions
start_address to 2^32, even though the producer region may be smaller. 

Now , we limit the search only within the producer region's address
space. 
Also we put a condition to check if the resource lies in the 32bit
address range. 

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/pci/acpi.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/pci/acpi.c	2008-06-25 10:11:35.000000000 -0700
+++ linux-x86-tree.git/arch/x86/pci/acpi.c	2008-06-25 11:17:31.000000000 -0700
@@ -121,13 +121,21 @@
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 	struct gap_info *gap = data;
+	unsigned long long start_addr, end_addr;
 
 	status = resource_to_addr(resource, &addr);
 	if (ACPI_SUCCESS(status) &&
 	    addr.resource_type == ACPI_MEMORY_RANGE &&
 	    addr.address_length > gap->gapsize) {
-		e820_search_gap(&gap->gapstart, &gap->gapsize,
-				(addr.minimum + addr.translation_offset));
+		start_addr = addr.minimum + addr.translation_offset;
+		/*
+		 * We want space only in the 32bit address range
+		 */
+		if (start_addr < UINT_MAX) {
+			end_addr = start_addr + addr.address_length;
+			e820_search_gap(&gap->gapstart, &gap->gapsize,
+					start_addr, end_addr);
+		}
 	}
 
 	return AE_OK;


