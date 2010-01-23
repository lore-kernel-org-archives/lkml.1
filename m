Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691Ab0AWATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0AWATS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100Ab0AWATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:19:06 -0500
Received: from kroah.org ([198.145.64.141]:35099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab0AWATB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.274779432@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Schlichter <thomas.schlichter@web.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [24/29] x86/PCI/PAT: return EINVAL for pci mmap WC request for !pat_enabled
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 2992e545ea006992ec9dc91c4fa996ce1e15f921 upstream.

Thomas Schlichter reported:
> X.org uses libpciaccess which tries to mmap with write combining enabled via
> /sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, the
> kernel does fall back to uncached mmap. Then libpciaccess thinks it succeeded
> mapping with write combining enabled and does not set up suited MTRR entries.
> ;-(

Instead of silently mapping pci mmap region as UC minus in the case
of !pat_enabled and wc request, we can return error. Eric Anholt mentioned
that caller (like X) typically follows up with UC minus pci mmap request and
if there is a free mtrr slot, caller will manage adding WC mtrr.

Jesse Barnes says:
> Older versions of libpciaccess will behave better if we do it that way
> (iirc it only allocates an MTRR if the resource_wc file doesn't exist or
> fails to get mapped).

Reported-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Eric Anholt <eric@anholt.net>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/i386.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -282,6 +282,15 @@ int pci_mmap_page_range(struct pci_dev *
 		return -EINVAL;
 
 	prot = pgprot_val(vma->vm_page_prot);
+
+	/*
+ 	 * Return error if pat is not enabled and write_combine is requested.
+ 	 * Caller can followup with UC MINUS request and add a WC mtrr if there
+ 	 * is a free mtrr slot.
+ 	 */
+	if (!pat_enabled && write_combine)
+		return -EINVAL;
+
 	if (pat_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
 	else if (pat_enabled || boot_cpu_data.x86 > 3)


