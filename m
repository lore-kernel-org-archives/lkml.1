Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZJ3NOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZJ3NOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZJ3NOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbZJ3NOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:14:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Don't pass NULL pointers to fput() in do_mmap_pgoff()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Date: Fri, 30 Oct 2009 13:13:26 +0000
Message-ID: <20091030131326.5891.68842.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't pass NULL pointers to fput() in the error handling paths of the NOMMU
do_mmap_pgoff() as it can't handle it.

The following can be used as a test program:

	int main() { static long long a[1024 * 1024 * 20] = { 0 }; return a;}

Without the patch, the code oopses in atomic_long_dec_and_test() as called by
fput() after the kernel complains that it can't allocate that big a chunk of
memory.  With the patch, the kernel just complains about the allocation size
and then the program segfaults during execve() as execve() can't complete the
allocation of all the new ELF program segments.

Reported-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>
---

 mm/nommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index cfea46c..969392c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1364,9 +1364,11 @@ share:
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
-	fput(region->vm_file);
+	if (region->vm_file)
+		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
-	fput(vma->vm_file);
+	if (vma->vm_file)
+		fput(vma->vm_file);
 	if (vma->vm_flags & VM_EXECUTABLE)
 		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);

