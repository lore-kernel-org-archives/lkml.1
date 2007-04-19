Return-Path: <linux-kernel-owner+w=401wt.eu-S1766856AbXDSQfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766856AbXDSQfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766855AbXDSQfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51397 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766856AbXDSQfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:10 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163510.11948.12351.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 1/8] Add order field to address_space struct
Date: Thu, 19 Apr 2007 09:35:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Add order field in mapping

Add an "order" field in the address space structure that
specifies the page order of pages in an address space.

Set the field to zero by default so that filesystems not prepared to
deal with higher pages can be left as is.

Putting page order in the address space structure means that the order of the
pages in the page cache can be varied per file that a filesystem creates.
This means we can keep small 4k pages for small files. Larger files can
be configured by the file system to use a higher order.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/inode.c         |    1 +
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.21-rc7/fs/inode.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/inode.c	2007-04-18 21:21:56.000000000 -0700
+++ linux-2.6.21-rc7/fs/inode.c	2007-04-18 21:26:31.000000000 -0700
@@ -145,6 +145,7 @@ static struct inode *alloc_inode(struct 
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
+		mapping->order = 0;
 		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
Index: linux-2.6.21-rc7/include/linux/fs.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/fs.h	2007-04-18 21:21:56.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/fs.h	2007-04-18 21:26:31.000000000 -0700
@@ -435,6 +435,7 @@ struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
 	rwlock_t		tree_lock;	/* and rwlock protecting it */
+	unsigned int		order;		/* Page order in this space */
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
