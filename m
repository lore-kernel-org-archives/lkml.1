Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXLLFi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXLLFi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXLLFir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:38:47 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:40739 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752410AbXLLFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:38:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=XgZazVlpBQjPbqMZLOLIKVEGKcyX9FOpDhDpZnnlK0esSOQCYUxMCyp/QyQbSbyvT6EBvmtxCcuRHeV4FjIhCKzqgbq9HA2U8Li+pL+E3H63Ixq3qGdK+5IgIjxCpZw4xJmF3SatXro4fzN9deJtIj5BSmaCeHmXGagUdJXSmzQ=  ;
X-YMail-OSG: _mNxVo4VM1kQEwvPAfgbd.LSUDpvwaMwEQ5D0FM.3SbcSLGyy_s0o52gSPSTvm72QGZebepEEw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 36/42] VFS: export drop_pagecache_sb
Date: Wed, 12 Dec 2007 16:38:34 +1100
User-Agent: KMail/1.9.5
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu> <11972545593966-git-send-email-ezk@cs.sunysb.edu>
In-Reply-To: <11972545593966-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712121638.35167.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 13:42, Erez Zadok wrote:
> Needed to maintain cache coherency after branch management.
>

Hmm, I'd much prefer to be able to sleep in invalidate_mapping_pages
before this function gets exported.

As it is, it can cause massive latencies on preemption and the inode_lock
so it is pretty much debug-only IMO. I'd rather it didn't escape into the
wild as is.

Either that or rework your cache coherency somehow.


> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  fs/drop_caches.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..90410ac 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -3,6 +3,7 @@
>   */
>
>  #include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/fs.h>
>  #include <linux/writeback.h>
> @@ -12,7 +13,7 @@
>  /* A global variable is a bit ugly, but it keeps the code simple */
>  int sysctl_drop_caches;
>
> -static void drop_pagecache_sb(struct super_block *sb)
> +void drop_pagecache_sb(struct super_block *sb)
>  {
>  	struct inode *inode;
>
> @@ -24,6 +25,7 @@ static void drop_pagecache_sb(struct super_block *sb)
>  	}
>  	spin_unlock(&inode_lock);
>  }
> +EXPORT_SYMBOL(drop_pagecache_sb);
>
>  void drop_pagecache(void)
>  {
