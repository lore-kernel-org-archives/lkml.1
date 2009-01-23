Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZAWQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZAWQ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZAWQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:26:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31290 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZAWQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:26:29 -0500
X-IronPort-AV: E=Sophos;i="4.37,312,1231131600"; 
   d="scan'208";a="36938296"
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] xen: handle highmem pages correctly when shrinking a domain
X-Mercurial-Node: 70c0102ea4c18ecab426aa32e2dee29c76a8d827
Message-Id: <70c0102ea4c18ecab426.1232727981@localhost.localdomain>
Date: Fri, 23 Jan 2009 16:26:21 +0000
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
X-OriginalArrivalTime: 23 Jan 2009 16:26:27.0617 (UTC) FILETIME=[574F6110:01C97D77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit causes a crash if the page being released is a highmem
page.

  commit 1058a75f07b9bb8323fb5197be5526220f8b75cf
  Author: Dan Magenheimer <dan.magenheimer@oracle.com>
  Date:   Thu Jan 22 14:36:08 2009 -0800

    xen: actually release memory when shrinking domain

If a page is highmem then there is no need to unmap it.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: dan.magenheimer@oracle.com <dan.magenheimer@oracle.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Cc: Stable Kernel <stable@kernel.org>
---
 drivers/xen/balloon.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -r 7f26a03c3e02 -r 70c0102ea4c1 drivers/xen/balloon.c
--- a/drivers/xen/balloon.c	Fri Jan 23 14:14:59 2009 +0000
+++ b/drivers/xen/balloon.c	Fri Jan 23 16:24:09 2009 +0000
@@ -292,10 +292,13 @@
 
 		scrub_page(page);
 
-		ret = HYPERVISOR_update_va_mapping(
-			(unsigned long)__va(pfn << PAGE_SHIFT),
-			__pte_ma(0), 0);
-		BUG_ON(ret);
+		if (!PageHighMem(page)) {
+			ret = HYPERVISOR_update_va_mapping(
+				(unsigned long)__va(pfn << PAGE_SHIFT),
+				__pte_ma(0), 0);
+			BUG_ON(ret);
+                }
+
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */
