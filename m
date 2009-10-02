Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZJBDfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZJBDfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 23:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZJBDfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 23:35:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60509 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZJBDfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 23:35:08 -0400
Date: Fri, 2 Oct 2009 05:35:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, stable@kernel.org
Subject: [PATCH] x86: Use ioremap_cache() for crash dump copies
Message-ID: <20091002033508.GA8436@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During code review I noticed that when reading the previous kernel
memory from a kdump kernel ioremap() is used. This was ok before
the PAT changes, but with PAT ioremap() this results in an uncached
mapping, which is very slow.

Change it to ioremap_cache(). This is fine because this code
only reads real memory, no IO mappings.

I haven't run numbers, but I suspect this will speed up crash dumping
somewhat.

Only affects 64bit, 32bit uses a different method.

Might be a stable candidate.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/crash_dump_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 045b36c..bf43188 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
-- 
1.6.0.2


-- 
ak@linux.intel.com -- Speaking for myself only.
