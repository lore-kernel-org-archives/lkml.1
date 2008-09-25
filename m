Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYIYToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYIYToU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIYToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:44:11 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:47256 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752555AbYIYToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:44:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CLDnh9A19yXMjyfHJuZCk9SFFL4/6x3KeybaRTNP2pu7PxBJ40TxsghImVmOU3BdHVz/rM2AfUh8eS+oQahZJwrFGHU2Uj+RSVXShYEgcps7yv72EspHC8yrW9UZcBmN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Thu, 25 Sep 2008 12:43:41 -0700
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       airlied@gmail.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>
References: <20080923.150722.141587696.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <200809241726.58628.jbarnes@virtuousgeek.org>
In-Reply-To: <200809241726.58628.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251243.43441.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, David Miller wrote:
> I did some snooping around, and while doing so I noticed that the PCI
> mmap code for x86 doesn't do one bit of range checking on the size, or
> any other aspect of the request, wrt. the MMIO regions actually mapped
> in the BARs of the PCI device.

Here's a patch that adds range checking to the sysfs mappings at least.  This 
patch should catch the case where X (or some other process) tries to map 
beyond the specific BAR it's (supposedly) trying to access, making things 
safer in general.  FWIW both my F9 and development versions of X start up 
fine with this patch applied.

DaveM, will this work for you on sparc?  It looked like your code was allowing 
bridge window mappings, but that behavior should be preserved as long as your 
bridge devices reflect their window sizes correctly in their pdev->resources?

If we add similar code to the procfs stuff we wouldn't need to do any checking 
in the arches.

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..f4e8b4e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -502,6 +502,8 @@ pci_mmap_resource(struct kobject *kobj, struct 
bin_attribute *attr,
 	struct resource *res = (struct resource *)attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
+	unsigned long map_len = vma->vm_end - vma->vm_start;
+	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
 	int i;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
@@ -510,6 +512,13 @@ pci_mmap_resource(struct kobject *kobj, struct 
bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	/*
+	 * Make sure the range the user is trying to map falls within
+	 * the resource
+	 */
+	if (map_offset + map_len > pci_resource_len(pdev, i))
+		return -EINVAL;
+
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
 	 * different from the resource itself, arch will do necessary fixup.
