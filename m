Return-Path: <linux-kernel-owner+w=401wt.eu-S1762740AbZJONVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762740AbZJONVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbZJONVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:21:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51858 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362AbZJONVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:21:22 -0400
Date: Thu, 15 Oct 2009 07:20:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
Message-ID: <20091015132044.GL7545@parisc-linux.org>
References: <20091015044026.319860788@suse.de> <20091015050048.165912589@suse.de> <4AD6D2E3.9050105@gmail.com> <20091015081343.GC4262@wotan.suse.de> <20091015082903.GD4262@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015082903.GD4262@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 10:29:03AM +0200, Nick Piggin wrote:
> On Thu, Oct 15, 2009 at 10:13:43AM +0200, Nick Piggin wrote:
> > Now both sockets and pipes define a d_dname so they are OK, but anon_inodes
> > does not. I think they should probably be made to just provide a d_dname
> > anyway so we can have the familiar format of "pseudofs:[ino]" rather than
> > "[pseudofs]" that we have now.
> > 
> > That should make this patch work for anon_inodes.c as well.
> 
> So what if we were to do this first? Are there any other reasons I've
> missed? (btw. this changes the format the link if that is a problem.
> Probably if we're going to do this change, we should change things like
> [timerfd] to just timerfd while we're there to improve consistency
> further.
> --
> Pipe and socket pseudo filesystems report their file descriptor link
> paths as pipe:[ino] and socket:[ino]. anon_inodefs allows subsystems
> to specify a name, but it does not report an associated inode number.

I think that's because the inode number is always 0 -- there's just one
anonymous inode.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
