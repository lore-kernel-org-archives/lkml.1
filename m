Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXK2Tpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXK2Tpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbXK2Tpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:45:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760989AbXK2Tpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:45:30 -0500
Message-ID: <474F16D3.5060009@redhat.com>
Date: Thu, 29 Nov 2007 14:45:23 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
Subject: remap_file_pages() broken in 2.6.23?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Original report: https://bugzilla.redhat.com/show_bug.cgi?id=404201

The test case below, taken from the LTP test code, prints -1 (as
expected) on 2.6.22 and 0 on 2.6.23. It tries to remap an out-of-range
page. Proposed patch follows the program. Bug was apparently caused by
commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7.

/*
 * originally remap_file_pages02.c, from LTP
 *  - creates the file 'cache'; no cleanup
 *
 * Copyright (C) Ricardo Salveti de Araujo, 2007
 *
 * GPL v2
 */

#define _GNU_SOURCE
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <syscall.h>
#include <stdlib.h>
#include <linux/unistd.h>

/* Test case defines */
#define WINDOW_START 0x48000000

size_t page_sz;
size_t page_words;
size_t cache_pages;
size_t cache_sz;
size_t window_pages;
size_t window_sz;

static char *cache_contents;
int fd;					/* File descriptor used at the test */
char *data = NULL;
char *data01 = NULL;

int
main(int ac, char **av)
{
	int i, j, ret;

	page_sz = getpagesize();
	page_words = (page_sz/sizeof(char));

	/* Set the cache size */
	cache_pages = 32;
	cache_sz = cache_pages*page_sz;
	cache_contents = (char *) malloc(cache_sz * sizeof(char));

	for (i = 0; i < cache_pages; i++) {
                char *page = cache_contents + i*page_sz;

		for (j = 0; j < page_words; j++)
			page[j] = i;
	}

	if ((fd = open("cache", O_RDWR|O_CREAT|O_TRUNC,S_IRWXU)) < 0)
		perror("open"),  exit(1);

	if (write(fd, cache_contents, cache_sz) != cache_sz)
		perror("write"),  exit(1);

	data = mmap((void *)WINDOW_START,
			cache_sz,
			PROT_READ|PROT_WRITE,
			MAP_FIXED | MAP_SHARED,
			fd, 0);

	if (data == MAP_FAILED)
		perror("mmap"),  exit(1);

	ret = remap_file_pages(data, page_sz, 0, cache_pages * 2, 0);

	printf("%d\n", ret);

	exit(0);
}

Patch:

Signed-off-by: Supriya Kannery <supriyak@in.ibm.com>

--- linux-2.6.23/mm/fremap.c.orig	2007-11-22 00:56:09.000000000 -0600
+++ linux-2.6.23/mm/fremap.c	2007-11-26 03:08:55.000000000 -0600
@@ -124,6 +124,7 @@ asmlinkage long sys_remap_file_pages(uns
 	struct vm_area_struct *vma;
 	int err = -EINVAL;
 	int has_write_lock = 0;
+	unsigned long f_size = 0;
 
 	if (__prot)
 		return err;
@@ -181,6 +182,14 @@ asmlinkage long sys_remap_file_pages(uns
 			goto retry;
 		}
 		mapping = vma->vm_file->f_mapping;
+
+		f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
+		f_size = f_size >> PAGE_CACHE_SHIFT;
+		if ((pgoff + size >> PAGE_CACHE_SHIFT) > f_size) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * page_mkclean doesn't work on nonlinear vmas, so if
 		 * dirty pages need to be accounted, emulate with linear
