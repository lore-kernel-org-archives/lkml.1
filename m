Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYFDIlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYFDIlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYFDIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:41:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYFDIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:41:30 -0400
Date: Wed, 4 Jun 2008 01:40:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: calculate the correct /proc/<pid> link count
Message-Id: <20080604014059.06b170b4.akpm@linux-foundation.org>
In-Reply-To: <20080603131659.GA2970@damson.getinternet.no>
References: <20080603131659.GA2970@damson.getinternet.no>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 15:16:59 +0200 Vegard Nossum <vegard.nossum@gmail.com> wrote:

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 2 Jun 2008 08:57:45 +0200
> Subject: [PATCH] proc: calculate the correct /proc/<pid> link count
> 
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c

Linus gets upset when we refer to commits only by their hash.

I did this:

This patch:

  commit e9720acd728a46cb40daa52c99a979f7c4ff195c
  Author: Pavel Emelyanov <xemul@openvz.org>
  Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

introduced a /proc/self/net directory without bumping the corresponding
link count for /proc/self.

> introduced a
> /proc/self/net directory without bumping the corresponding link count
> for /proc/self.
> 
> This patch replaces the static link count initializations with a call
> that counts the number of directory entries in the given pid_entry
> table whenever it is instantiated, and thus relieves the burden of
> manually keeping the two in sync.

Seems much saner.

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c447e07..334ce46 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -127,6 +127,23 @@ struct pid_entry {
>  		NULL, &proc_single_file_operations,	\
>  		{ .proc_show = &proc_##OTYPE } )
>  
> +/* Count the number of hardlinks for the pid_entry table, excluding the .
> + * and .. links. */

Like this:

/*
 * Count the number of hardlinks for the pid_entry table, excluding the .
 * and .. links.
 */

please.

> +static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
> +	unsigned int n)
> +{
> +	unsigned int i;
> +	unsigned int count;
> +
> +	count = 0;
> +	for (i = 0; i < n; ++i) {
> +		if (S_ISDIR(entries[i].mode))
> +			++count;
> +	}
> +
> +	return count;
> +}

I'm unable to correlate the code with the comment.  There is nothing in
here which handles .  and ..?

 
> @@ -2585,10 +2602,9 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
>  	inode->i_op = &proc_tgid_base_inode_operations;
>  	inode->i_fop = &proc_tgid_base_operations;
>  	inode->i_flags|=S_IMMUTABLE;
> -	inode->i_nlink = 5;
> -#ifdef CONFIG_SECURITY
> -	inode->i_nlink += 1;
> -#endif
> +
> +	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
> +		ARRAY_SIZE(tgid_base_stuff));
>  

oh, can we do that?  Is it possible for some code somewhere to come
along and add a new entry to /proc/pid which doesn't appear in
these static tables?

I guess that doesn't happen.  In which case can we not calculate the
unmber of directories in these two tables just a single time, at
bootup?

I think I'm missing things here...
