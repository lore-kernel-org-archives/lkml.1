Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYICOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYICOLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYICOLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:11:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:58857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbYICOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:11:15 -0400
Message-ID: <48BE9AAB.9070303@kernel.org>
Date: Wed, 03 Sep 2008 16:09:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH #2.6.27-rc5] mmap: fix petty bug in anonymous shared mmap
 offset handling
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 14:11:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anonymous mappings should ignore offset but shared anonymous mapping
forgot to clear it and makes the following legit test program trigger
SIGBUS.

 #include <sys/mman.h>
 #include <stdio.h>
 #include <errno.h>

 #define PAGE_SIZE	4096

 int main(void)
 {
	 char *p;
	 int i;

	 p = mmap(NULL, 2 * PAGE_SIZE, PROT_READ|PROT_WRITE,
		  MAP_SHARED|MAP_ANONYMOUS, -1, PAGE_SIZE);
	 if (p == MAP_FAILED) {
		 perror("mmap");
		 return 1;
	 }

	 for (i = 0; i < 2; i++) {
		 printf("page %d\n", i);
		 p[i * 4096] = i;
	 }
	 return 0;
 }

Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 339cf5c..e7a5a68 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1030,6 +1030,10 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
+			/*
+			 * Ignore pgoff.
+			 */
+			pgoff = 0;
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			break;
 		case MAP_PRIVATE:
