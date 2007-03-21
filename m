Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbXCURtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbXCURtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXCURtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:49:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259AbXCURtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:49:01 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Make SYSV SHM nattch work correctly
To: torvalds@osdl.org, akpm@osdl.org, bryan.wu@analog.com,
       rgetz@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 21 Mar 2007 17:48:39 +0000
Message-ID: <20070321174839.23780.44456.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make the SYSV SHM nattch counter work correctly by forcing multiple VMAs to be
produced to represent MAP_SHARED segments, even if they overlap exactly.

Using this test program:

	http://people.redhat.com/~dhowells/doshm.c

Run as:

	doshm sysv

I can see nattch going from one before the patch:

	# /doshm sysv
	Command: sysv
	shmid: 65536
	memory: 0xc3700000
	c0b00000-c0b04000 rw-p 00000000 00:00 0
	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3180000-c31dede4 r-xs 00000000 00:0b 14582179  /lib/libuClibc-0.9.28.so
	c3520000-c352278c rw-p 00000000 00:0b 13763417  /doshm
	c3584000-c35865e8 r-xs 00000000 00:0b 13763417  /doshm
	c3588000-c358aa00 rw-p 00008000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3590000-c359b6c0 rw-p 00000000 00:00 0
	c3620000-c3640000 rwxp 00000000 00:00 0
	c3700000-c37fa000 rw-S 00000000 00:06 1411      /SYSV00000000 (deleted)
	c3700000-c37fa000 rw-S 00000000 00:06 1411      /SYSV00000000 (deleted)
	nattch 1

To two after the patch:

	# /doshm sysv
	Command: sysv
	shmid: 0
	memory: 0xc3700000
	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3180000-c31dede4 r-xs 00000000 00:0b 14582179  /lib/libuClibc-0.9.28.so
	c3320000-c3340000 rwxp 00000000 00:00 0
	c3530000-c35325e8 r-xs 00000000 00:0b 13763417  /doshm
	c3534000-c353678c rw-p 00000000 00:0b 13763417  /doshm
	c3538000-c353aa00 rw-p 00008000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3590000-c359b6c0 rw-p 00000000 00:00 0
	c35a4000-c35a8000 rw-p 00000000 00:00 0
	c3700000-c37fa000 rw-S 00000000 00:06 1369      /SYSV00000000 (deleted)
	c3700000-c37fa000 rw-S 00000000 00:06 1369      /SYSV00000000 (deleted)
	nattch 2

That's +1 to nattch for each shmat() made.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index ba6df4d..cbbc137 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -826,6 +826,11 @@ unsigned long do_mmap_pgoff(struct file *file,
 		unsigned long pglen = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long vmpglen;
 
+		/* suppress VMA sharing for shared regions */
+		if (vm_flags & VM_SHARED &&
+		    capabilities & BDI_CAP_MAP_DIRECT)
+			goto dont_share_VMAs;
+
 		for (rb = rb_first(&nommu_vma_tree); rb; rb = rb_next(rb)) {
 			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
 
@@ -859,6 +864,7 @@ unsigned long do_mmap_pgoff(struct file *file,
 			goto shared;
 		}
 
+	dont_share_VMAs:
 		vma = NULL;
 
 		/* obtain the address at which to make a shared mapping

