Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZICR4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZICR4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZICR4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:56:03 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54825 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753291AbZICR4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:56:02 -0400
Date: Thu, 3 Sep 2009 12:56:02 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Fix cacheflush address in change_page_attr_set_clr()
Message-ID: <20090903175602.GA19952@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix address passed to cpa_flush_range() when changing page
attributes from WB to UC. The address (*addr) is
modified by __change_page_attr_set_clr(). The result is that
the pages being flushed start at the _end_ of the changed range
instead of the beginning.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/mm/pageattr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c	2009-08-31 13:34:18.000000000 -0500
+++ linux/arch/x86/mm/pageattr.c	2009-09-03 12:48:50.000000000 -0500
@@ -822,6 +822,7 @@ static int change_page_attr_set_clr(unsi
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
+	unsigned long baddr = 0;
 
 	/*
 	 * Check, if we are requested to change a not supported
@@ -853,6 +854,11 @@ static int change_page_attr_set_clr(unsi
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
@@ -900,7 +906,7 @@ static int change_page_attr_set_clr(unsi
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
 		} else
-			cpa_flush_range(*addr, numpages, cache);
+			cpa_flush_range(baddr, numpages, cache);
 	} else
 		cpa_flush_all(cache);
 
