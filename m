Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXJ3Wq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXJ3Wq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbXJ3WqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:46:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346AbXJ3WqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:46:03 -0400
Date: Tue, 30 Oct 2007 15:45:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmap: restore -ENODEV on missing f_op->mmap
In-Reply-To: <4727AE44.10902@suse.com>
Message-ID: <alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org>
References: <4727AE44.10902@suse.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Jeff Mahoney wrote:
> 
>  Personally, I think this is probably a case of LTP codifying existing
>  behavior rather than testing the for the specification. If that's the case
>  and nobody really cares about the change in behavior, I'm fine letting this
>  drop.

Hmm.. I think it's kind of stupid adding that special case early on, just 
to get one particular error case return when there are multiple possible 
ones. 

I don't care deeply, but this does smell like a test issue rather than a 
code issue.

Looking at that path, there are *other* things that might be worth 
cleaning up, but this wasn't one of them..

		Linus

---
diff --git a/mm/mmap.c b/mm/mmap.c
index facc1a7..fe286f7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -893,7 +893,6 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 			unsigned long flags, unsigned long pgoff)
 {
 	struct mm_struct * mm = current->mm;
-	struct inode *inode;
 	unsigned int vm_flags;
 	int error;
 	int accountable = 1;
@@ -959,9 +958,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 			return -EAGAIN;
 	}
 
-	inode = file ? file->f_path.dentry->d_inode : NULL;
-
 	if (file) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
 			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
