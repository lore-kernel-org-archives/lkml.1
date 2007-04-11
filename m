Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXDKRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXDKRvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXDKRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:51:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58732 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbXDKRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:51:39 -0400
X-Sasl-enc: kw3Jeur8rBz2rP66fpzz8Sqp5adYOB+jsqKIyLEpFkRW 1176313898
Subject: Re: [PATCH] autofs4: fix race in unhashed dentry code
From: Ian Kent <raven@themaw.net>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <461CF939.9030104@suse.com>
References: <461CF939.9030104@suse.com>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 01:49:37 +0800
Message-Id: <1176313777.3377.21.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 11:05 -0400, Jeff Mahoney wrote:
>  Commit f50b6f8691cae2e0064c499dd3ef3f31142987f0 introduced a
>  race in autofs4 between autofs_lookup_unhashed() and
>  autofs_dentry_release().
> 
>  autofs_dentry_release() ends up clearing the ->dentry and ->inode
>  members of autofs_info before removing it from the rehash list. The
>  list is protected by the rehash lock in both functions, but
>  since autofs_dentry_release() starts tearing the autofs_info struct
>  down before removing it from the list, autofs_lookup_unhashed() can
>  get a autofs_info with a NULL dentry.
> 
>  This patch moves the clearing of ->dentry and ->inode after the removal
>  from the rehash list.

Oh .. excellent, I had a bug report but I just couldn't see it for
looking.

You've made my day.
Thanks heaps
Ian

> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Ian Kent <raven@themaw.net>

> 
> ---
> 
>  fs/autofs4/root.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/fs/autofs4/root.c	2007-04-11 09:41:44.000000000 -0400
> +++ b/fs/autofs4/root.c	2007-04-11 10:54:37.000000000 -0400
> @@ -470,9 +470,6 @@ void autofs4_dentry_release(struct dentr
>  	if (inf) {
>  		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
>  
> -		inf->dentry = NULL;
> -		inf->inode = NULL;
> -
>  		if (sbi) {
>  			spin_lock(&sbi->rehash_lock);
>  			if (!list_empty(&inf->rehash))
> @@ -480,6 +477,9 @@ void autofs4_dentry_release(struct dentr
>  			spin_unlock(&sbi->rehash_lock);
>  		}
>  
> +		inf->dentry = NULL;
> +		inf->inode = NULL;
> +
>  		autofs4_free_ino(inf);
>  	}
>  }
> 

