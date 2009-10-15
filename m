Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZJOJOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZJOJOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZJOJOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:14:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52540 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbZJOJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:14:31 -0400
Message-ID: <4AD6E7C9.5080001@gmail.com>
Date: Thu, 15 Oct 2009 11:13:45 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
References: <20091015044026.319860788@suse.de> <20091015050048.165912589@suse.de> <4AD6D2E3.9050105@gmail.com> <20091015081343.GC4262@wotan.suse.de> <20091015082903.GD4262@wotan.suse.de>
In-Reply-To: <20091015082903.GD4262@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 15 Oct 2009 11:13:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :

> So what if we were to do this first? Are there any other reasons I've
> missed? (btw. this changes the format the link if that is a problem.
> Probably if we're going to do this change, we should change things like
> [timerfd] to just timerfd while we're there to improve consistency
> further.
> --
> Pipe and socket pseudo filesystems report their file descriptor link
> paths as pipe:[ino] and socket:[ino]. anon_inodefs allows subsystems
> to specify a name, but it does not report an associated inode number.
> 
> Implement this with anon_inodefs_dname in the same way pipefs and sockfs
> are.
> 
> ---
>  fs/anon_inodes.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6/fs/anon_inodes.c
> ===================================================================
> --- linux-2.6.orig/fs/anon_inodes.c
> +++ linux-2.6/fs/anon_inodes.c
> @@ -45,6 +45,15 @@ static int anon_inodefs_delete_dentry(st
>  	return 1;
>  }
>  
> +/*
> + * anon_inodefs_dname() is called from d_path().
> + */
> +static char *anon_inodefs_dname(struct dentry *dentry, char *buffer, int buflen)
> +{
> +	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
> +				dentry->d_name.name, dentry->d_inode->i_ino);
> +}
> +
>  static struct file_system_type anon_inode_fs_type = {
>  	.name		= "anon_inodefs",
>  	.get_sb		= anon_inodefs_get_sb,
> @@ -52,6 +61,7 @@ static struct file_system_type anon_inod
>  };
>  static const struct dentry_operations anon_inodefs_dentry_operations = {
>  	.d_delete	= anon_inodefs_delete_dentry,
> +	.d_dname	= anon_inodefs_dname,
>  };
>  
>  /*

Yes, that would be fine, thanks Nick.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

