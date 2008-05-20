Return-Path: <linux-kernel-owner+w=401wt.eu-S935044AbYETQAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbYETQAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934916AbYETP71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:59:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36003 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907AbYETP7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:59:23 -0400
Date: Tue, 20 May 2008 08:58:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-Id: <20080520085831.53a85f90.randy.dunlap@oracle.com>
In-Reply-To: <20080520152843.CF4181B4205@basil.firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
	<20080520152843.CF4181B4205@basil.firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 17:28:43 +0200 (CEST) Andi Kleen wrote:

> 
> Add a new fops entry point to allow fasync without BKL. While it's arguably
> unclear this entry point is called often enough for it really matters
> it was still relatively easy to do. And there are far less async users
> in the tree than ioctls so it's likely they can be all converted 
> eventually and then the non unlocked async entry point could be dropped.
> 
> There was still the problem of the actual flags change being
> protected against other setters of flags. Instead of using BKL
> for this use the i_mutex now.
> 
> I also added a mutex_lock against one other flags change
> that was lockless and could potentially lose updates.
> 
> There are a couple of potential problems I added comments about on.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  Documentation/filesystems/vfs.txt |    5 ++++-
>  fs/fcntl.c                        |   22 +++++++++++++++-------
>  fs/ioctl.c                        |   13 ++++++++++++-
>  include/linux/fs.h                |    1 +
>  4 files changed, 32 insertions(+), 9 deletions(-)

> Index: linux/Documentation/filesystems/vfs.txt
> ===================================================================
> --- linux.orig/Documentation/filesystems/vfs.txt
> +++ linux/Documentation/filesystems/vfs.txt
> @@ -755,6 +755,7 @@ struct file_operations {
>  	int (*fsync) (struct file *, struct dentry *, int datasync);
>  	int (*aio_fsync) (struct kiocb *, int datasync);
>  	int (*fasync) (int, struct file *, int);
> +	int (*unlocked_fasync) (int, struct file *, int);
>  	int (*lock) (struct file *, int, struct file_lock *);
>  	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
>  	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
> @@ -814,7 +815,9 @@ otherwise noted.
>    fsync: called by the fsync(2) system call
>  
>    fasync: called by the fcntl(2) system call when asynchronous
> -	(non-blocking) mode is enabled for a file
> +	(non-blocking) mode is enabled for a file. BKL hold

	                                           BKL held.
so is that BKL must be held by the caller or this function
holds the BKL?

> +
> +  unlocked_fasync: like fasync, but without BKL
>  
>    lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
>    	commands


---
~Randy
