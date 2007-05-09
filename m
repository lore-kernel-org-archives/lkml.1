Return-Path: <linux-kernel-owner+w=401wt.eu-S1033605AbXEIDOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033605AbXEIDOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031017AbXEIDNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:13:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59042 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030940AbXEIDND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:13:03 -0400
Date: Wed, 09 May 2007 12:12:32 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] memory hotremove patch take 2 [10/10] (retry swap-in page)
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070509120947.B91A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There is a race condition between swap-in and unmap_and_move().
When swap-in occur, page_mapped might be not set yet.
So, unmap_and_move() gives up at once, and tries later.



Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>


 mm/migrate.c |    5 +++++
 1 files changed, 5 insertions(+)

Index: current_test/mm/migrate.c
===================================================================
--- current_test.orig/mm/migrate.c	2007-05-08 15:08:09.000000000 +0900
+++ current_test/mm/migrate.c	2007-05-08 15:08:09.000000000 +0900
@@ -670,6 +670,11 @@ static int unmap_and_move(new_page_t get
 		/* hold this anon_vma until remove_migration_ptes() finishes */
 		anon_vma_hold(page);
 	}
+
+	if (PageSwapCache(page) && !page_mapped(page))
+		/* swap in now. try lator*/
+		goto unlock;
+
 	/*
 	 * Establish migration ptes or remove ptes
 	 */

-- 
Yasunori Goto 


