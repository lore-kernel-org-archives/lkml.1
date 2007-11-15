Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbXKOGVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbXKOGVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbXKOGQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762673AbXKOGQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:42 -0500
Date: Wed, 14 Nov 2007 22:15:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       XFS masters <xfs-masters@oss.sgi.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Morten B?geskov <xen-users@morten.bogeskov.dk>,
       Keir Fraser <keir@xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [patch 14/19] xfs: eagerly remove vmap mappings to avoid upsetting
	Xen
Message-ID: <20071115061506.GO7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-xfs-unmap.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
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

-- 
