Return-Path: <linux-kernel-owner+w=401wt.eu-S935895AbZLPXBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895AbZLPXBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964866AbZLPXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:01:27 -0500
Received: from static.88-198-15-165.clients.your-server.de ([88.198.15.165]:57152
	"EHLO merzeus.obrandt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935375AbZLPXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:01:19 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 18:01:18 EST
Date: Wed, 16 Dec 2009 23:50:32 +0100
From: Torsten Landschoff <torsten@debian.org>
To: linux-kernel@vger.kernel.org
Cc: torsten@debian.org
Subject: Allocating huge physically continuous memory from kernel module
Message-ID: <20091216225032.GA10005@merzeus.obrandt.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi kernel developers,

I need to allocate huge continuous DMA buffers for a PCI DMA device. I know
that the right way to do large DMA transfers is using scatter gather.

Anyway, given that I don't want to change too much and I wanted to get the
driver out of the kernel (so we can use the official distribution kernels),
I tried to make this possible from a module by just allocating blocks of
maximum buddy order and coalescing these into clusters. After all, most of the
time my systems /proc/buddyinfo tells me I have plenty of large blocks
available.

I am posting my code here in the hope that
a) it may be helpful to somebody fighting the same problem
b) you tell me why this is a bad thing to do
I know there are border cases with this approach sucking all usable memory,
but I think the memory should be freed again soon enough to keep the system
running. Please note that the module is only loaded at boot time.

As an aside, on my new development box, I can easily allocate 2 GB of
continuous memory with this hack.


Flame away ;-)

Friendly, Torsten

--KsGdsel6WgEHnImy
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="bigalloc.c"

#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/list.h>
#include <linux/mm.h>
#include <asm/io.h>

MODULE_LICENSE("Dual BSD/GPL");

#ifdef DEBUG
#define TRACEF(fmt, args...)	printk(KERN_DEBUG fmt, ## args)
#else
#define TRACEF(fmt, args...)
#endif

/* Chapter: basic allocation unit retrieved via the buddy allocator */

#define CHAPTER_ORDER (MAX_ORDER - 1)		  /* page order of chapter */
#define CHAPTER_PAGES (1 << CHAPTER_ORDER)	  /* pages in a chapter */
#define CHAPTER_SIZE  (PAGE_SIZE * CHAPTER_PAGES) /* chapter size in bytes */


/*
 *  We join adjacent chapters into clusters, keeping track of allocations
 *  as an ordered set of clusters.
 *
 *  Note that the physical page frame number (pfn) is stored in the hopes
 *  that continuous pfn's represent continuous memory. Should we merge
 *  clusters via dma_addr_t physical addresses?
 */

struct cluster {
	struct list_head head;	/* ordered list of clusters */
	ulong page_first;	/* first page in cluster */
	ulong page_count;	/* number of pages */
};

struct cluster_set {
	struct list_head clusters;	/* allocated clusters */
};

/* Declare and initialize a cluster set. */
#define CLUSTER_SET(name) \
        struct cluster_set name = { clusters: LIST_HEAD_INIT(name.clusters) }

/* Retrieve the cluster from it's list head. */
static struct cluster *get_cluster(struct list_head *node)
{
	return list_entry(node, struct cluster, head);
}

static inline dma_addr_t phys_start(const struct cluster *cl)
{
	return page_to_phys(pfn_to_page(cl->page_first));
}

static inline dma_addr_t phys_end(const struct cluster *cl)
{
	return page_to_phys(nth_page(pfn_to_page(cl->page_first), cl->page_count));
}

/* Return node after target location for new chapter (passed as pfn). */
static struct list_head *find_insert_location(
	struct cluster_set *set, ulong chapter_start)
{
	struct list_head *p;
	list_for_each (p, &set->clusters) {
		if (get_cluster(p)->page_first > chapter_start)
			return p;
	}
	return &set->clusters;
}

/* Try to merge a new chapter by prepending it to the cluster at pos.
   Return true on success, false if unable to merge. */
static bool try_prepend(
	struct cluster_set *set, struct list_head *pos, ulong chapter_start)
{
	if (pos != &set->clusters) {
		struct cluster *cl = get_cluster(pos);
		if (chapter_start + CHAPTER_PAGES == cl->page_first) {
			cl->page_first = chapter_start;
			cl->page_count += CHAPTER_PAGES;
			return true;
		}
	}
	return false;
}

/* Try to merge a new chapter by appending it to cluster at pos.
   Return true on success, false if unable to merge. */
static bool try_append(
	struct cluster_set *set, struct list_head *pos, ulong chapter_start)
{
	if (pos != &set->clusters) {
		struct cluster *cl = get_cluster(pos);
		if (cl->page_first + cl->page_count == chapter_start) {
			cl->page_count += CHAPTER_PAGES;
			return true;
		}
	}
	return false;
}

/* Tries to merge the cluster previous to pos into it.
   Returns true on success (invalidates previous cluster, pos stays valid). */
static void try_merge_prev(struct cluster_set *set, struct cluster *pos)
{
	struct list_head *prev_head = pos->head.prev;

	if (prev_head != &set->clusters) {
		struct cluster *prev = get_cluster(prev_head);
		if (prev->page_first + prev->page_count == pos->page_first) {
			pos->page_first  = prev->page_first;
			pos->page_count += prev->page_count;
			list_del(prev_head);
			kfree(prev);
		}
	}
}

