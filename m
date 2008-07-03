Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYGCWII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYGCWII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYGCWH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:07:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27993 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYGCWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:07:55 -0400
Date: Thu, 3 Jul 2008 15:06:58 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUGFIX][PATCH 2/2] configfs: Lock new directory
	inodes before removing on cleanup after failure
Message-ID: <20080703220658.GH1502@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com> <1214503549-15678-3-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214503549-15678-3-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:05:49PM +0200, Louis Rilling wrote:
> Once a new configfs directory is created by configfs_attach_item() or
> configfs_attach_group(), a failure in the remaining initialization steps leads
> to removing a directory which inode the VFS may have already accessed.
> 
> This commit adds the necessary inode locking to safely remove configfs
> directories while cleaning up after a failure. As an advantage, the locking
> rules of populate_groups() and detach_groups() become the same: the caller must
> have the group's inode mutex locked.

	I like this latter symmetry.

>  static void configfs_remove_dir(struct config_item * item)
> @@ -594,36 +596,20 @@ static int create_default_group(struct config_group *parent_group,
>  static int populate_groups(struct config_group *group)
>  {
>  	struct config_group *new_group;
> -	struct dentry *dentry = group->cg_item.ci_dentry;
>  	int ret = 0;
>  	int i;
>  
> -	if (group->default_groups) {
> -		/*
> -		 * FYI, we're faking mkdir here
> -		 * I'm not sure we need this semaphore, as we're called
> -		 * from our parent's mkdir.  That holds our parent's
> -		 * i_mutex, so afaik lookup cannot continue through our
> -		 * parent to find us, let alone mess with our tree.
> -		 * That said, taking our i_mutex is closer to mkdir
> -		 * emulation, and shouldn't hurt.
> -		 */
> -		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
> -
> +	if (group->default_groups)

	Put the {} around this if.  It may only have the for() as a
child, but it's 10 lines.

>  		for (i = 0; group->default_groups[i]; i++) {
>  			new_group = group->default_groups[i];
>  
>  			ret = create_default_group(group, new_group);
> -			if (ret)
> +			if (ret) {
> +				detach_groups(group);
>  				break;
> +			}
>  		}
>  
<snip>  
> @@ -738,7 +724,14 @@ static int configfs_attach_item(struct config_item *parent_item,
>  	if (!ret) {
>  		ret = populate_attrs(item);
>  		if (ret) {
> +			/*
> +			 * We are going to remove an inode and its dentry but
> +			 * the VFS may already have hit and used them.
> +			 */
> +			mutex_lock(&dentry->d_inode->i_mutex);
>  			configfs_remove_dir(item);
> +			dentry->d_inode->i_flags |= S_DEAD;
> +			mutex_unlock(&dentry->d_inode->i_mutex);

	This emulates how rmdir() would lock it, which is quite nice.
Perhaps add to the comment "thus, we must lock them as rmdir() would".

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
