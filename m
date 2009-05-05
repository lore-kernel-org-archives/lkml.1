Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZEENlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZEENlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZEENlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:41:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbZEENlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:41:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49FF96A7.5040401@snapgear.com>
References: <49FF96A7.5040401@snapgear.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
Date: Tue, 05 May 2009 14:41:01 +0100
Message-ID: <3662.1241530861@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> BUG: failure at mm/nommu.c:518/add_nommu_region()!

Can you find out some more information about the region in question, perhaps
with the attached patch?

Also if you can check to see whether the region is within the ROMFS image.

David
---
diff --git a/mm/nommu.c b/mm/nommu.c
index cdc6f60..ba9e230 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -515,7 +515,18 @@ static void add_nommu_region(struct vm_region *region)
 
 	validate_nommu_regions();
 
-	BUG_ON(region->vm_start & ~PAGE_MASK);
+	if (region->vm_start & ~PAGE_MASK) {
+		printk(KERN_ERR "___ REGION ERROR ___\n");
+		printk(KERN_ERR "%lx-%lx\n", region->vm_start, region->vm_end);
+		printk(KERN_ERR "fs=%s file=%s\n",
+		       region->vm_file ?
+		       region->vm_file->f_path.dentry->d_inode->i_sb->s_type->name :
+		       "*anon*",
+		       region->vm_file ?
+		       region->vm_file->f_path.dentry->d_name.name :
+		       (const unsigned char *) "*anon*");
+		BUG();
+	}
 
 	parent = NULL;
 	p = &nommu_region_tree.rb_node;
