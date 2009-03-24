Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZCXJoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZCXJoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZCXJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:44:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:50604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZCXJo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:44:28 -0400
Date: Tue, 24 Mar 2009 09:42:29 GMT
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org,
       kjwinchester@gmail.com, suresh.b.siddha@intel.com, airlied@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org,
       kjwinchester@gmail.com, suresh.b.siddha@intel.com, airlied@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323190720.GA16831@linux-os.sc.intel.com>
References: <20090323190720.GA16831@linux-os.sc.intel.com>
Subject: [tip:x86/pat] x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot
Message-ID: <tip-571d1692d564e7782e55738ee87099fa038a3778@git.kernel.org>
Git-Commit-ID: 571d1692d564e7782e55738ee87099fa038a3778
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 09:42:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  571d1692d564e7782e55738ee87099fa038a3778
Gitweb:     http://git.kernel.org/tip/571d1692d564e7782e55738ee87099fa038a3778
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Mon, 23 Mar 2009 12:07:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 10:41:38 +0100

x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot

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
LKML-Reference: <20090323190720.GA16831@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/pci/i386.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5ead808..f234a37 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			return -EINVAL;
 		}
 		flags = new_flags;
+		vma->vm_page_prot = __pgprot(
+			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
+			flags);
 	}
 
 	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
