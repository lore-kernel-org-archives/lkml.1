Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0BDDKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:10:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:57469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab0BDDKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:10:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="537573619"
Date: Thu, 4 Feb 2010 10:43:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [stable] [PATCH] devmem: fix kmem write bug on memory holes
Message-ID: <20100204024353.GA13576@localhost>
References: <20100122045914.993668874@intel.com> <20100203234724.GA23902@kroah.com> <20100204024202.GD6343@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204024202.GD6343@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

commit c85e9a97c4102ce2e83112da850d838cfab5ab13 upstream.

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

--- linux-2.6.32.orig/drivers/char/mem.c	2010-02-04 10:37:55.000000000 +0800
+++ linux-2.6.32/drivers/char/mem.c	2010-02-04 10:37:59.000000000 +0800
@@ -599,7 +599,7 @@ static ssize_t write_kmem(struct file * 
 					break;
 				}
 			}
-			len = vwrite(kbuf, (char *)p, len);
+			vwrite(kbuf, (char *)p, len);
 			count -= len;
 			buf += len;
 			virtr += len;
