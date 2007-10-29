Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbXJ2Qce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbXJ2Qce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXJ2QcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:32:25 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:21030 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754271AbXJ2QcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:32:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ji+akpCanBoWcM8/3q7cnl110GOhqBvsTswNvoZg9F6TPuWAtxdfWUSvkaT05UtEP2EjUZwrNqy9PuBjLfmrDtTzhSogj6NC3E20XWZMu17ov0AANmLaePRiLQG2pABwoWvoWWD7PEk3twPquazdzrATN7rP+ZK8j8AsP/clzMk=  ;
X-YMail-OSG: P9dOeP4VM1lDzDxlyPLlLnO3igGyog7DlCCPzayZkTxiBTcRWgqT6Cqwkkjr3BWMCusqqdliYw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH resend2] rd: fix data corruption on memory pressure
Date: Tue, 30 Oct 2007 01:34:45 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <200710291517.44332.borntraeger@de.ibm.com>
In-Reply-To: <200710291517.44332.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710300134.45950.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 01:17, Christian Borntraeger wrote:
> Nick, Eric, Andrew,
>
> we now have passed rc1. That means that Erics or Nicks rd rewrite is no
> longer an option for 2.6.24. If I followed the last thread correctly all
> alternative patches have one of the following issue
> - too big for post rc1

Yeah, I don't think the rewrites were ever intended for 2.6.24
anyway...


> - break reiserfs and maybe others
> - call into vfs while being unrelated
>
> So this is a resend of my patch, which is in my opinion the simplest fix
> for the data corruption problem.
> The patch was tested by our test department, thanks to Oliver Paukstadt and
> Thorsten Diehl.
>
> ---
>
> Subject: [PATCH] rd: fix data corruption on memory pressure
> From: Christian Borntraeger <borntraeger@de.ibm.com>
>
> We have seen ramdisk based install systems, where some pages of mapped
> libraries and programs were suddendly zeroed under memory pressure. This
> should not happen, as the ramdisk avoids freeing its pages by keeping them
> dirty all the time.
>
> It turns out that there is a case, where the VM makes a ramdisk page clean,
> without telling the ramdisk driver.
> On memory pressure shrink_zone runs and it starts to run
> shrink_active_list. There is a check for buffer_heads_over_limit, and if
> true, pagevec_strip is called. pagevec_strip calls try_to_release_page. If
> the mapping has no releasepage callback, try_to_free_buffers is called.
> try_to_free_buffers has now a special logic for some file systems to make a
> dirty page clean, if all buffers are clean. Thats what happened in our test
> case.
>
> The simplest solution is to provide a noop-releasepage callback for the
> ramdisk driver. This avoids try_to_free_buffers for ramdisk pages.

I think this is the least intrusive change that is least likely
to break rd, or any other kernel code, that we've seen. It really
should go in 2.6.24, IMO.

Acked-by: Nick Piggin <npiggin@suse.de>

> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/block/rd.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> Index: linux-2.6/drivers/block/rd.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/rd.c
> +++ linux-2.6/drivers/block/rd.c
> @@ -189,6 +189,18 @@ static int ramdisk_set_page_dirty(struct
>  	return 0;
>  }
>
> +/*
> + * releasepage is called by pagevec_strip/try_to_release_page if
> + * buffers_heads_over_limit is true. Without a releasepage function
> + * try_to_free_buffers is called instead. That can unset the dirty
> + * bit of our ram disk pages, which will be eventually freed, even
> + * if the page is still in use.
> + */
> +static int ramdisk_releasepage(struct page *page, gfp_t dummy)
> +{
> +	return 0;
> +}
> +
>  static const struct address_space_operations ramdisk_aops = {
>  	.readpage	= ramdisk_readpage,
>  	.prepare_write	= ramdisk_prepare_write,
> @@ -196,6 +208,7 @@ static const struct address_space_operat
>  	.writepage	= ramdisk_writepage,
>  	.set_page_dirty	= ramdisk_set_page_dirty,
>  	.writepages	= ramdisk_writepages,
> +	.releasepage	= ramdisk_releasepage,
>  };
>
>  static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t
> sector,
