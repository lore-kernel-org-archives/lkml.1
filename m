Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYFCCK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYFCCK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYFCCKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:10:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbYFCCKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:10:20 -0400
Date: Mon, 2 Jun 2008 19:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       "Pavel Emelyanov" <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Message-Id: <20080602191016.85ce404b.akpm@linux-foundation.org>
In-Reply-To: <m163srxoq5.fsf@frodo.ebiederm.org>
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	<19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
	<m163srxoq5.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 18:59:46 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 2 Jun 2008 08:57:45 +0200
> Subject: [PATCH] proc: fix /proc/<pid> link count
> 
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
> 
>     [NET]: Make /proc/net a symlink on /proc/self/net (v3)
> 
> introduced /proc/net without bumping the link count on /proc/self.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> ---
>  fs/proc/base.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c447e07..10ee4a2 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2589,6 +2589,9 @@ static struct dentry
> *proc_pid_instantiate(struct inode *dir,
>  #ifdef CONFIG_SECURITY
>  	inode->i_nlink += 1;
>  #endif
> +#ifdef CONFIG_NET
> +	inode->i_nlink += 1;
> +#endif
> 
>  	dentry->d_op = &pid_dentry_operations;

A bit more explanation would be nice.

I assume that here we're accounting for a reference which net applies
to this dentry.  But it would be clearer and more robust to do that at
the site where that reference is really taken, not over in
proc_pid_instantiate().  Possible?


