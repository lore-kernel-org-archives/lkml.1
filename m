Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbXGWIQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbXGWIQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbXGWIPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:15:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:32826 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754353AbXGWIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:15:37 -0400
Message-ID: <385178527.20132@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 23 Jul 2007 16:04:05 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
Message-ID: <20070723080405.GA7420@mail.ustc.edu.cn>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070721044300.909424569@mail.ustc.edu.cn> <384993020.08966@ustc.edu.cn> <46A45F8A.5060600@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A45F8A.5060600@yahoo.com.au>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 05:58:02PM +1000, Nick Piggin wrote:
> Fengguang Wu wrote:
> >Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
> >for the first hole. It will be used in interleaved readahead.
> >
> >The implementation is dumb and obviously correct.
> >It can help debug(and document) the possible smart one in future.
> 
> Reasonable function to want. Is radix_tree_scan_hole the best name?
> What about radix_tree_next_hole or _find_next_hole? (Andrew, any
> suggestions?)

Thank you!

All comments seems reasonable, so I simply attach the updated patch.

Fengguang
---
Subject: radixtree: introduce radix_tree_next_hole()
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

Introduce radix_tree_next_hole(root, index, max_scan) to scan radix tree
for the first hole. It will be used in interleaved readahead.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- linux-2.6.22-rc6-mm1.orig/include/linux/radix-tree.h
+++ linux-2.6.22-rc6-mm1/include/linux/radix-tree.h
@@ -155,6 +155,8 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
--- linux-2.6.22-rc6-mm1.orig/lib/radix-tree.c
+++ linux-2.6.22-rc6-mm1/lib/radix-tree.c
@@ -601,6 +601,42 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+/**
+ *	radix_tree_next_hole    -    find the next hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the lowest
+ *	indexed hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'return - index >= max_scan'
+ *	will be true).
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of the
+ *	tree at a single point in time. For example, if a hole is created at index
+ *	5, then subsequently a hole is created at index 10, radix_tree_next_hole
+ *	covering both indexes may return 10 if called under rcu_read_lock.
+ */
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index++;
+		if (index == 0)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_next_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)

