Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZDPXpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZDPXpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbZDPXpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:45:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbZDPXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:45:42 -0400
Message-ID: <49E7C323.9040805@redhat.com>
Date: Thu, 16 Apr 2009 18:45:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC] check for frozen filesystems in the mmap path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Tweedie mentioned to me a concern that while a filesystem
is frozen, data could be dirtied for it via mmap, thereby using
up enough memory that the unfreeze process may be stuck trying
to allocate memory by writing back mmap-dirty data to the frozen
fs.

Christoph suggested maybe a check_frozen in the mmap path to
prevent this; does the sort of thing below look sane?

signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1944,6 +1944,7 @@ static int do_wp_page(struct mm_struct *
 		 * read-only shared pages can get COWed by
 		 * get_user_pages(.write=1, .force=1).
 		 */
+		vfs_check_frozen(old_page->mapping->host->i_sb, SB_FREEZE_WRITE);
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 			struct vm_fault vmf;
 			int tmp;
@@ -2660,6 +2661,7 @@ static int __do_fault(struct mm_struct *
 			 * address space wants to know that the page is about
 			 * to become writable
 			 */
+			vfs_check_frozen(vmf.page->mapping->host->i_sb, SB_FREEZE_WRITE);
 			if (vma->vm_ops->page_mkwrite) {
 				int tmp;
 

