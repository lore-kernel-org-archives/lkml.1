Return-Path: <linux-kernel-owner+w=401wt.eu-S1763401AbXKMWvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763401AbXKMWvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbXKMWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:51:06 -0500
Received: from mx1.suse.de ([195.135.220.2]:33920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761668AbXKMWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:51:01 -0500
Subject: patch xen-xfs-unmap.patch queued to -stable tree
To: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org, chrisw@sous-sol.org,
       gregkh@suse.de, jeremy@xensource.com, keir@xensource.com,
       linux-kernel@vger.kernel.org, mark.williamson@cl.cam.ac.uk,
       stable@kernel.org, xen-users@morten.bogeskov.dk,
       xfs-masters@oss.sgi.com
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Tue, 13 Nov 2007 14:50:48 -0800
In-Reply-To: <20071012211148.864500000@goop.org>
Message-Id: <20071113225059.9B93E14544CD@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: xfs: eagerly remove vmap mappings to avoid upsetting Xen

to the 2.6.23-stable tree.  Its filename is

     xen-xfs-unmap.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Fri Oct 12 14:33:36 2007
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 12 Oct 2007 14:11:42 -0700
Subject: xfs: eagerly remove vmap mappings to avoid upsetting Xen
To: LKML <linux-kernel@vger.kernel.org>
Cc: xen-devel@lists.xensource.com, virtualization@lists.osdl.org, Mark Williamson <mark.williamson@cl.cam.ac.uk>, XFS masters <xfs-masters@oss.sgi.com>, Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>, Morten Bøgeskov <xen-users@morten.bogeskov.dk>, Andrew Morton <akpm@linux-foundation.org>, Keir Fraser <keir@xensource.com>, Stable kernel <stable@kernel.org>
Message-ID: <20071012211148.864500000@goop.org>
Content-Disposition: inline; filename=xen-xfs-unmap.patch

From: Jeremy Fitzhardinge <jeremy@goop.org>

patch ace2e92e193126711cb3a83a3752b2c5b8396950 in mainline.

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
Cc: Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>
Cc: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/xfs/linux-2.6/xfs_buf.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -187,6 +187,19 @@ free_address(
 {
 	a_list_t	*aentry;
 
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
+
 	aentry = kmalloc(sizeof(a_list_t), GFP_NOWAIT);
 	if (likely(aentry)) {
 		spin_lock(&as_lock);


Patches currently in stable-queue which might be from jeremy@goop.org are

queue-2.6.23/xen-handle-lazy-cr3-on-unpin.patch
queue-2.6.23/xen-multicall-callbacks.patch
queue-2.6.23/xen-fix-register_vcpu_info.patch
queue-2.6.23/xen-xfs-unmap.patch
