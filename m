Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZKFWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZKFWXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbZKFWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:09 -0500
Received: from kroah.org ([198.145.64.141]:56917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760200AbZKFWXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.712888699@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: [51/99] NOMMU: Dont pass NULL pointers to fput() in do_mmap_pgoff()
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=nommu-don-t-pass-null-pointers-to-fput-in-do_mmap_pgoff.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Howells <dhowells@redhat.com>

commit 89a8640279f8bb78aaf778d1fc5c4a6778f18064 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/nommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1384,9 +1384,11 @@ share:
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