/* Account for another chapter allocation, returning the cluster it became
   part of. Returns NULL on error (out of memory). */
static struct cluster *add_alloc(struct cluster_set *set,
				 struct page *new_chapter)
{
	ulong chapter_start = page_to_pfn(new_chapter);

	struct list_head *insert_loc = find_insert_location(set, chapter_start);
	if (try_prepend(set, insert_loc, chapter_start)) {
		struct cluster *cl = get_cluster(insert_loc);
		try_merge_prev(set, cl);
		return cl;
	} else if (try_append(set, insert_loc->prev, chapter_start)) {
		return get_cluster(insert_loc->prev);
	} else {
		struct cluster *new_cluster = kmalloc(GFP_KERNEL, sizeof(*new_cluster));
		if (new_cluster) {
			new_cluster->page_first = chapter_start;
			new_cluster->page_count = CHAPTER_PAGES;
			list_add_tail(&new_cluster->head, insert_loc);
		}
		return new_cluster;
	}
}

/* Give up count chapters starting at start. */
static void free_chapters(struct page *start, unsigned long count)
{
	unsigned long i;
	TRACEF("Freeing %lu chapters @ 0x%lx.\n", count, (ulong) page_to_phys(start));
	for (i = 0; i < count; i++, start = nth_page(start, CHAPTER_PAGES)) {
		__free_pages(start, CHAPTER_ORDER);
	}
}

/* Free the set and all clusters allocated to it. */
static void free_set(struct cluster_set *set)
{
	struct cluster *pos, *t;
	TRACEF("Freeing clusters.\n");
	list_for_each_entry_safe(pos, t, &set->clusters, head) {
		free_chapters(pfn_to_page(pos->page_first), pos->page_count / CHAPTER_PAGES);
		kfree(pos);
	}
}

/* Lists the allocations in the given cluster set. */
static void list_allocs(struct cluster_set *set)
{
	struct cluster *cluster;
	TRACEF("Allocations in ascending order:\n");

	list_for_each_entry(cluster, &set->clusters, head) {
		TRACEF("Cluster from 0x%08lx .. 0x%08lx (%lu pages).\n",
				(ulong) phys_start(cluster),
				(ulong) phys_end(cluster),
				cluster->page_count);
	}
}

/* Remove the given cluster from the set, keeping the allocation. */
static void unlink_cluster(struct cluster_set *set, struct cluster *cl)
{
	list_del_init(&cl->head);
}

/* Allocate a big buffer of given size [bytes]. flags as in alloc_pages. */
struct page *bigbuf_alloc(unsigned int flags, ulong size)
{
	int order = size ? get_order(size) : 0;

	if (order <= CHAPTER_ORDER) {
		return alloc_pages(flags, order);
	} else {
		struct page *result;

		int chapters = (size + CHAPTER_SIZE - 1) / CHAPTER_SIZE;
		CLUSTER_SET(allocation_set);
		struct cluster *merged;

		TRACEF("Allocate huge block of size %lu (%i chapters).\n", size, chapters);

		do {
			struct page *chapter = alloc_pages(flags, CHAPTER_ORDER);
			if (!chapter)
				goto fail;
			TRACEF("Allocated chapter @ %lx.\n",
				(ulong) page_to_phys(chapter));
			merged = add_alloc(&allocation_set, chapter);
			if (!merged)
				goto fail;
			list_allocs(&allocation_set);
		} while (merged->page_count < chapters * CHAPTER_PAGES);

		unlink_cluster(&allocation_set, merged);
		TRACEF("After taking result:\n");
		list_allocs(&allocation_set);
		free_set(&allocation_set);
		result = pfn_to_page(merged->page_first);
		kfree(merged);
		return result;
fail:
		free_set(&allocation_set);
		TRACEF("Allocation failed.\n");
		return NULL;
	}
}

/* Free a buffer allocates by bigbuf_alloc. */
void bigbuf_free(struct page *start, ulong size)
{
	int size_order = size ? get_order(size) : 0;
	if (size_order < CHAPTER_ORDER) {
		__free_pages(start, size_order);
	} else {
		free_chapters(start, (size + CHAPTER_SIZE - 1) / CHAPTER_SIZE);
	}
}


ulong size = 16 * 1024 * 1024;
module_param(size, ulong, S_IRUGO);

struct page *huge_block = 0;

static int my_init(void)
{
	huge_block = bigbuf_alloc(GFP_KERNEL | __GFP_HIGHMEM, size);
	if (huge_block)
		printk(KERN_INFO "Allocated block at 0x%lx.\n",
			(ulong) page_to_phys(huge_block));
	else
		printk(KERN_ERR "Allocation of size %lu failed.\n", size);
	return 0;
}

static void my_exit(void)
{
	if (huge_block) {
		printk(KERN_INFO "Freeing block at 0x%lx.\n",
			(ulong) page_to_phys(huge_block));
		bigbuf_free(huge_block, size);
	}
}

module_init(my_init);
module_exit(my_exit);

--KsGdsel6WgEHnImy--
