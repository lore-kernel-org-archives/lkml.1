Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZHCMLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZHCMLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZHCMLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:11:10 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:33105 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbZHCMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:11:09 -0400
X-Trace: 240112703/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAHZwdkpPRT9D/2dsb2JhbACBUs4hhBgFgUo
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="240112703"
Date: Mon, 3 Aug 2009 13:11:00 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 2/12] ksm: move pages_sharing updates
In-Reply-To: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908031310060.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pages_shared count is incremented and decremented when adding a node
to and removing a node from the stable tree: easy to understand.  But the
pages_sharing count was hard to follow, being adjusted in various places:
increment and decrement it when adding to and removing from the stable tree.

And the pages_sharing variable used to include the pages_shared, then those
were subtracted when shown in the pages_sharing sysfs file: now keep it as
an exclusive count of leaves hanging off the stable tree nodes, throughout.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- ksm1/mm/ksm.c	2009-08-02 13:49:36.000000000 +0100
+++ ksm2/mm/ksm.c	2009-08-02 13:49:43.000000000 +0100
@@ -152,7 +152,7 @@ static struct kmem_cache *mm_slot_cache;
 /* The number of nodes in the stable tree */
 static unsigned long ksm_pages_shared;
 
-/* The number of page slots sharing those nodes */
+/* The number of page slots additionally sharing those nodes */
 static unsigned long ksm_pages_sharing;
 
 /* Limit on the number of unswappable pages used */
@@ -382,6 +382,7 @@ static void remove_rmap_item_from_tree(s
 						&next_item->node,
 						&root_stable_tree);
 				next_item->address |= NODE_FLAG;
+				ksm_pages_sharing--;
 			} else {
 				rb_erase(&rmap_item->node, &root_stable_tree);
 				ksm_pages_shared--;
@@ -395,10 +396,10 @@ static void remove_rmap_item_from_tree(s
 				BUG_ON(next_item->prev != rmap_item);
 				next_item->prev = rmap_item->prev;
 			}
+			ksm_pages_sharing--;
 		}
 
 		rmap_item->next = NULL;
-		ksm_pages_sharing--;
 
 	} else if (rmap_item->address & NODE_FLAG) {
 		unsigned char age;
@@ -786,8 +787,6 @@ static int try_to_merge_two_pages(struct
 		 */
 		if (err)
 			break_cow(mm1, addr1);
-		else
-			ksm_pages_sharing += 2;
 	}
 
 	put_page(kpage);
@@ -816,9 +815,6 @@ static int try_to_merge_with_ksm_page(st
 	err = try_to_merge_one_page(vma, page1, kpage);
 	up_read(&mm1->mmap_sem);
 
-	if (!err)
-		ksm_pages_sharing++;
-
 	return err;
 }
 
@@ -935,13 +931,12 @@ static struct rmap_item *stable_tree_ins
 		}
 	}
 
-	ksm_pages_shared++;
-
 	rmap_item->address |= NODE_FLAG | STABLE_FLAG;
 	rmap_item->next = NULL;
 	rb_link_node(&rmap_item->node, parent, new);
 	rb_insert_color(&rmap_item->node, &root_stable_tree);
 
+	ksm_pages_shared++;
 	return rmap_item;
 }
 
@@ -1026,6 +1021,8 @@ static void stable_tree_append(struct rm
 
 	tree_rmap_item->next = rmap_item;
 	rmap_item->address |= STABLE_FLAG;
+
+	ksm_pages_sharing++;
 }
 
 /*
@@ -1050,10 +1047,9 @@ static void cmp_and_merge_page(struct pa
 	/* We first start with searching the page inside the stable tree */
 	tree_rmap_item = stable_tree_search(page, page2, rmap_item);
 	if (tree_rmap_item) {
-		if (page == page2[0]) {			/* forked */
-			ksm_pages_sharing++;
+		if (page == page2[0])			/* forked */
 			err = 0;
-		} else
+		else
 			err = try_to_merge_with_ksm_page(rmap_item->mm,
 							 rmap_item->address,
 							 page, page2[0]);
@@ -1114,7 +1110,6 @@ static void cmp_and_merge_page(struct pa
 				break_cow(tree_rmap_item->mm,
 						tree_rmap_item->address);
 				break_cow(rmap_item->mm, rmap_item->address);
-				ksm_pages_sharing -= 2;
 			}
 		}
 
@@ -1482,8 +1477,7 @@ KSM_ATTR_RO(pages_shared);
 static ssize_t pages_sharing_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n",
-			ksm_pages_sharing - ksm_pages_shared);
+	return sprintf(buf, "%lu\n", ksm_pages_sharing);
 }
 KSM_ATTR_RO(pages_sharing);
 
