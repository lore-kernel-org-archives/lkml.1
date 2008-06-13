Return-Path: <linux-kernel-owner+w=401wt.eu-S1760314AbYFMBl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314AbYFMBl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYFMBlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:41:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49915 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYFMBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:41:17 -0400
Date: Fri, 13 Jun 2008 10:44:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Andy Whitcroft <apw@shadowen.org>, "riel@redhat.com" <riel@redhat.com>,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Subject: [PATCH] fix double unlock_page() in 2.6.26-rc5-mm3 kernel BUG at
 mm/filemap.c:575!
Message-Id: <20080613104444.63bd242f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080612202003.db871cac.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<4850E1E5.90806@linux.vnet.ibm.com>
	<20080612015746.172c4b56.akpm@linux-foundation.org>
	<20080612202003.db871cac.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is reproducer of panic. "quick fix" is attached.
But I think putback_lru_page() should be re-designed.

==
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>

int main(int argc, char *argv[])
{
        int fd;
        char *filename = argv[1];
        char buffer[4096];
        char *addr;
        int len;

        fd = open(filename, O_CREAT | O_EXCL | O_RDWR, S_IRWXU);

        if (fd < 0) {
                perror("open");
                exit(1);
        }
        len = write(fd, buffer, sizeof(buffer));

        if (len < 0) {
                perror("write");
                exit(1);
        }

        addr = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd, 0);
        if (addr == MAP_FAILED) {
                perror("mmap");
                exit(1);
        }
        munmap(addr, 4096);
        close(fd);

        unlink(filename);
}
==
you'll see panic.

Fix is here
==

quick fix for double unlock_page();

Signed-off-by: KAMEZAWA Hiroyuki <kamewzawa.hiroyu@jp.fujitsu.com>
Index: linux-2.6.26-rc5-mm3/mm/truncate.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/mm/truncate.c
+++ linux-2.6.26-rc5-mm3/mm/truncate.c
@@ -104,8 +104,8 @@ truncate_complete_page(struct address_sp
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
-	remove_from_page_cache(page);
 	clear_page_mlock(page);
+	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
 	page_cache_release(page);	/* pagecache ref */

