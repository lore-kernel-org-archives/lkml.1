Return-Path: <linux-kernel-owner+w=401wt.eu-S1764571AbZCaXgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764571AbZCaXgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbZCaXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:17 -0400
Received: from sous-sol.org ([216.99.217.87]:33326 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764176AbZCaXWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:15 -0400
Message-Id: <20090331231724.678240580@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 36/45] x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=x86-pat-pci-change-vma-prot-in-pci_mmap-to-reflect-inherited-prot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

upstream commit: 9cdec049389ce2c324fd1ec508a71528a27d4a07

While looking at the issue in the thread:

  http://marc.info/?l=dri-devel&m=123606627824556&w=2

noticed a bug in pci PAT code and memory type setting.

PCI mmap code did not set the proper protection in vma, when it
inherited protection in reserve_memtype. This bug only affects
the case where there exists a WC mapping before X does an mmap
with /proc or /sys pci interface. This will cause X userlevel
mmap from /proc or /sysfs to fail on fork.

Reported-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090323190720.GA16831@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/pci/i386.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *
 			return -EINVAL;
 		}
 		flags = new_flags;
+		vma->vm_page_prot = __pgprot(
+			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
+			flags);
 	}
 
 	if (((vma->vm_pgoff < max_low_pfn_mapped) ||

