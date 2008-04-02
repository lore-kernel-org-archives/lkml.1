Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYDBVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYDBVxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760487AbYDBVqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:46:19 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33676
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763471AbYDBVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:46:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 8] XPMEM would have used sys_madvise() except that
	madvise_dontneed()
X-Mercurial-Node: 31fc23193bd039cc595fba1ca149a9715f7d0fb2
Message-Id: <31fc23193bd039cc595f.1207171808@duo.random>
In-Reply-To: <patchbomb.1207171801@duo.random>
Date: Wed, 02 Apr 2008 23:30:08 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: akpm@linux-foundation.org
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1207159059 -7200
# Node ID 31fc23193bd039cc595fba1ca149a9715f7d0fb2
# Parent  dd918e267ce1d054e8364a53adcecf3c7439cff4
XPMEM would have used sys_madvise() except that madvise_dontneed()
returns an -EINVAL if VM_PFNMAP is set, which is always true for the pages
XPMEM imports from other partitions and is also true for uncached pages
allocated locally via the mspec allocator.  XPMEM needs zap_page_range()
functionality for these types of pages as well as 'normal' pages.

Signed-off-by: Dean Nelson <dcn@sgi.com>

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -900,6 +900,7 @@
 
 	return unmap_vmas(vma, address, end, &nr_accounted, details);
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
