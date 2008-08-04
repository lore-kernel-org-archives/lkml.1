Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYHDNjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYHDNjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYHDNjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:39:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYHDNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:39:05 -0400
Message-ID: <489705E6.70103@linux-foundation.org>
Date: Mon, 04 Aug 2008 08:36:38 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
References: <20080801182324.572058187@lameter.com> <20080801182347.427403976@lameter.com> <20080803014218.GA6119@disturbed>
In-Reply-To: <20080803014218.GA6119@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:

> I think that hunk is mis-applied. You're configuring the
> xfs_vnode_zone defrag after allocating the xfs_ioend_zone. This
> should be afew lines higher up, right?

That would be nicer but its not a bug to have the setup where it is right now.

Fix:


Subject: defrag/xfs: Move defrag setup directly after xfs_vnode_zone kmem
cache creation

Move the setup of the defrag directly after the creation of the xfs_vnode_zone

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-04 08:27:09.000000000
-0500
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2008-08-04 08:27:25.000000000 -0500
@@ -2021,11 +2021,11 @@
 	if (!xfs_vnode_zone)
 		goto out;

+	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
+
 	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
 	if (!xfs_ioend_zone)
 		goto out_destroy_vnode_zone;
-	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
-
 	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
 						  xfs_ioend_zone);
 	if (!xfs_ioend_pool)
