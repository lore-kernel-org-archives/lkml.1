Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbZDLHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbZDLHYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 03:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbZDLHWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 03:22:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:31531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbZDLHWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 03:22:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,174,1239001200"; 
   d="scan'208";a="130525075"
Date: Sun, 12 Apr 2009 15:09:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "yinghan@google.com" <yinghan@google.com>
Subject: [PATCH] readahead: enforce full sync mmap readahead size
Message-ID: <20090412070943.GB5737@localhost>
References: <20090410060957.442203404@intel.com> <20090410061254.719205499@intel.com> <20090410163413.a014bde0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410163413.a014bde0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we do readahead for sequential mmap reads, here is
a simple evaluation of the impacts, and one further optimization.

It's an NFS-root debian desktop system, readahead size = 60 pages.
The numbers are grabbed after a fresh boot into console.

approach        pgmajfault      RA miss ratio   mmap IO count   avg IO size(pages)
   A            383             31.6%           383             11
   B            225             32.4%           390             11
   C            224             32.6%           307             13

case A: mmap sync/async readahead disabled
case B: mmap sync/async readahead enabled, with enforced full async readahead size
case C: mmap sync/async readahead enabled, with enforced full sync/async readahead size
or:
A = vanilla 2.6.30-rc1
B = A plus mmap readahead
C = B plus this patch

The numbers show that
- there are good possibilities for random mmap reads to trigger readahead
- 'pgmajfault' is reduced by 1/3, due to the _async_ nature of readahead
- case C can further reduce IO count by 1/4
- readahead miss ratios are not quite affected

The theory is
- readahead is _good_ for clustered random reads, and can perform
  _better_ than readaround because they could be _async_.
- async readahead size is guaranteed to be larger than readaround
  size, and they are _async_, hence will mostly behave better
However for B
- sync readahead size could be smaller than readaround size, hence may
  make things worse by produce more smaller IOs
which will be fixed by this patch.

Final conclusion:
- mmap readahead reduced major faults by 1/3 and no obvious overheads;
- mmap io can be further reduced by 1/4 with this patch.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
 		ra->flags |= RA_FLAG_MMAP;
-		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		page_cache_sync_readahead(mapping, ra, file, offset,
+					  ra->ra_pages);
 		return;
 	}
 
