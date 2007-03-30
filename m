Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXC3UoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXC3UoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXC3UoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:44:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXC3UoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:44:07 -0400
Date: Fri, 30 Mar 2007 13:43:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brian Pomerantz <bapper@piratehaven.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] fix page leak during core dump
Message-Id: <20070330134359.ec6d95bc.akpm@linux-foundation.org>
In-Reply-To: <20070329203913.GA5190@skull.piratehaven.org>
References: <20070329203913.GA5190@skull.piratehaven.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 13:39:13 -0700
Brian Pomerantz <bapper@piratehaven.org> wrote:

> When the dump cannot occur most likely because of a full file system
> and the page to be written is the zero page, the call to
> page_cache_release() is missed.
> 
> Signed-off-by: Brian Pomerantz <bapper@mvista.com>
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index a2fceba..9cc4f0a 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
>  				DUMP_SEEK(PAGE_SIZE);
>  			} else {
>  				if (page == ZERO_PAGE(addr)) {
> -					DUMP_SEEK(PAGE_SIZE);
> +					if (!dump_seek(file, PAGE_SIZE)) {
> +						page_cache_release(page);
> +						goto end_coredump;
> +					}

Oh for gawds sake I wish we could be rid of those idiotic macros :(

This patch looks OK to me, although a refcount leak on the ZERO_PAGE is
special, because that page is PageReserved().

It used to be the case that we'd ignore attempts to change the refcount on
reserved pages (or at least on the ZERO_PAGE), but we changed that, so we
now actually refcount the ZERO_PAGE.  (I think, from a quick read of the
code.  This contradicts my memory of how it works).

So I expect the net effect here is that a sufficiently determined attacker
can overflow the ZERO_PAGE's refcount, thus causing it to be "freed".  The
page allocator won't actually free the page due to PG_Reserved, but it'll
all become very noisy.

Nick, Hugh: agree?
