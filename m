Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZDNGRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZDNGRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZDNGRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:17:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40816 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZDNGRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:17:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Cc: kosaki.motohiro@jp.fujitsu.com, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090414151204.C647.A69D9226@jp.fujitsu.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
Message-Id: <20090414151554.C64A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:16:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] mm: Don't unmap gup()ed page

Currently, following test program will fail.

forkscrewreverse-2.c
================================================
#define _GNU_SOURCE 1

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <memory.h>
#include <pthread.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

#define FILESIZE (40*1024*1024)
#define BUFSIZE  (40*1024*1024)

static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
static const char *filename = "file.dat";
static int fd;
static void *buffer;
#define PAGE_SIZE   4096

void
dump_buffer(char *buf, int len)
{
	int i;
	int last_off, last_val;

	last_off = -1;
	last_val = -1;

	for (i = 0; i < len; i++) {
		if (last_off < 0) {
			last_off = i;
			last_val = buf[i];
			continue;
		}

		if (buf[i] != last_val) {
			printf("%d - %d: %x\n", last_off, i - 1, last_val);
			last_off = i;
			last_val = buf[i];
		}
	}

	if (last_off != len - 1)
		printf("%d - %d: %x\n", last_off, i-1, last_val);
}

static void store(void)
{
	int i;

	if (usleep(100*1000) == -1)
		perror("usleep"), exit(1);

	printf("child storing\n"); fflush(stdout);
	for (i = 0; i < BUFSIZE; i++)
		((char *)buffer)[i] = 0xff;
	printf("child storing end\n"); fflush(stdout);
	_exit(0);
}

static void *writer(void *arg)
{
	int i;

	if (pthread_mutex_lock(&lock) == -1)
		perror("pthread_mutex_lock"), exit(1);

	printf("thread writing\n"); fflush(stdout);
	for (i = 0; i < FILESIZE / BUFSIZE; i++) {
		size_t count = BUFSIZE;
		ssize_t ret;

		do {
			ret = write(fd, buffer, count);
			if (ret == -1) {
				if (errno != EINTR)
					perror("write"), exit(1);
				ret = 0;
			}
			count -= ret;
		} while (count);
	}
	printf("thread writing done\n"); fflush(stdout);

	if (pthread_mutex_unlock(&lock) == -1)
		perror("pthread_mutex_lock"), exit(1);

	return NULL;
}

int main(int argc, char *argv[])
{
	int i;
	int status;
	pthread_t writer_thread;
	pid_t store_proc;

	posix_memalign(&buffer, PAGE_SIZE, BUFSIZE);
	printf("Write buffer: %p.\n", buffer);

	for (i = 0; i < BUFSIZE; i++)
		((char *)buffer)[i] = 0x00;

	fd = open(filename, O_RDWR|O_DIRECT);
	if (fd == -1)
		perror("open"), exit(1);

	if (pthread_mutex_lock(&lock) == -1)
		perror("pthread_mutex_lock"), exit(1);

	if (pthread_create(&writer_thread, NULL, writer, NULL) == -1)
		perror("pthred_create"), exit(1);

	store_proc = fork();
	if (store_proc == -1)
		perror("fork"), exit(1);

	if (pthread_mutex_unlock(&lock) == -1)
		perror("pthread_mutex_lock"), exit(1);

	if (!store_proc)
		store();

	if (usleep(50*1000) == -1)
		perror("usleep"), exit(1);

	printf("parent storing\n"); fflush(stdout);
	for (i = 0; i < BUFSIZE; i++)
		((char *)buffer)[i] = 0x11;

	do {
		pid_t w;
		w = waitpid(store_proc, &status, WUNTRACED | WCONTINUED);
		if (w == -1)
			perror("waitpid"), exit(1);
	} while (!WIFEXITED(status) && !WIFSIGNALED(status));

	if (pthread_join(writer_thread, NULL) == -1)
		perror("pthread_join"), exit(1);

	close(fd);
	fd = open(filename, O_RDWR|O_DIRECT);
	if (fd == -1)
		perror("open"), exit(1);

	if (read(fd, buffer, BUFSIZE) < 0)
		perror("read buffer"), exit(1);

	if (memchr(buffer, 0xff, BUFSIZE) != NULL)
		fprintf(stderr, "          test failed !!!!!!!!!!!!!!!\n\n");

	dump_buffer(buffer, BUFSIZE);

	exit(0);
}
===============================================================

It because following scenario happend.

   CPU0                     CPU1                    CPU2           note
  (parent)                 (writer thread)         (child)
