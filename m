Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZDKMFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZDKMFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZDKMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:05:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46498 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbZDKMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:05:28 -0400
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
Date: Sat, 11 Apr 2009 05:05:23 -0700
In-Reply-To: <m1skkf761y.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sat\, 11 Apr 2009 05\:01\:29 -0700")
Message-ID: <m1iqlb75vg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [RFC][PATCH 2/9] mm: Implement generic support for revoking a mapping.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/mm.h |    2 ++
 mm/memory.c        |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 96d8342..3fcbb8e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -807,6 +807,8 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern int vmtruncate(struct inode * inode, loff_t offset);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
+
+extern struct vm_operations_struct revoked_vm_ops;
 extern void remap_file_mappings(struct file *file, struct vm_operations_struct *vm_ops);
 
 #ifdef CONFIG_MMU
diff --git a/mm/memory.c b/mm/memory.c
index dcd0a3c..f68c84e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2378,6 +2378,15 @@ out:
 	spin_lock(&mapping->i_mmap_lock);
 }
 
+static int revoked_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+struct vm_operations_struct revoked_vm_ops = {
+	.fault	= revoked_fault,
+};
+
 void remap_file_mappings(struct file *file, struct vm_operations_struct *vm_ops)
 {
 	/* After file->f_ops has been changed update the vmas */
-- 
1.6.1.2.350.g88cc

