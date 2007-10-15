Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbXJOVut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbXJOVut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbXJOVtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:15 -0400
Received: from zrnetservice.com ([209.133.52.163]:33159 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756819AbXJOVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:08 -0400
Message-Id: <20071015210115.506967748@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>, David Chinner <dgc@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       XFS masters <xfs-masters@oss.sgi.com>,
       Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid upsetting Xen
Content-Disposition: inline; filename=xen-xfs-unmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

XFS leaves stray mappings around when it vmaps memory to make it
virtually contigious.  This upsets Xen if one of those pages is being
recycled into a pagetable, since it finds an extra writable mapping of
the page.

This patch solves the problem in a brute force way, by making XFS
always eagerly unmap its mappings.  David Chinner says this shouldn't
have any performance impact on filesystems with default block sizes;
it will only affect filesystems with large block sizes.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: XFS masters <xfs-masters@oss.sgi.com>
Cc: Stable kernel <stable@kernel.org>
Cc: Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>
Cc: Mark Williamson <mark.williamson@cl.cam.ac.uk>

---
 fs/xfs/linux-2.6/xfs_buf.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -186,6 +186,19 @@ free_address(
 	void		*addr)
 {
 	a_list_t	*aentry;
+
+#ifdef CONFIG_XEN
+	/*
+	 * Xen needs to be able to make sure it can get an exclusive
+	 * RO mapping of pages it wants to turn into a pagetable.  If
+	 * a newly allocated page is also still being vmap()ed by xfs,
+	 * it will cause pagetable construction to fail.  This is a
+	 * quick workaround to always eagerly unmap pages so that Xen
+	 * is happy.
+	 */
+	vunmap(addr);
+	return;
+#endif
 
 	aentry = kmalloc(sizeof(a_list_t), GFP_NOWAIT);
 	if (likely(aentry)) {

-- 

