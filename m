Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYL3XdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYL3XdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYL3XdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:33:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbYL3XdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:33:09 -0500
Date: Tue, 30 Dec 2008 15:32:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] minix: fix add link - wrong position calculation
Message-Id: <20081230153230.8e72dc88.akpm@linux-foundation.org>
In-Reply-To: <20081228232550.GA11504@rain>
References: <20081228232550.GA11504@rain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 02:25:50 +0300
Evgeniy Dushistov <dushistov@mail.ru> wrote:

> This patch fixes add link method.
> Position in directory was calculated in wrong way.
> 
> Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
> ---
>  fs/minix/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/minix/dir.c b/fs/minix/dir.c
> index f704338..4b603b7 100644
> --- a/fs/minix/dir.c
> +++ b/fs/minix/dir.c
> @@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
>  	return -EINVAL;
>  
>  got_it:
> -	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
> +	pos = page_offset(page) + p - (char*)page_address(page);
>  	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
>  					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
>  	if (err)

Well that's cute.  Seems that we broke it over a year ago:

commit 4a66af9eaa9531372cfcb9e20103ed147c729ff9
Author:     Nick Piggin <npiggin@suse.de>
AuthorDate: Tue Oct 16 01:25:21 2007 -0700
Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
CommitDate: Tue Oct 16 09:42:57 2007 -0700

    minixfs: convert to new aops

Is minixfs getting THAT little use, or is this bustage more subtle
than it appears?
