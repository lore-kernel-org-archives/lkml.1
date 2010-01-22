Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842Ab0AVFTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0AVFTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330Ab0AVFTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:19:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:27965 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0AVFTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:19:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="486056847"
Message-Id: <20100122051517.415742055@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 12:59:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, <stable@kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/4] devmem: fix kmem write bug on memory holes
References: <20100122045914.993668874@intel.com>
Content-Disposition: inline; filename=vwrite-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_kmem() used to assume vwrite() always return the full buffer length.
However now vwrite() could return 0 to indicate memory hole. This creates
a bug that "buf" is not advanced accordingly.

Fix it to simply ignore the return value, hence the memory hole.

CC: Andi Kleen <andi@firstfloor.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <stable@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-11 10:32:32.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-11 10:32:34.000000000 +0800
@@ -555,7 +555,7 @@ static ssize_t write_kmem(struct file * 
 				err = -EFAULT;
 				break;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
+			vwrite(kbuf, (char *)p, sz);
 			count -= sz;
 			buf += sz;
 			virtr += sz;


