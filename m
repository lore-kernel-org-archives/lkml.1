Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0AHALl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0AHALl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343Ab0AHALk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:11:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55301 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0AHALk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:11:40 -0500
Date: Fri, 8 Jan 2010 11:11:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Sage Weil <sage@newdream.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: linux-next: nfs/ceph tree build failure
Message-Id: <20100108111136.3feae8c6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

fs/ceph/addr.c: In function 'ceph_set_page_dirty':
fs/ceph/addr.c:105: error: 'BDI_RECLAIMABLE' undeclared (first use in this function)

Commit 69f0302c4bd28846c3251e25976a2336cd6a6e6f ("VM: Split out the
accounting of unstable writes from BDI_RECLAIMABLE") from the nfs tree
interacts with commit 1d3576fd10f0d7a104204267b81cf84a07028dad ("ceph:
address space operations") from the ceph tree.

I applied the following patch for today (I am not sure it is correct) and
will keep it as a merge fixup as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 8 Jan 2010 11:04:27 +1100
Subject: [PATCH] ceph: update for BDI_RECLAIMABLE change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ceph/addr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index bf53581..eab46b0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -101,8 +101,7 @@ static int ceph_set_page_dirty(struct page *page)
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
+			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
-- 
1.6.5.7

