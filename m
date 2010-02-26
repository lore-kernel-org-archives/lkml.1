Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629Ab0BZRnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:43:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:32919 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965516Ab0BZRnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:43:21 -0500
Message-Id: <20100226174319.537341172@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 26 Feb 2010 11:42:57 -0600
From: Robin Holt <holt@sgi.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 1/1] Replace the memtype_lock spinlock with an rwlock.
References: <20100226174256.003433508@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=memtype_rwlock_V1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing an application using the xpmem (out of kernel driver), we
noticed a significant page fault rate reduction of x86_64 with respect
to ia64.  For one test running with 256 cpus, one thread per cpu, it
took one minute, eight seconds for each of the threads to vm_insert_pfn
2GB worth of pages.

The slowdown was tracked to lookup_memtype which acquires the spinlock
memtype_lock.  This heavily contended lock was slowing down fault time.

I quickly converted the spinlock to an rwlock.  This greatly improved
vm_insert_pfn time to 4.3 seconds for the above test.

To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>

---

As a theoretical test, I removed the lock around get_page_memtype to see
what the full impact of the single shared lock actually was.  With that
change, the vm_insert_pfn time dropped to 1.6 seconds.

I do not think the current global lock to protect individual pages is
the "correct" method for protecting get/set of the page_memtype flag.
It seems like the locking should be located within the function that
gets and sets the flags and be locked by a per-page lock or protected
with an atomic update.


 arch/x86/mm/pat.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: memtype_lock_rwlock_V1/arch/x86/mm/pat.c
===================================================================
--- memtype_lock_rwlock_V1.orig/arch/x86/mm/pat.c	2010-02-26 11:29:57.080735767 -0600
+++ memtype_lock_rwlock_V1/arch/x86/mm/pat.c	2010-02-26 11:30:04.165749791 -0600
@@ -169,7 +169,7 @@ struct memtype {
 
 static struct rb_root memtype_rbroot = RB_ROOT;
 static LIST_HEAD(memtype_list);
-static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
+static DEFINE_RWLOCK(memtype_lock);	/* protects memtype list */
 
 static struct memtype *memtype_rb_search(struct rb_root *root, u64 start)
 {
@@ -404,9 +404,9 @@ int reserve_memtype(u64 start, u64 end, 
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
+		write_lock(&memtype_lock);
 		err = reserve_ram_pages_type(start, end, req_type, new_type);
-		spin_unlock(&memtype_lock);
+		write_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
@@ -421,7 +421,7 @@ int reserve_memtype(u64 start, u64 end, 
 	new->end	= end;
 	new->type	= actual_type;
 
-	spin_lock(&memtype_lock);
+	write_lock(&memtype_lock);
 
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
@@ -464,7 +464,7 @@ int reserve_memtype(u64 start, u64 end, 
 		       "track %s, req %s\n",
 		       start, end, cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
-		spin_unlock(&memtype_lock);
+		write_unlock(&memtype_lock);
 
 		return err;
 	}
@@ -476,7 +476,7 @@ int reserve_memtype(u64 start, u64 end, 
 
 	memtype_rb_insert(&memtype_rbroot, new);
 
-	spin_unlock(&memtype_lock);
+	write_unlock(&memtype_lock);
 
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 		start, end, cattr_name(new->type), cattr_name(req_type),
@@ -501,16 +501,16 @@ int free_memtype(u64 start, u64 end)
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
+		write_lock(&memtype_lock);
 		err = free_ram_pages_type(start, end);
-		spin_unlock(&memtype_lock);
+		write_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
 		return -EINVAL;
 	}
 
-	spin_lock(&memtype_lock);
+	write_lock(&memtype_lock);
 
 	entry = memtype_rb_search(&memtype_rbroot, start);
 	if (unlikely(entry == NULL))
@@ -551,7 +551,7 @@ int free_memtype(u64 start, u64 end)
 		}
 	}
 unlock_ret:
-	spin_unlock(&memtype_lock);
+	write_unlock(&memtype_lock);
 
 	if (err) {
 		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
@@ -583,10 +583,10 @@ static unsigned long lookup_memtype(u64 
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
 		struct page *page;
-		spin_lock(&memtype_lock);
+		read_lock(&memtype_lock);
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
 		rettype = get_page_memtype(page);
-		spin_unlock(&memtype_lock);
+		read_unlock(&memtype_lock);
 		/*
 		 * -1 from get_page_memtype() implies RAM page is in its
 		 * default state and not reserved, and hence of type WB
@@ -597,7 +597,7 @@ static unsigned long lookup_memtype(u64 
 		return rettype;
 	}
 
-	spin_lock(&memtype_lock);
+	read_lock(&memtype_lock);
 
 	entry = memtype_rb_search(&memtype_rbroot, paddr);
 	if (entry != NULL)
@@ -605,7 +605,7 @@ static unsigned long lookup_memtype(u64 
 	else
 		rettype = _PAGE_CACHE_UC_MINUS;
 
-	spin_unlock(&memtype_lock);
+	read_unlock(&memtype_lock);
 	return rettype;
 }
 
@@ -946,16 +946,16 @@ static struct memtype *memtype_get_idx(l
 	if (!print_entry)
 		return NULL;
 
-	spin_lock(&memtype_lock);
+	read_lock(&memtype_lock);
 	list_for_each_entry(list_node, &memtype_list, nd) {
 		if (pos == i) {
 			*print_entry = *list_node;
-			spin_unlock(&memtype_lock);
+			read_unlock(&memtype_lock);
 			return print_entry;
 		}
 		++i;
 	}
-	spin_unlock(&memtype_lock);
+	read_unlock(&memtype_lock);
 	kfree(print_entry);
 
 	return NULL;

