Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYCZWkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYCZWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYCZWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:39:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47544 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYCZWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:39:57 -0400
Date: Wed, 26 Mar 2008 22:39:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] vfs: mountinfo: add mount peer group ID
Message-ID: <20080326223949.GU10722@ZenIV.linux.org.uk>
References: <20080326211131.705321084@szeredi.hu> <20080326212140.382840664@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326212140.382840664@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:11:35PM +0100, Miklos Szeredi wrote:
> +static int mnt_alloc_group_id(struct vfsmount *mnt)
> +{
> +	int res;
> +
> +	WARN_ON(mnt->mnt_group_id != 0);
> + retry:
> +	res = ida_get_new_above(&mnt_group_ida, 1, &mnt->mnt_group_id);
> +	if (res == -EAGAIN) {
> +		if (ida_pre_get(&mnt_group_ida, GFP_KERNEL))
> +			goto retry;
> +		res = -ENOMEM;
> +	}
> +	return res;
> +}
> +

Same comment on goto retry

> +/*
> + * Release a peer group ID
> + */
> +void mnt_release_group_id(struct vfsmount *mnt)
> +{
> +	ida_remove(&mnt_group_ida, mnt->mnt_group_id);
> +	mnt->mnt_group_id = 0;
> +}

Erm...  What if that sucker has zero group ID to start with?  You
do call it that way later.

> +static void cleanup_group_ids(struct vfsmount *mnt, struct vfsmount *end)
> +{
> +	struct vfsmount *p;
> +
> +	for (p = mnt; p != end; p = next_mnt(p, mnt)) {
> +		if (list_empty(&p->mnt_share) && !IS_MNT_SHARED(p))
> +			mnt_release_group_id(p);
> +	}
> +}

I'd make that p->mnt_group_id && !IS_MNT_SHARED(p), actually...

> +static int invent_group_ids(struct vfsmount *mnt, bool recurse)
> +{
> +	struct vfsmount *p;
> +
> +	for (p = mnt; p; p = recurse ? next_mnt(p, mnt) : NULL) {
> +		if (list_empty(&p->mnt_share) && !IS_MNT_SHARED(p)) {
> +			int err = mnt_alloc_group_id(p);
> +			if (err) {
> +				cleanup_group_ids(mnt, p);
> +				return err;
> +			}
> +		}
> +	}

Same comment

> @@ -58,9 +62,9 @@ static int do_make_slave(struct vfsmount
>  		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
>  		INIT_LIST_HEAD(&mnt->mnt_slave_list);
>  	} else {
> -		struct list_head *p = &mnt->mnt_slave_list;
> -		while (!list_empty(p)) {
> -                        slave_mnt = list_first_entry(p,
> +		struct list_head *slaves = &mnt->mnt_slave_list;
> +		while (!list_empty(slaves)) {
> +                        slave_mnt = list_first_entry(slaves,
>  					struct vfsmount, mnt_slave);
>  			list_del_init(&slave_mnt->mnt_slave);
>  			slave_mnt->mnt_master = NULL;

What is that renaming doing here?
