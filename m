Return-Path: <linux-kernel-owner+w=401wt.eu-S1031281AbXECUZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031281AbXECUZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031266AbXECUZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:25:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031281AbXECUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:24:58 -0400
Date: Thu, 3 May 2007 13:22:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] revoke: change revoke_table to fileset and
 revoke_details
Message-Id: <20070503132253.7b6fe5fe.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705031752440.6505@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705031752440.6505@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 17:53:07 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revoke_table struct is overloaded because it serves two purposes:
> it manages the pre-allocated set of files and tracks the revoke
> operation so that we know where to start restore if the operation
> fails. This splits file set management to separate struct fileset and
> renames struct revoke_table to revoke_details.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/revoke.c |  171 +++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 101 insertions(+), 70 deletions(-)
> 
> Index: 26-mm/fs/revoke.c
> ===================================================================
> --- 26-mm.orig/fs/revoke.c	2007-05-03 17:10:56.000000000 +0300
> +++ 26-mm/fs/revoke.c	2007-05-03 17:14:49.000000000 +0300
> @@ -18,19 +18,71 @@  * Copyright (C) 2006-2007  Pekka Enberg
>  #include <linux/revoked_fs_i.h>
>  #include <linux/syscalls.h>
>  
> -/*
> - * This is used for pre-allocating an array of file pointers so that we don't
> - * have to do memory allocation under tasklist_lock.
> +/**
> + * fileset - an array of file pointers.
> + * @files:    the array of file pointers
> + * @nr:               number of elements in the array
> + * @end:      index to next unused file pointer
> + */
> +struct fileset {
> +	struct file	**files;
> +	unsigned long	nr;
> +	unsigned long	end;
> +};

What's the locking protocol for all this?

> +static void free_fset(struct fileset *fset)
> +{
> +      int i;
> +
> +      for (i = fset->end; i < fset->nr; i++)
> +              fput(fset->files[i]);
> +
> +      kfree(fset->files);
> +      kfree(fset);
> +}

Confused.  Shouldn't it be

	for (i = 0; i < fset->end; i++)

?

