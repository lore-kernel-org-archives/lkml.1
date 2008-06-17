Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbYFQWVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbYFQWVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYFQWVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:21:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37737 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYFQWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:21:31 -0400
Date: Tue, 17 Jun 2008 15:17:13 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 1/3] configfs: Fix symlink() to a removing item
Message-ID: <20080617221713.GB29091@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-2-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213724243-29183-2-git-send-email-louis.rilling@kerlabs.com>
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

On Tue, Jun 17, 2008 at 07:37:21PM +0200, Louis Rilling wrote:
> This patch makes configfs_symlink() fail whenever the target is being removed,
> using the CONFIGFS_USET_DROPPING flag set by configfs_detach_prep() and
> protected by configfs_dirent_lock.
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index faeb441..58722a9 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -78,6 +78,12 @@ static int create_link(struct config_item *parent_item,
>  	if (sl) {
>  		sl->sl_target = config_item_get(item);
>  		spin_lock(&configfs_dirent_lock);
> +		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
> +			spin_unlock(&configfs_dirent_lock);
> +			config_item_put(item);
> +			kfree(sl);
> +			return -EPERM;

	This needs to be -ENOENT.  If rmdir set DROPPING and then
released dirent_lock, it's going to remove the target.  That's ENOENT.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
