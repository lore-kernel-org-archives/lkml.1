Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXCMHN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXCMHN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXCMHN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:13:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56669 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170AbXCMHN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:13:26 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Message-Id: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
Subject: [QUICKLIST 0/4] Arch independent quicklists V2
Date: Tue, 13 Mar 2007 00:13:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2
- Add sparch64 patch
- Single i386 and x86_64 patch
- Update attribution
- Update justification
- Update approvals
- Earlier discussion of V1 was at
  http://marc.info/?l=linux-kernel&m=117357922219342&w=2

This patchset introduces an arch independent framework to handle lists
of recently used page table pages. It is necessary for x86_64 and
i386 to avoid the special casing of SLUB because these two platforms
use fields in the page_struct (page->index and page->private)
that SLUB needs (and in fact SLAB also needs page-private if
performing debugging!). There is also the tendency of arches to use
page flags to mark page table pages. The slab also uses page flags.
Separating page table page allocation into quicklists avoids the danger
of conflicts and frees up page flags for SLUB and for the arch code.

Page table pages have the characteristics that they are typically zero
or in a known state when they are freed. This is usually the exactly
same state as needed after allocation. So it makes sense to build a list
of freed page table pages and then consume the pages already in use
first. Those pages have already been initialized correctly (thus no
need to zero them) and are likely already cached in such a way that
the MMU can use them most effectively. Page table pages are used in
a sparse way so zeroing them on allocation is not too useful.

Such an implementation already exits for ia64. Howver, that implementation
did not support constructors and destructors as needed by i386 / x86_64.
It also only supported a single quicklist. The implementation here has
constructor and destructor support as well as the ability for an arch to
specify how many quicklists are needed.

Quicklists are defined by an arch defining the necessary number
of quicklists in arch/<arch>/Kconfig. F.e. i386 needs two and thus
has

config NR_QUICK
	int
	default 2

If an arch has requested quicklist support then pages can be allocated
from the quicklist (or from the page allocator if the quicklist is
empty) via:

quicklist_alloc(<quicklist-nr>, <gfpflags>, <constructor>)

Page table pages can be freed using:

quicklist_free(<quicklist-nr>, <destructor>, <page>)

Pages must have a definite state after allocation and before
they are freed. If no constructor is specified then pages
will be zeroed on allocation and must be zeroed before they are
freed.

If a constructor is used then the constructor will establish
a definite page state. F.e. the i386 and x86_64 pgd constructors
establish certain mappings.

Constructors and destructors can also be used to track the pages.
i386 and x86_64 use a list of pgds in order to be able to dynamically
update standard mappings.


