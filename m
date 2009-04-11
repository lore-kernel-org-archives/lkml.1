Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZDKMDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZDKMDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZDKMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:03:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45777 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZDKMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:03:27 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 11 Apr 2009 05:03:23 -0700
In-Reply-To: <m1skkf761y.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sat\, 11 Apr 2009 05\:01\:29 -0700")
Message-ID: <m1myan75ys.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [RFC][PATCH 1/9] mm: Introduce remap_file_mappings.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 819088d701e3a821db8e08ed83d46c00c27cc772 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Tue, 7 Apr 2009 19:35:07 -0700
Subject: 

When the backing store of a file becomes inaccessible we need a function
to remove that file from the page tables and arrange for page faults
to receive SIGBUS until the file is unmapped.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/mm.h |    1 +
 mm/memory.c        |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..96d8342 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -807,6 +807,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern int vmtruncate(struct inode * inode, loff_t offset);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
+extern void remap_file_mappings(struct file *file, struct vm_operations_struct *vm_ops);
 
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index cf6873e..dcd0a3c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2325,6 +2325,93 @@ void unmap_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
+static void remap_vma(struct vm_area_struct *vma,
+		      struct vm_operations_struct *vm_ops)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	unsigned long start_addr, end_addr, size;
+	struct mm_struct *mm;
+
+	start_addr = vma->vm_start;
+	end_addr = vma->vm_end;
+
+	/* Has this vma already been processed? */
+	if (vma->vm_ops == vm_ops)
+		return;
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
+	if (vma->vm_ops == vm_ops)
+		goto out;
+
+	start_addr = vma->vm_start;
+	end_addr   = vma->vm_end;
+	size	   = end_addr - start_addr;
+
+	/* Unmap the vma */
+	zap_page_range(vma, start_addr, size, NULL);
+
+	/* Close the vma */
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+
+	/* Repurpose the vma  */
+	vma->vm_private_data = NULL;
+	vma->vm_ops = vm_ops;
+	if (vm_ops->open)
+		vm_ops->open(vma);
+out:
+	up_write(&mm->mmap_sem);
+	spin_lock(&mapping->i_mmap_lock);
+}
+
+void remap_file_mappings(struct file *file, struct vm_operations_struct *vm_ops)
+{
+	/* After file->f_ops has been changed update the vmas */
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
+		if (vma->vm_ops == vm_ops)
+			continue;
+		remap_vma(vma, vm_ops);
+		goto restart_tree;
+	}
+
+restart_list:
+	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
+		/* Skip quickly over vmas that do not need to be touched */
+		if (vma->vm_file != file)
+			continue;
+		if (vma->vm_ops == vm_ops)
+			continue;
+		remap_vma(vma, vm_ops);
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
1.6.1.2.350.g88cc

