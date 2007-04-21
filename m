Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXDUH4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXDUH4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXDUH4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:56:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965292AbXDUH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:15 -0400
Date: Sat, 21 Apr 2007 00:55:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 1/8] add user mounts to the kernel
Message-Id: <20070421005503.f3bbf1e5.akpm@linux-foundation.org>
In-Reply-To: <20070420102624.975879175@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
	<20070420102624.975879175@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:25:33 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add ownership information to mounts.
> 
> A new mount flag, MS_SETUSER is used to make a mount owned by a user.
> If this flag is specified, then the owner will be set to the current
> real user id and the mount will be marked with the MNT_USER flag.  On
> remount don't preserve previous owner, and treat MS_SETUSER as for a
> new mount.  The MS_SETUSER flag is ignored on mount move.

So is a modified mount(8) needed?  If so, is there some convenient way
in which testers can get hold of it?

> The MNT_USER flag is not copied on any kind of mount cloning:
> namespace creation, binding or propagation.  For bind mounts the
> cloned mount(s) are set to MNT_USER depending on the MS_SETUSER mount
> flag.  In all the other cases MNT_USER is always cleared.
> 
> For MNT_USER mounts a "user=UID" option is added to /proc/PID/mounts.
> This is compatible with how mount ownership is stored in /etc/mtab.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2007-04-20 11:55:02.000000000 +0200
> +++ linux/fs/namespace.c	2007-04-20 11:55:05.000000000 +0200
> @@ -227,6 +227,13 @@ static struct vfsmount *skip_mnt_tree(st
>  	return p;
>  }
>  
> +static void set_mnt_user(struct vfsmount *mnt)
> +{
> +	BUG_ON(mnt->mnt_flags & MNT_USER);
> +	mnt->mnt_uid = current->uid;
> +	mnt->mnt_flags |= MNT_USER;
> +}

I'm a bit surprised to see this.  Using uids in-kernel is all rather
old-fashioned and restricted. I'd have expected

	mnt->user = get_uid(current->user);



