Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXDUH6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXDUH6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030323AbXDUH43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:56:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030192AbXDUH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:24 -0400
Date: Sat, 21 Apr 2007 00:55:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 3/8] account user mounts
Message-Id: <20070421005509.cb5a6918.akpm@linux-foundation.org>
In-Reply-To: <20070420102631.544911966@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
	<20070420102631.544911966@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:25:35 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Add sysctl variables for accounting and limiting the number of user
> mounts.
> 
> The maximum number of user mounts is set to 1024 by default.  This
> won't in itself enable user mounts, setting a mount to be owned by a
> user is first needed
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/include/linux/sysctl.h
> ===================================================================
> --- linux.orig/include/linux/sysctl.h	2007-04-20 11:55:02.000000000 +0200
> +++ linux/include/linux/sysctl.h	2007-04-20 11:55:07.000000000 +0200
> @@ -818,6 +818,8 @@ enum
>  	FS_AIO_NR=18,	/* current system-wide number of aio requests */
>  	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
>  	FS_INOTIFY=20,	/* inotify submenu */
> +	FS_NR_USER_MOUNTS=21,	/* int:current number of user mounts */
> +	FS_MAX_USER_MOUNTS=22,	/* int:maximum number of user mounts */
>  	FS_OCFS2=988,	/* ocfs2 */

Is there a special reason why the enumerated sysctls are needed?  We're
trying to get away from using them.


diff -puN include/linux/sysctl.h~unprivileged-mounts-account-user-mounts-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~unprivileged-mounts-account-user-mounts-fix
+++ a/include/linux/sysctl.h
@@ -819,8 +819,6 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
-	FS_NR_USER_MOUNTS=21,	/* int:current number of user mounts */
-	FS_MAX_USER_MOUNTS=22,	/* int:maximum number of user mounts */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff -puN kernel/sysctl.c~unprivileged-mounts-account-user-mounts-fix kernel/sysctl.c
--- a/kernel/sysctl.c~unprivileged-mounts-account-user-mounts-fix
+++ a/kernel/sysctl.c
@@ -1028,7 +1028,7 @@ static ctl_table fs_table[] = {
 #endif	
 #endif
 	{
-		.ctl_name	= FS_NR_USER_MOUNTS,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_user_mounts",
 		.data		= &nr_user_mounts,
 		.maxlen		= sizeof(int),
@@ -1036,7 +1036,7 @@ static ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_MAX_USER_MOUNTS,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "max_user_mounts",
 		.data		= &max_user_mounts,
 		.maxlen		= sizeof(int),
_

