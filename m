Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZFAVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZFAVvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZFAVvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43309 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZFAVu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:50:57 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:26 -0700
Message-Id: <1243893048-17031-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 01/23] mm: Introduce revoke_file_mappings.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When the backing store of a file becomes inaccessible we need a function
to remove that file from the page tables and arrange for page faults
to receive SIGBUS until the file is unmapped.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 include/linux/mm.h |    2 +
 mm/memory.c        |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..5d7480d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -808,6 +808,8 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 extern int vmtruncate(struct inode * inode, loff_t offset);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
+extern void revoke_file_mappings(struct file *file);
+
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, int write_access);
diff --git a/mm/memory.c b/mm/memory.c
index 4126dd1..5cbee3b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -55,6 +55,7 @@
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
 #include <linux/elf.h>
+#include <linux/file.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -2358,6 +2359,103 @@ void unmap_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
+static int revoked_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+static struct vm_operations_struct revoked_vm_ops = {
+	.fault	= revoked_fault,
+};
+
+static void revoke_vma(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	unsigned long start_addr, end_addr, size;
+	struct mm_struct *mm;
+
+	start_addr = vma->vm_start;
+	end_addr = vma->vm_end;
+
+	/* Switch out the locks so I can maninuplate this under the mm sem.
+	 * Needed so I can call vm_ops->close.
+	 */
+	mm = vma->vm_mm;
+	atomic_inc(&mm->mm_users);
+	spin_unlock(&mapping->i_mmap_lock);
+
+	/* Block page faults and other code modifying the mm. */
+	down_write(&mm->mmap_sem);
+
+	/* Lookup a vma for my file address */
+	vma = find_vma(mm, start_addr);
+	if (vma->vm_file != file)
+		goto out;
+
+	start_addr = vma->vm_start;
+	end_addr   = vma->vm_end;
+	size	   = end_addr - start_addr;
+
+	/* Unlock the pages */
+	if (mm->locked_vm && (vma->vm_flags & VM_LOCKED)) {
+		mm->locked_vm -= vma_pages(vma);
+		vma->vm_flags &= ~VM_LOCKED;
+	}
+
+	/* Unmap the vma */
+	zap_page_range(vma, start_addr, size, NULL);
+
+	/* Unlink the vma from the file */
+	unlink_file_vma(vma);
+
+	/* Close the vma */
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+	fput(vma->vm_file);
+	vma->vm_file = NULL;
+	if (vma->vm_flags & VM_EXECUTABLE)
+		removed_exe_file_vma(vma->vm_mm);
+
+	/* Repurpose the vma  */
+	vma->vm_private_data = NULL;
+	vma->vm_ops = &revoked_vm_ops;
+	vma->vm_flags &= ~(VM_NONLINEAR | VM_CAN_NONLINEAR);
+out:
+	up_write(&mm->mmap_sem);
+	spin_lock(&mapping->i_mmap_lock);
+}
+
+void revoke_file_mappings(struct file *file)
+{
+	/* After a file has been marked dead update the vmas */
+	struct address_space *mapping = file->f_mapping;
+	struct vm_area_struct *vma;
+	struct prio_tree_iter iter;
+
+	spin_lock(&mapping->i_mmap_lock);
+
+restart_tree:
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
+		/* Skip quickly over vmas that do not need to be touched */
+		if (vma->vm_file != file)
+			continue;
+		revoke_vma(vma);
+		goto restart_tree;
+	}
+
+restart_list:
+	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
+		/* Skip quickly over vmas that do not need to be touched */
+		if (vma->vm_file != file)
+			continue;
+		revoke_vma(vma);
+		goto restart_list;
+	}
+
+	spin_unlock(&mapping->i_mmap_lock);
+}
+
 /**
  * vmtruncate - unmap mappings "freed" by truncate() syscall
  * @inode: inode of the file used
-- 
1.6.3.1.54.g99dd.dirty

