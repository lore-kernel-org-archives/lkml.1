Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZJWW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZJWW03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZJWW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:26:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:44354 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZJWW02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:26:28 -0400
X-ExtLoop1: 1
Subject: [patch] x86, pat: return EINVAL for pci mmap WC request for
 !pat_enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Schlichter <thomas.schlichter@web.de>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Eric Anholt <eric@anholt.net>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 23 Oct 2009 15:26:00 -0700
Message-Id: <1256336760.2576.8.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..a672f12 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -282,6 +282,15 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
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


