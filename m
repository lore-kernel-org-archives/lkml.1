Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXCEMke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXCEMke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXCEMke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:40:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:46689 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXCEMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:40:33 -0500
Date: Mon, 5 Mar 2007 13:41:53 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       bluez-devel@lists.sourceforge.net, marcel@holtmann.org,
       Andrew Morton <akpm@osdl.org>,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: Re: [PATCH] Fix 2.6.21 rfcomm lockups (2.6.21 regression)
Message-ID: <20070305134153.04f97fc0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <45EB0F69.5070002@rtr.ca>
References: <45EADD78.1030300@rtr.ca>
	<45EAE1D6.10900@rtr.ca>
	<45EB0814.5030306@rtr.ca>
	<45EB0F69.5070002@rtr.ca>
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Mar 2007 13:26:49 -0500,
Mark Lord <lkml@rtr.ca> wrote:

> The simplest fix for this bug is to prevent sysfs_move_dir()
> from self-deadlocking when (old_parent == new_parent).
> 
> This patch prevents total system lockup when using rfcomm devices.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- 2.6.21/fs/sysfs/dir.c	2007-03-04 13:19:00.000000000 -0500
> +++ linux/fs/sysfs/dir.c	2007-03-04 13:20:45.000000000 -0500
> @@ -431,6 +431,8 @@
>  	new_parent_dentry = new_parent ?
>  		new_parent->dentry : sysfs_mount->mnt_sb->s_root;
> 
> +	if (old_parent_dentry->d_inode == new_parent_dentry->d_inode)
> +		return 0;	/* nothing to move */
>  again:
>  	mutex_lock(&old_parent_dentry->d_inode->i_mutex);
>  	if (!mutex_trylock(&new_parent_dentry->d_inode->i_mutex)) {

Hm, never thought that someone might call the moving functions with
old_parent == new_parent, sorry about that. It should be safe to
return success here, we add only a bit of overhead with some driver
model juggling and emitting a not needed uevent.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
