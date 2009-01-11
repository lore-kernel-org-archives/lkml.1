Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZAKOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZAKOlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZAKOlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:41:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZAKOlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:41:07 -0500
Date: Sun, 11 Jan 2009 09:39:42 -0500
From: Josef Bacik <jbacik@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       adilger@sun.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Message-ID: <20090111143942.GA28488@unused.rdu.redhat.com>
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com> <20090111020352.GA4285@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111020352.GA4285@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 11:03:53AM +0900, Akinobu Mita wrote:
> In ext4_mb_free_blocks() ext4_free_data allocation failure
> is not handled. This error handling cannot be simple error return because
> ext4_mb_free_blocks() cannot fail.
> 
> This patch add __GFP_NOFAIL to gfp mask for the allocation.
> 
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: adilger@sun.com
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Sorry but thats still not right, the fs should never force the box to come up
with memory, it should be able to gracefully handle ENOMEM cases.  This patch
does this properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 918aec0..e97ea09 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4886,6 +4886,10 @@ do_more:
 		 * be used until this transaction is committed
 		 */
 		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+		if (!new_entry) {
+			err = -ENOMEM;
+			goto error_return;
+		}
 		new_entry->start_blk = bit;
 		new_entry->group  = block_group;
 		new_entry->count = count;
