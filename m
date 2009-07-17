Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZGQUUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZGQUUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZGQUUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:20:01 -0400
Received: from kroah.org ([198.145.64.141]:43137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZGQUTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:37 2009
Message-Id: <20090717201237.072896951@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>,
       mark gross <mgross@linux.intel.com>
Subject: [patch 21/24] Fix iommu address space allocation
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=fix-iommu-address-space-allocation.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit a15a519ed6e5e644f5a33c213c00b0c1d3cfe683 upstream.

This fixes kernel.org bug #13584. The IOVA code attempted to optimise
the insertion of new ranges into the rbtree, with the unfortunate result
that some ranges just didn't get inserted into the tree at all. Then
those ranges would be handed out more than once, and things kind of go
downhill from there.

Introduced after 2.6.25 by ddf02886cbe665d67ca750750196ea5bf524b10b
("PCI: iova RB tree setup tweak").

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: mark gross <mgross@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/iova.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -1,9 +1,19 @@
 /*
- * Copyright (c) 2006, Intel Corporation.
+ * Copyright © 2006-2009, Intel Corporation.
  *
- * This file is released under the GPLv2.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
- * Copyright (C) 2006-2008 Intel Corporation
  * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
@@ -123,7 +133,15 @@ move_left:
 	/* Insert the new_iova into domain rbtree by holding writer lock */
 	/* Add new node and rebalance tree. */
 	{
-		struct rb_node **entry = &((prev)), *parent = NULL;
+		struct rb_node **entry, *parent = NULL;
+
+		/* If we have 'prev', it's a valid place to start the
+		   insertion. Otherwise, start from the root. */
+		if (prev)
+			entry = &prev;
+		else
+			entry = &iovad->rbroot.rb_node;
+
 		/* Figure out where to put new node */
 		while (*entry) {
 			struct iova *this = container_of(*entry,


