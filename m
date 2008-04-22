Return-Path: <linux-kernel-owner+w=401wt.eu-S934404AbYDVOPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934404AbYDVOPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763909AbYDVOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:10:45 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41298
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763601AbYDVOKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:10:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 12] XPMEM would have used sys_madvise() except that
	madvise_dontneed()
X-Mercurial-Node: 128d705f38c8a774ac11559db445787ce6e91c77
Message-Id: <128d705f38c8a774ac11.1208872287@duo.random>
In-Reply-To: <patchbomb.1208872276@duo.random>
Date: Tue, 22 Apr 2008 15:51:27 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1208872187 -7200
# Node ID 128d705f38c8a774ac11559db445787ce6e91c77
# Parent  f8210c45f1c6f8b38d15e5dfebbc5f7c1f890c93
XPMEM would have used sys_madvise() except that madvise_dontneed()
returns an -EINVAL if VM_PFNMAP is set, which is always true for the pages
XPMEM imports from other partitions and is also true for uncached pages
allocated locally via the mspec allocator.  XPMEM needs zap_page_range()
functionality for these types of pages as well as 'normal' pages.

Signed-off-by: Dean Nelson <dcn@sgi.com>

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -909,6 +909,7 @@
 
 	return unmap_vmas(vma, address, end, &nr_accounted, details);
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