==============================================================================
  fill 0
  create writer thread
  fork()
                           write()
                           | get_user_pages(read)                 inc page_count
                           |
  fill 0x11                |                                      COW break
                           |                                      page get new page.
                           |                                      (then, child get original page as writable)
                           |
                           |                       fill 0xff      child change DIO targetted page
                           |
                           v

The root cause is, reuse_swap_page() don't consider get_user_pages()'s ref
counting-up. it only consider map_count.

this patch change reuse_swap_page() to check page_count(). and only change reuse_swap_page
makes following side-effect. then the patch also change try_to_unmap().

   CPU0               CPU1                      CPU2              note
  (thread1)         (thread2)
=============================================================================
                     DIO read()
                     | get_user_pages(write)                     inc page_count
                     |
                     |
                     |                          try_to_unmap()   the page is unmaped from
                     |                                           process's pte.
                     |
  do_wp_page()       |                                           page fault and
                     |                                           reuse_swap_page() return 0,
                     |                                           then, COW break happend and
                     |                                           process get new copyed page.
                     |                                           DIO read result will lost.
                     v


Now, reuse_swap_cache() behave as before commit c475a8ab age, and read-side
get_user_pages() and get_user_pages_fast() become fork safe.

This patch doesn't only fix DirectIO, but also fix other get_user_pages() read-side caller
(e.g. futex, vmsplice, et al.)


btw, if you want to write-side get_user_pages, you should prevent fork by mmap_sem
to critical section.

obiously wrong example code:

	down_read(&current->mm->mmap_sem);
	get_user_pages(current, current->mm, addr, 1, 1, 0, &page, NULL);
	up_read(&current->mm->mmap_sem);

up_read(&current->mm->mmap_sem) mean end of critical section, then, this code is
obiously fork unsafe.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Sugessted-by: Linus Torvalds <torvalds@osdl.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-mm@kvack.org
---
 mm/rmap.c     |   21 +++++++++++++++++++++
 mm/swapfile.c |   10 +++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

Index: b/mm/swapfile.c
===================================================================
--- a/mm/swapfile.c	2009-04-11 21:38:33.000000000 +0900
+++ b/mm/swapfile.c	2009-04-11 21:38:45.000000000 +0900
@@ -533,6 +533,8 @@ static inline int page_swapcount(struct 
  * to it.  And as a side-effect, free up its swap: because the old content
  * on disk will never be read, and seeking back there to write new content
  * later would only waste time away from clustering.
+ * Caller must hold pte_lock. try_to_unmap() decrement page::_mapcount
+ * and get_user_pages() increment page::_count under pte_lock.
  */
 int reuse_swap_page(struct page *page)
 {
@@ -547,7 +549,13 @@ int reuse_swap_page(struct page *page)
 			SetPageDirty(page);
 		}
 	}
-	return count == 1;
+
+	/*
+	 * If we can re-use the swap page _and_ the end
+	 * result has only one user (the mapping), then
+	 * we reuse the whole page
+	 */
+	return count + page_count(page) == 2;
 }
 
 /*
Index: b/mm/rmap.c
===================================================================
--- a/mm/rmap.c	2009-04-11 21:38:33.000000000 +0900
+++ b/mm/rmap.c	2009-04-12 00:58:58.000000000 +0900
@@ -773,6 +773,27 @@ static int try_to_unmap_one(struct page 
 		goto out;
 
 	/*
+	 * Don't pull an anonymous page out from under get_user_pages.
+	 * GUP carefully breaks COW and raises page count (while holding
+	 * pte_lock, as we have here) to make sure that the page
+	 * cannot be freed.  If we unmap that page here, a user write
+	 * access to the virtual address will bring back the page, but
+	 * its raised count will (ironically) be taken to mean it's not
+	 * an exclusive swap page, do_wp_page will replace it by a copy
+	 * page, and the user never get to see the data GUP was holding
+	 * the original page for.
+	 *
+	 * This test is also useful for when swapoff (unuse_process) has
+	 * to drop page lock: its reference to the page stops existing
+	 * ptes from being unmapped, so swapoff can make progress.
+	 */
+	if (PageSwapCache(page) &&
+	    page_count(page) != page_mapcount(page) + 2) {
+		ret = SWAP_FAIL;
+		goto out_unmap;
+	}
+
+	/*
 	 * If the page is mlock()d, we cannot swap it out.
 	 * If it's recently referenced (perhaps page_referenced
 	 * skipped over this mm) then we should reactivate it.


