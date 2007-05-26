Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbXEZCX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbXEZCX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 22:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXEZCXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 22:23:48 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56067 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXEZCXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 22:23:47 -0400
Date: Fri, 25 May 2007 22:23:42 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
Message-ID: <20070526022342.GA20905@fieldses.org>
References: <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 05:55:54PM +0100, David Howells wrote:
> +/*
> + * initialise the lock manager thread if it isn't already running
> + */
> +static int afs_init_lock_manager(void)
> +{
> +	if (!afs_lock_manager) {
> +		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
> +		if (!afs_lock_manager)
> +			return -ENOMEM;
> +	}
> +	return 0;

Doesn't this need some locking?

> +/*
> + * request a lock on a file on the server
> + */
> +static int afs_do_setlk(struct file *file, struct file_lock *fl)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(file->f_mapping->host);
> +	afs_lock_type_t type;
> +	struct key *key = file->private_data;
> +	int ret;
> +
> +	_enter("{%x:%u},%u", vnode->fid.vid, vnode->fid.vnode, fl->fl_type);
> +
> +	/* only whole-file locks are supported */
> +	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
> +		return -EINVAL;

Do you allow upgrades and downgrades?  (Just curious.)

> +		/* if we've already got a readlock on the server and no waiting
> +		 * writelocks, then we might be able to instantly grant another

Is that comment correct?  (You don't really test for "waiting
writelocks", do you?)

> +		 * readlock */
> +		if (type == AFS_LOCK_READ &&
> +		    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
> +			_debug("instant readlock");
> +			ASSERTCMP(vnode->flags &
> +				  ((1 << AFS_VNODE_LOCKING) |
> +				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
> +			ASSERT(!list_empty(&vnode->granted_locks));
> +			goto sharing_existing_lock;
> +		}
> +	}

--b.
