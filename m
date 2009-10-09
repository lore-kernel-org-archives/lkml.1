Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZJIBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZJIBJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbZJIBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:09:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40538 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353AbZJIBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:09:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Fix memory leak of never putback pages in mbind()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20091009100527.1284.A69D9226@jp.fujitsu.com>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com>
Message-Id: <20091009100708.1287.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Oct 2009 10:08:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if mbind() receive invalid address, do_mbind makes leaked page.
following test program detect its leak.

This patch fixes it.


migrate_efault.c
============================================
 #include <numaif.h>
 #include <numa.h>
 #include <sys/mman.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>

static unsigned long pagesize;

static void* make_hole_mapping(void)
{

	void* addr;

	addr = mmap(NULL, pagesize*3, PROT_READ|PROT_WRITE,
		    MAP_ANON|MAP_PRIVATE, 0, 0);
	if (addr == MAP_FAILED)
		return NULL;

	/* make page populate */
	memset(addr, 0, pagesize*3);

	/* make memory hole */
	munmap(addr+pagesize, pagesize);

	return addr;
}

int main(int argc, char** argv)
{
	void* addr;
	int ch;
	int node;
	struct bitmask *nmask = numa_allocate_nodemask();
	int err;
	int node_set = 0;

	while ((ch = getopt(argc, argv, "n:")) != -1){
		switch (ch){
		case 'n':
			node = strtol(optarg, NULL, 0);
			numa_bitmask_setbit(nmask, node);
			node_set = 1;
			break;
		default:
			;
		}
	}
	argc -= optind;
	argv += optind;

	if (!node_set)
		numa_bitmask_setbit(nmask, 0);

	pagesize = getpagesize();

	addr = make_hole_mapping();

	err = mbind(addr, pagesize*3, MPOL_BIND, nmask->maskp, nmask->size, MPOL_MF_MOVE_ALL);
	if (err)
		perror("mbind ");

	return 0;
}
============================================

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 473f888..824abf3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1061,6 +1061,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
+	} else {
+		putback_lru_pages(&pagelist);
 	}
 
 	up_write(&mm->mmap_sem);
-- 
1.6.0.GIT



