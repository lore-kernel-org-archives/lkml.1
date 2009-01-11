Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZAKCEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZAKCEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZAKCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:04:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:46354 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZAKCEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xWJFv/lGtvo44bfp4KbHU9+MufOkVI9paUACVoa8mpXKMV0fQrHXLGF1eT0SkGE8nT
         j3V/oF0mPfCCTaxokSftUnPQU4JhTe8+mCrVveULcp0LSyNNP+305qSM+ZfuNapJtWTZ
         y8b6vnrWrEu2jKEuPyiQ5J2r0wWNXt9nbzr/8=
Date: Sun, 11 Jan 2009 11:03:53 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Josef Bacik <jbacik@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, adilger@sun.com,
       linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Message-ID: <20090111020352.GA4285@localhost.localdomain>
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ext4_mb_free_blocks() ext4_free_data allocation failure
is not handled. This error handling cannot be simple error return because
ext4_mb_free_blocks() cannot fail.

This patch add __GFP_NOFAIL to gfp mask for the allocation.

Cc: Theodore Tso <tytso@mit.edu>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6-git/fs/ext4/mballoc.c
===================================================================
--- 2.6-git.orig/fs/ext4/mballoc.c
+++ 2.6-git/fs/ext4/mballoc.c
@@ -4885,7 +4885,8 @@ do_more:
 		 * blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed
 		 */
-		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep,
+						GFP_NOFS | __GFP_NOFAIL);
 		new_entry->start_blk = bit;
 		new_entry->group  = block_group;
 		new_entry->count = count;
