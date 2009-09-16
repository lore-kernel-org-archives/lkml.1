Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZIPBv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZIPBv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZIPBvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:51:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:51194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZIPBvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188088268"
Message-Id: <20090916014958.836124324@intel.com>
References: <20090916013939.656308742@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 09:39:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 2/3] devmem: check vmalloc address on kmem read/write
Content-Disposition: inline; filename=vmalloc-addr-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Otherwise vmalloc_to_page() will BUG().

This also makes the kmem read/write implementation aligned with mem(4):
"References to nonexistent locations cause errors to be returned." Here
we return -ENXIO (inspired by Hugh) if no bytes have been transfered
to/from user space, otherwise return partial read/write results.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-mm.orig/drivers/char/mem.c	2009-09-16 08:52:17.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-16 09:15:03.000000000 +0800
@@ -443,6 +443,10 @@ static ssize_t read_kmem(struct file *fi
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			err = vread(kbuf, (char *)p, sz);
 			if (err)
 				break;
@@ -543,6 +547,10 @@ static ssize_t write_kmem(struct file * 
 			unsigned long sz = size_inside_page(p, count);
 			unsigned long n;
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			n = copy_from_user(kbuf, buf, sz);
 			if (n) {
 				err = -EFAULT;

-- 

