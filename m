Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXJQWcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXJQWcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbXJQWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:32:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758390AbXJQWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:32:28 -0400
Date: Wed, 17 Oct 2007 15:32:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: Re: [PATCH] dcache: don't expose uninitialized memory in
 /proc/<pid>/fd/<fd>
Message-Id: <20071017153201.d4e0679b.akpm@linux-foundation.org>
In-Reply-To: <20071016193557.GB8650@fieldses.org>
References: <20071016193230.GA8650@fieldses.org>
	<20071016193557.GB8650@fieldses.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 15:35:57 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Well, it's not especially important that target->d_iname get the
> contents of dentry->d_iname, but it's important that it get initialized
> with *something*, otherwise we're just exposing some random piece of
> memory to anyone who reads the link at /proc/<pid>/fd/<fd> for the
> deleted file, when it's still held open by someone.
> 

hm, that was tricky.

> ---
>  fs/dcache.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> (Am I missing something?  I've also run a test program that copies a
> short (<36 character) name ontop of a long (>=36 character) name and see
> that the first time I run it, without this patch, I get unpredicatable
> results out of /proc/<pid>/fd/<fd>.)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 5663a31..24252fc 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1483,6 +1483,8 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
>  			 * dentry:internal, target:external.  Steal target's
>  			 * storage and make target internal.
>  			 */
> +			memcpy(target->d_iname, dentry->d_name.name,
> +					dentry->d_name.len + 1);
>  			dentry->d_name.name = target->d_name.name;
>  			target->d_name.name = target->d_iname;
>  		}

Or we could just stick a \0 in there.

Or perhaps we should set it to "(deleted file)"?
