Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbXJLVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbXJLVrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbXJLVom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:42 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42271 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760415AbXJLVoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:39 -0400
Message-Id: <20071012211148.864500000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       XFS masters <xfs-masters@oss.sgi.com>,
       Stable kernel <stable@kernel.org>,
       Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: [PATCH 10/10] xfs: eagerly remove vmap mappings to avoid upsetting Xen
Content-Disposition: inline; filename=xen-xfs-unmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

XFS leaves stray mappings around when it vmaps memory to make it
virtually contigious.  This upsets Xen if one of those pages is being
recycled into a pagetable, since it finds an extra writable mapping of
the page.

This patch solves the problem in a brute force way, by making XFS
always eagerly unmap its mappings.

[ Stable: This works around a bug in 2.6.23.  We may come up with a
better solution for mainline, but this seems like a low-impact fix for
the stable kernel. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
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

