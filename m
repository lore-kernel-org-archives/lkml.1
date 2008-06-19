Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFSW5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFSW5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYFSW4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:56:53 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37822 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbYFSW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:56:52 -0400
Subject: [PCI_ACPI] Modify PCI gap calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 19 Jun 2008 15:56:49 -0700
Message-Id: <1213916210.27983.32.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, we calculate a gap in the low 32bit address space for PCI devices
to assign MMIO resources for hotplug or unconfigured devices,
(pci_mem_start). 
This gap calculation is done by walking the e820 memory space, this
calculation ignores the SRAT for any possible reservations that the
BIOS might have done for memory hotplug. In some cases the
PCI device resources (f.e. Expansion ROMS) end up sharing the address
space with memory hotplug capable regions. 

As a result, when we try to hotadd memory to a system which has less
than 4GB memory to start with, we see resource clashes and the hotadd
requests fail. 

The solution here is to find a PCI gap in the PCI reserved regions as
exported by the ACPI table. We read the _CRS object under PCI0 for
possible producer regions and search for a big enough unclaimed gap
within these producer regions.

There are 2 patches 
1. cleanup of the e820_search_gap function
2. code which walks ACPI resources searching for gap within producer
regions.

I have kept the original e820_find_gap function since in systems with
ACPI disabled we still may need to calculate the gap.

Please have a look. 

Thanks,
Alok

