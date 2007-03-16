Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXCPIzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXCPIzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXCPIvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:09 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34606 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932436AbXCPIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:05 -0400
Message-ID: <374035059.59656@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.111038000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:00 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] readahead: thrashing recovery method: check unbalanced aging
Content-Disposition: inline; filename=readahead-thrashing-recovery-method-check-unbalanced-aging.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Always check for unbalanced aging in thrashing_recovery_readahead(), and
account RA_EVENT_READAHEAD_MUTILATE/RA_EVENT_READAHEAD_THRASHING events.

Unbalanced zone/node aging can come from abnormal system loads, or
misconfigured NUMA policies.

Thrashings are rare events, hence the cost of probe_page() is not a concern.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1546,14 +1546,11 @@ thrashing_recovery_readahead(struct addr
 				pgoff_t offset, unsigned long ra_max)
 {
 	unsigned long ra_size;
+	int unbalanced_aging = probe_page(mapping, offset - 1);
 
-#ifdef CONFIG_DEBUG_READAHEAD
-	if (probe_page(mapping, offset - 1))
-		ra_account(ra, RA_EVENT_READAHEAD_MUTILATE,
-						ra->readahead_index - offset);
-	ra_account(ra, RA_EVENT_READAHEAD_THRASHING,
-						ra->readahead_index - offset);
-#endif
+	ra_account(ra, unbalanced_aging ? RA_EVENT_READAHEAD_MUTILATE :
+					  RA_EVENT_READAHEAD_THRASHING,
+					  ra->readahead_index - offset);
 
 	if (offset < ra->ra_index) {
 		/*

--
