Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXKWFy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXKWFy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 00:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXKWFyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 00:54:49 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:5161 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXKWFys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 00:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bwDO1GQuf4eM8Zy/cFQFciK9iKlWRKsY8ipaHu8qDtPJfvZkkkK50WcoIMiLcMO1E0ktuXjoeWopqBnvVWK56zHFlk7eH+N0tyXpvN/VbsFgulxoUliKqpI6xTbQacM9UwPOUo4GNfAw97TLyxslhFkbrnYa0zfB+WmgV4GwUwA=
Date: Fri, 23 Nov 2007 13:51:50 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
Subject: [Patch] mm/sparse.c: Improve the error handling for
	sparse_add_one_section()
Message-ID: <20071123055150.GA2488@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071115135428.GE2489@hacking> <1195507022.27759.146.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195507022.27759.146.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Improve the error handling for mm/sparse.c::sparse_add_one_section().
And I see no reason to check 'usemap' until holding the
'pgdat_resize_lock'. If someone knows, please let me know.

Note! This patch is _not_ tested yet, since it seems that I can't
configure sparse memory for i386 box. Sorry for this. ;(
I hope someone can help me to test it.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 mm/sparse.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -391,9 +391,17 @@ int sparse_add_one_section(struct zone *
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	sparse_index_init(section_nr, pgdat->node_id);
+	ret = sparse_index_init(section_nr, pgdat->node_id);
+	if (ret < 0)
+		return ret;
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	if (!memmap)
+		return -ENOMEM;
 	usemap = __kmalloc_section_usemap();
+	if (!usemap) {
+		__kfree_section_memmap(memmap, nr_pages);
+		return -ENOMEM;
+	}
 
 	pgdat_resize_lock(pgdat, &flags);
 
@@ -403,18 +411,13 @@ int sparse_add_one_section(struct zone *
 		goto out;
 	}
 
-	if (!usemap) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
-	if (ret <= 0)
-		__kfree_section_memmap(memmap, nr_pages);
+
 	return ret;
 }
 #endif
