Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZGUXEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZGUXEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZGUXEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:04:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59222 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZGUXEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:04:22 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 1/2] VM/SELinux: require CAP_SYS_RAWIO for all mmap_zero
	operations
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       dwalsh@redhat.com, cl@linux-foundation.org, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, cpardy@redhat.com,
       arnd@arndb.de
Date: Tue, 21 Jul 2009 19:03:39 -0400
Message-ID: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently non-SELinux systems need CAP_SYS_RAWIO for an application to mmap
the 0 page.  On SELinux systems they need a specific SELinux permission,
but do not need CAP_SYS_RAWIO.  This has proved to be a poor decision by
the SELinux team as, by default, SELinux users are logged in unconfined and
thus a malicious non-root has nothing stopping them from mapping the 0 page
of virtual memory.

On a non-SELinux system, a malicious non-root user is unable to do this, as
they need CAP_SYS_RAWIO.

This patch checks CAP_SYS_RAWIO for all operations which attemt to map a
page below mmap_min_addr.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/security.h |    2 --
 mm/mmap.c                |   11 +++++++++++
 mm/mremap.c              |    8 ++++++++
 mm/nommu.c               |    3 +++
 security/capability.c    |    2 --
 5 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 1459091..f7d198a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2197,8 +2197,6 @@ static inline int security_file_mmap(struct file *file, unsigned long reqprot,
 				     unsigned long addr,
 				     unsigned long addr_only)
 {
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
-		return -EACCES;
 	return 0;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 34579b2..3bc88c4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1050,6 +1050,10 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
+
+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
 	error = ima_file_mmap(file, prot);
 	if (error)
 		return error;
@@ -1657,10 +1661,14 @@ static int expand_downwards(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
+
 	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
 	if (error)
 		return error;
 
+	if ((address < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
 	anon_vma_lock(vma);
 
 	/*
@@ -2002,6 +2010,9 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (error)
 		return error;
 
+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = arch_mmap_check(addr, len, flags);
diff --git a/mm/mremap.c b/mm/mremap.c
index a39b7b9..fc866c3 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -303,6 +303,10 @@ unsigned long do_mremap(unsigned long addr,
 		if (ret)
 			goto out;
 
+		ret = -EACCES;
+		if ((new_addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+			goto out;
+
 		ret = do_munmap(mm, new_addr, new_len);
 		if (ret)
 			goto out;
@@ -410,6 +414,10 @@ unsigned long do_mremap(unsigned long addr,
 			ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
 			if (ret)
 				goto out;
+
+			ret = -EACCES;
+			if ((new_addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+				goto out;
 		}
 		ret = move_vma(vma, addr, old_len, new_len, new_addr);
 	}
diff --git a/mm/nommu.c b/mm/nommu.c
index 53cab10..891ed70 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -999,6 +999,9 @@ static int validate_mmap_request(struct file *file,
 	if (ret < 0)
 		return ret;
 
+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
 	/* looks okay */
 	*_capabilities = capabilities;
 	return 0;
diff --git a/security/capability.c b/security/capability.c
index f218dd3..a3a5d9b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -334,8 +334,6 @@ static int cap_file_mmap(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long addr, unsigned long addr_only)
 {
-	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
-		return -EACCES;
 	return 0;
 }
 

