Return-Path: <linux-kernel-owner+w=401wt.eu-S937685AbZDJGTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937685AbZDJGTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934845AbZDJGQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:28520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935677AbZDJGQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013479"
Message-Id: <20090410061254.879539853@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 8/9] readahead: enforce full readahead size on async mmap readahead
Content-Disposition: inline; filename=readahead-mmap-full-async-readahead-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this in one perticular case and two more general ones.

Now we do async readahead for sequential mmap reads, and do it with the help of
PG_readahead. For normal reads, PG_readahead is the sufficient condition to do
a sequential readahead. But unfortunately, for mmap reads, there is a tiny nuisance:

[11736.998347] readahead-init0(process: sh/23926, file: sda1/w3m, offset=0:4503599627370495, ra=0+4-3) = 4
[11737.014985] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=290+32-0) = 17
[11737.019488] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=118+32-0) = 32
[11737.024921] readahead-interleaved(process: w3m/23926, file: sda1/w3m, offset=0:2, ra=4+6-6) = 6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                                 ~~~~~~~~~~~~~
An unfavorably small readahead. The original dumb read-around size could be more efficient.

That happened because ld-linux.so does a read(832) in L1 before mmap(),
which triggers a 4-page readahead, with the second page tagged PG_readahead.

L0: open("/lib/libc.so.6", O_RDONLY)        = 3
L1: read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\342"..., 832) = 832
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
L2: fstat(3, {st_mode=S_IFREG|0755, st_size=1420624, ...}) = 0
L3: mmap(NULL, 3527256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fac6e51d000
L4: mprotect(0x7fac6e671000, 2097152, PROT_NONE) = 0
L5: mmap(0x7fac6e871000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x154000) = 0x7fac6e871000
L6: mmap(0x7fac6e876000, 16984, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fac6e876000
L7: close(3)                                = 0

In general, the PG_readahead flag will also be hit in cases
- sequential reads
- clustered random reads
A full readahead size is desirable in both cases.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1515,7 +1515,8 @@ static void do_async_mmap_readahead(stru
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
 	if (PageReadahead(page))
-		page_cache_async_readahead(mapping, ra, file, page, offset, 1);
+		page_cache_async_readahead(mapping, ra, file,
+					   page, offset, ra->ra_pages);
 }
 
 /**

-- 

