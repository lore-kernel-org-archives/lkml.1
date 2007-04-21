Return-Path: <linux-kernel-owner+w=401wt.eu-S1031251AbXDUOUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031251AbXDUOUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031249AbXDUOUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:20:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48591 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634AbXDUOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:20:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 8/8] allow unprivileged fuse mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102656.364689151@szeredi.hu>
Date: Sat, 21 Apr 2007 08:18:47 -0600
In-Reply-To: <20070420102656.364689151@szeredi.hu> (Miklos Szeredi's message
	of "Fri, 20 Apr 2007 12:25:40 +0200")
Message-ID: <m17is5kdyw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
>
> FUSE was designed from the beginning to be safe for unprivileged
> users.  This has also been verified in practice over many years.  In
> addition unprivileged mounts require the parent mount to be owned by
> the user, which is more strict than the current userspace policy.
>
> This will enable future installations to remove the suid-root
> fusermount utility.
>
> Don't require the "user_id=" and "group_id=" options for unprivileged
> mounts, but if they are present, verify them for sanity.
>
> Disallow the "allow_other" option for unprivileged mounts.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>
> Index: linux/fs/fuse/inode.c
> ===================================================================
> --- linux.orig/fs/fuse/inode.c	2007-04-20 11:55:01.000000000 +0200
> +++ linux/fs/fuse/inode.c	2007-04-20 11:55:14.000000000 +0200
> @@ -311,6 +311,19 @@ static int parse_fuse_opt(char *opt, str
>  	d->max_read = ~0;
>  	d->blksize = 512;
>  
> +	/*
> +	 * For unprivileged mounts use current uid/gid.  Still allow
> +	 * "user_id" and "group_id" options for compatibility, but
> +	 * only if they match these values.
> +	 */
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		d->user_id = current->uid;
> +		d->user_id_present = 1;
> +		d->group_id = current->gid;
> +		d->group_id_present = 1;
> +
> +	}

CAP_SETUID is the appropriate capability...

This is not a dimension we have not fully explored.
What is the problem with a user controlled mount having different
uid and gid values.

Yes they map into different users but how is this a problem.
The only problem that I can recall is the historic chown problem
where you could give files to other users and mess up their quotas.

Or is the problem other users writing to this user controlled
filesystem?

Eric
