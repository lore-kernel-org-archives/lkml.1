Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZIPWgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZIPWgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbZIPWgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:36:33 -0400
Received: from kroah.org ([198.145.64.141]:40976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbZIPWcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:04 2009
Message-Id: <20090916222903.948477177@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 19/24] x86, pat: Fix cacheflush address in change_page_attr_set_clr()
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=x86-pat-fix-cacheflush-address-in-change_page_attr_set_clr.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jack Steiner <steiner@sgi.com>

commit fa526d0d641b5365676a1fb821ce359e217c9b85 upstream.

Fix address passed to cpa_flush_range() when changing page
attributes from WB to UC. The address (*addr) is
modified by __change_page_attr_set_clr(). The result is that
the pages being flushed start at the _end_ of the changed range
instead of the beginning.

This should be considered for 2.6.30-stable and 2.6.31-stable.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -807,6 +807,7 @@ static int change_page_attr_set_clr(unsi
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
+	unsigned long baddr = 0;
 
 	/*
 	 * Check, if we are requested to change a not supported
@@ -838,6 +839,11 @@ static int change_page_attr_set_clr(unsi
 			 */
 			WARN_ON_ONCE(1);
 		}
+		/*
+		 * Save address for cache flush. *addr is modified in the call
+		 * to __change_page_attr_set_clr() below.
+		 */
+		baddr = *addr;
 	}
 
 	/* Must avoid aliasing mappings in the highmem code */
@@ -892,7 +898,7 @@ static int change_page_attr_set_clr(unsi
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
 		} else
-			cpa_flush_range(*addr, numpages, cache);
+			cpa_flush_range(baddr, numpages, cache);
 	} else
 		cpa_flush_all(cache);
 


