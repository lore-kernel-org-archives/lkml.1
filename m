Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbXHVItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbXHVItU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXHVItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:49:10 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:44029 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbXHVItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:49:08 -0400
Date: Wed, 22 Aug 2007 11:48:52 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 3/3] mm: variable length argument support
Message-ID: <20070822084852.GA12314@localdomain>
References: <20070613100334.635756997@chello.nl> <20070613100835.014096712@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613100835.014096712@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:03:37PM +0200, Peter Zijlstra wrote:
> From: Ollie Wild <aaw@google.com>
> 
> Remove the arg+env limit of MAX_ARG_PAGES by copying the strings directly
> from the old mm into the new mm.
> 
[...]
> +static int __bprm_mm_init(struct linux_binprm *bprm)
> +{
[...]
> +	vma->vm_flags = VM_STACK_FLAGS;
> +	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
> +	err = insert_vm_struct(mm, vma);
> +	if (err) {
> +		up_write(&mm->mmap_sem);
> +		goto err;
> +	}
> +

That change causes a crash in khelper when overcommit_memory = 2 
under 2.6.23-rc3.

When a khelper execs, at __bprm_mm_init() current->mm is still NULL.
insert_vm_struct() calls security_vm_enough_memory(), which calls 
__vm_enough_memory(), and that's where current->mm->total_vm gets 
dereferenced.


Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/mm/mmap.c b/mm/mmap.c
index 906ed40..6e021df 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -163,10 +163,12 @@ int __vm_enough_memory(long pages, int cap_sys_admin)
 	if (!cap_sys_admin)
 		allowed -= allowed / 32;
 	allowed += total_swap_pages;
-
-	/* Don't let a single process grow too big:
-	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+
+	if (current->mm) {
+		/* Don't let a single process grow too big:
+		   leave 3% of the size of this process for other processes */
+		allowed -= current->mm->total_vm / 32;
+	}
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
