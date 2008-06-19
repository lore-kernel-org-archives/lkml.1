Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYFSWWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYFSWWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYFSWWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:22:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64944 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbYFSWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:22:11 -0400
Date: Thu, 19 Jun 2008 15:16:05 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making
	rmdir() fail
Message-ID: <20080619221605.GE10888@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
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

On Tue, Jun 17, 2008 at 07:37:23PM +0200, Louis Rilling wrote:

	Ok, I can see some of why I hated this.

> +
>  		spin_lock(&configfs_dirent_lock);
> -		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
> -			spin_unlock(&configfs_dirent_lock);
> -			config_item_put(item);
> -			kfree(sl);
> -			return -EPERM;
> -		}
> -		list_add(&sl->sl_list, &target_sd->s_links);
> +		/*
> +		 * Force rmdir() of parent_item to wait until we know if we
> +		 * succeed.
> +		 */
> +		parent_sd->s_type |= CONFIGFS_USET_ATTACHING;
>  		spin_unlock(&configfs_dirent_lock);
> +
>  		ret = configfs_create_link(sl, parent_item->ci_dentry,
>  					   dentry);
> -		if (ret) {
> -			spin_lock(&configfs_dirent_lock);
> -			list_del_init(&sl->sl_list);
> +
> +		spin_lock(&configfs_dirent_lock);
> +		parent_sd->s_type &= ~CONFIGFS_USET_ATTACHING;
> +
> +		if (ret || target_sd->s_type & CONFIGFS_USET_DROPPING) {

	Use parenthesis.  Actually, separate out the error cases.

> +			struct configfs_dirent *sd = NULL;
> +
> +			if (!ret) {
> +				sd = dentry->d_fsdata;
> +				list_del_init(&sd->s_sibling);
> +			}
>  			spin_unlock(&configfs_dirent_lock);
> +
> +			if (!ret) {
> +				configfs_drop_dentry(sd, dentry->d_parent);
> +				d_delete(dentry);
> +				configfs_put(sd);
> +			}

	This open-code of the VFS munging is ripe to break when the VFS
changes or other configfs changes happen.  The real issue is that you
are reimplementing the core of configfs_unlink().  Note how the core VFS
munging of configfs_rmdir() is separated out so that configfs_mkdir()
can also use it in the failure case?  Do the same with unlink() and it
will read much better ("if (DROPPING) configfs_delete_link()").  Call it
configfs_remove_link() or configfs_delete_link().

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
