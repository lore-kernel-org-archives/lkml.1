Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZIND3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZIND3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZIND3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:29:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:59386 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZIND3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,381,1249282800"; 
   d="scan'208";a="187194566"
Date: Mon, 14 Sep 2009 11:29:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] devmem: handle partial kmem write/read
Message-ID: <20090914032901.GA16189@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current vwrite silently ignores vwrite() to vmap holes.
Better behavior should be stop the write and return
on such holes.

Also return on partial read, which may happen in future
(eg. hit hwpoison pages).

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-14 10:59:50.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-14 11:06:25.000000000 +0800
@@ -444,18 +444,22 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
+			unsigned long n;
+
 			sz = size_inside_page(p, count);
-			sz = vread(kbuf, (char *)p, sz);
-			if (!sz)
+			n = vread(kbuf, (char *)p, sz);
+			if (!n)
 				break;
-			if (copy_to_user(buf, kbuf, sz)) {
+			if (copy_to_user(buf, kbuf, n)) {
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			count -= sz;
-			buf += sz;
-			read += sz;
-			p += sz;
+			count -= n;
+			buf += n;
+			read += n;
+			p += n;
+			if (n < sz)
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -551,11 +555,13 @@ static ssize_t write_kmem(struct file * 
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
-			count -= sz;
-			buf += sz;
-			virtr += sz;
-			p += sz;
+			n = vwrite(kbuf, (char *)p, sz);
+			count -= n;
+			buf += n;
+			virtr += n;
+			p += n;
+			if (n < sz)
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
