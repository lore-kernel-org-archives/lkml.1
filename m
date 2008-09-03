Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYICQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYICQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYICQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:25:25 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40618 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYICQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:25:25 -0400
Date: Wed, 3 Sep 2008 17:25:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Tejun Heo <tj@kernel.org>
cc: linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH #2.6.27-rc5] mmap: fix petty bug in anonymous shared mmap
 offset handling
In-Reply-To: <48BE9AAB.9070303@kernel.org>
Message-ID: <Pine.LNX.4.64.0809031713250.6250@blonde.site>
References: <48BE9AAB.9070303@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Tejun Heo wrote:

> Anonymous mappings should ignore offset but shared anonymous mapping
> forgot to clear it and makes the following legit test program trigger
> SIGBUS.
> 
>  #include <sys/mman.h>
>  #include <stdio.h>
>  #include <errno.h>
> 
>  #define PAGE_SIZE	4096
> 
>  int main(void)
>  {
> 	 char *p;
> 	 int i;
> 
> 	 p = mmap(NULL, 2 * PAGE_SIZE, PROT_READ|PROT_WRITE,
> 		  MAP_SHARED|MAP_ANONYMOUS, -1, PAGE_SIZE);
> 	 if (p == MAP_FAILED) {
> 		 perror("mmap");
> 		 return 1;
> 	 }
> 
> 	 for (i = 0; i < 2; i++) {
> 		 printf("page %d\n", i);
> 		 p[i * 4096] = i;
> 	 }
> 	 return 0;
>  }
> 
> Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Fair enough.  The current behaviour has (almost) never bothered us,
so I'm uncertain if your test is legit, but I can't see any reason
to object to the change.  Particularly since (just out of sight below
the context of your patch) we force pgoff in the MAP_PRIVATE case.

Acked-by: Hugh Dickins <hugh@veritas.com>

> ---
>  mm/mmap.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 339cf5c..e7a5a68 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1030,6 +1030,10 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
>  	} else {
>  		switch (flags & MAP_TYPE) {
>  		case MAP_SHARED:
> +			/*
> +			 * Ignore pgoff.
> +			 */
> +			pgoff = 0;
>  			vm_flags |= VM_SHARED | VM_MAYSHARE;
>  			break;
>  		case MAP_PRIVATE:
