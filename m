Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbXCPIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbXCPIyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbXCPIyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:54:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34596 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932348AbXCPIxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:53:49 -0400
Message-ID: <374035059.29167@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085051.939153000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:48:59 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] readahead: state based method: cancel lookahead gracefully
Content-Disposition: inline; filename=readahead-state-based-method-cancel-lookahead-gracefully.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When canceling lookahead, update ra->lookahead_index to the next invoke index.
So that we see a consistent state in the next time.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1094,7 +1094,7 @@ state_based_readahead(struct address_spa
 
 	if (page && remain_space <= la_size) {
 		rescue_pages(page, la_size);
-		return 0;
+		goto cancel_lookahead;
 	}
 
 	growth_limit = req_size;
@@ -1104,7 +1104,7 @@ state_based_readahead(struct address_spa
 	    growth_limit = ra_max;
 
 	if (!adjust_rala(growth_limit, &ra_size, &la_size))
-		return 0;
+		goto cancel_lookahead;
 
 	limit_rala(growth_limit, la_old, &ra_size, &la_size);
 
@@ -1113,6 +1113,10 @@ state_based_readahead(struct address_spa
 	ra_set_size(ra, ra_size, la_size);
 
 	return ra_submit(ra, mapping, filp);
+
+cancel_lookahead:
+	ra->lookahead_index = ra->readahead_index;
+	return 0;
 }
 
 #endif /* CONFIG_ADAPTIVE_READAHEAD */

--
