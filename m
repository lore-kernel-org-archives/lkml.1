Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXCZKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXCZKDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXCZKDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:03:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:54277 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXCZKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:03:31 -0400
Date: Mon, 26 Mar 2007 11:03:29 +0100
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Do not disable interrupts when reading min_free_kbytes
Message-ID: <20070326100329.GA19429@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sysctl handler for min_free_kbytes calls setup_per_zone_pages_min()
on read or write. This function iterates through every zone and calls
spin_lock_irqsave() on the zone LRU lock. When reading min_free_kbytes, this
is a total waste of time that disables interrupts on the local processor. It
might even be noticable machines with large numbers of zones if a process
started constantly reading min_free_kbytes.

This patch only calls setup_per_zone_pages_min() only on write. Tested on
an x86 laptop and it did the right thing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc4-mm1-norsdl/mm/page_alloc.c linux-2.6.21-rc4-mm1-nodisable_on_read_minfree/mm/page_alloc.c
--- linux-2.6.21-rc4-mm1-norsdl/mm/page_alloc.c	2007-03-26 09:56:32.000000000 +0100
+++ linux-2.6.21-rc4-mm1-nodisable_on_read_minfree/mm/page_alloc.c	2007-03-26 10:39:46.000000000 +0100
@@ -3956,7 +3956,8 @@ int min_free_kbytes_sysctl_handler(ctl_t
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
-	setup_per_zone_pages_min();
+	if (write)
+		setup_per_zone_pages_min();
 	return 0;
 }
 
