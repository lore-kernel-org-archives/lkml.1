Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbZEBWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbZEBWUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbZEBWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:19:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761464AbZEBWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:19:13 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au,
       Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Date: Sun,  3 May 2009 01:16:09 +0300
Message-Id: <1241302572-4366-4-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241302572-4366-3-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
 <1241302572-4366-2-git-send-email-ieidus@redhat.com>
 <1241302572-4366-3-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change the KSM_REMOVE_MEMORY_REGION ioctl to be specific per
memory region (instead of flushing all the registred memory regions inside
the file descriptor like it happen now)

The previoes api was:
user register memory regions using KSM_REGISTER_MEMORY_REGION inside the fd,
and then when he wanted to remove just one memory region, he had to remove them
all using KSM_REMOVE_MEMORY_REGION.

This patch change this beahivor by chaning the KSM_REMOVE_MEMORY_REGION
ioctl to recive another paramter that it is the begining of the virtual
address that is wanted to be removed.

(user can still remove all the memory regions all at once, by just closing
the file descriptor)

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 982dfff..c14019f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -561,17 +561,20 @@ static void remove_mm_from_hash_and_tree(struct mm_struct *mm)
 	list_del(&slot->link);
 }
 
-static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
+static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma,
+					      unsigned long addr)
 {
 	struct ksm_mem_slot *slot, *node;
 
 	down_write(&slots_lock);
 	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
-		remove_mm_from_hash_and_tree(slot->mm);
-		mmput(slot->mm);
-		list_del(&slot->sma_link);
-		kfree(slot);
-		ksm_sma->nregions--;
+		if (addr == slot->addr) {
+			remove_mm_from_hash_and_tree(slot->mm);
+			mmput(slot->mm);
+			list_del(&slot->sma_link);
+			kfree(slot);
+			ksm_sma->nregions--;
+		}
 	}
 	up_write(&slots_lock);
 	return 0;
@@ -579,12 +582,20 @@ static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
 
 static int ksm_sma_release(struct inode *inode, struct file *filp)
 {
+	struct ksm_mem_slot *slot, *node;
 	struct ksm_sma *ksm_sma = filp->private_data;
-	int r;
 
-	r = ksm_sma_ioctl_remove_memory_region(ksm_sma);
+	down_write(&slots_lock);
+	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
+		remove_mm_from_hash_and_tree(slot->mm);
+		mmput(slot->mm);
+		list_del(&slot->sma_link);
+		kfree(slot);
+	}
+	up_write(&slots_lock);
+
 	kfree(ksm_sma);
-	return r;
+	return 0;
 }
 
 static long ksm_sma_ioctl(struct file *filp,
@@ -607,7 +618,7 @@ static long ksm_sma_ioctl(struct file *filp,
 		break;
 	}
 	case KSM_REMOVE_MEMORY_REGION:
-		r = ksm_sma_ioctl_remove_memory_region(sma);
+		r = ksm_sma_ioctl_remove_memory_region(sma, arg);
 		break;
 	}
 
-- 
1.5.6.5

