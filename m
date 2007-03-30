Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXC3XHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXC3XHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933026AbXC3XHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:07:08 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:2633 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964AbXC3XG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:06:59 -0400
X-AuditID: d80ac287-96cc9bb000000c42-79-460d98125326 
Date: Sat, 31 Mar 2007 00:06:53 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>,
       Brian Pomerantz <bapper@piratehaven.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix page leak during core dump
In-Reply-To: <20070330151353.95cd56ed.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703310005350.32047@blonde.wat.veritas.com>
References: <20070329203913.GA5190@skull.piratehaven.org>
 <20070330134359.ec6d95bc.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com>
 <20070330151353.95cd56ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 30 Mar 2007 23:06:58.0112 (UTC) FILETIME=[1DE62C00:01C77320]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:
> 
> <would anyone be interested in hearing my opinion on the DUMP_SEEK macro
> again?>

Oooh, yes please.

> diff -puN fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump fs/binfmt_elf_fdpic.c
> --- a/fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump
> +++ a/fs/binfmt_elf_fdpic.c
> @@ -1480,8 +1480,10 @@ static int elf_fdpic_dump_segments(struc
>  				DUMP_SEEK(file->f_pos + PAGE_SIZE);
>  			}
>  			else if (page == ZERO_PAGE(addr)) {
> -				DUMP_SEEK(file->f_pos + PAGE_SIZE);
> -				page_cache_release(page);
> +				if (!dump_seek(file, file->f_pos + PAGE_SIZE)) {
> +					page_cache_release(page);
> +					return 0;
> +				}
>  			}
>  			else {
>  				void *kaddr;
> _

No, I think that's wrong: whereas the binfmt_elf one did its
page_cache_release down below at the bottom of the block, this
version does it in each subblock, so there you're removing the
dump_seek success one.  Can't we preserve that beauteous macro
here and just do...

--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1480,8 +1480,8 @@ static int elf_fdpic_dump_segments(struc
 				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else if (page == ZERO_PAGE(addr)) {
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 				page_cache_release(page);
+				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else {
 				void *kaddr;
