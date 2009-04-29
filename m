Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbZD2WYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbZD2WYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbZD2WVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:15 -0400
Received: from kroah.org ([198.145.64.141]:40258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193AbZD2WVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:24 2009
Message-Id: <20090429220924.051987610@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:08 -0700
From: Greg KH <gregkh@suse.de>
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
       Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/58] x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0033-x86-PAT-PCI-Change-vma-prot-in-pci_mmap-to-reflec.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/pci/i386.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -326,6 +326,9 @@ int pci_mmap_page_range(struct pci_dev *
 			return -EINVAL;
 		}
 		flags = new_flags;
+		vma->vm_page_prot = __pgprot(
+			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
+			flags);
 	}
 
 	if (((vma->vm_pgoff < max_low_pfn_mapped) ||


