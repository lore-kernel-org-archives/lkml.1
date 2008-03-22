Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYCVQ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYCVQ1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYCVQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:27:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32869 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYCVQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:27:34 -0400
Date: Sat, 22 Mar 2008 16:27:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080322162700.GC10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 07:37:51PM +0100, Miklos Szeredi wrote:
> set_mnt_shared() is called from namespace.c as well, without
> vfsmount_lock.  But agreed, that's not the real issue.

How about the following: let's separate set_mnt_shared() and inventing
group ids.  All we need is this:
invent_group_ids(mnt)	/* call under namespace_sem */
	for all vfsmounts p in subtree rooted at mnt
		if p->mnt_share is non-empty
			continue
		get ID for p
		if allocation fails
			goto cleanup
	return 0
cleanup:
	for all vfsmounts q in subtree rooted at mnt
		if q == p
			break
		if q->mnt_share is non-empty
			continue
		release ID of q
	return -ENOMEM

Now here's what we do:
	* in do_change_type(), outside of vfsmount_lock, do invent_group_ids()
If it fails - bugger off, if not - proceed as now.
	* in attach_recursive_mnt() if IS_MNT_SHARED(dest_mnt) do
invent_group_ids() on the dest_mnt immediately and if it fails do
umount_tree(dest_mnt, 0, ) under vfsmount_lock, then release_mounts()
and bugger off (FWIW, we might want to lift the last part to caller
and do the same to release_mounts() in propagate_mnt()).  If it hadn't
failed, we proceed as now.
	* in clone_mnt() do
	int new_group = group ID of old;
	int free_group = 0;
	if (flag & (CL_SLAVE | CL_PRIVATE))
		new_group = 0; /* not a peer of original */
	if ((flag & CL_MAKE_SHARED) && !new_group)
		new_group = allocate new ID
		if failed
			return 0;
		free_group = 1;
	}
	mnt = alloc_vfsmount();
	if (mnt) {
		set group ID of mnt to new_group;
		free_group = 0;
		/* as in mainline */
	}
	if (free_group)
		release group ID found in new_group;
	return mnt;

then (after allocating new vfsmount) set its group ID to new_group if
alloc_vfsmount() succeeds.  Otherwise release group ID if needed and
bugger off as usual.

No need to mess with any additional exclusion for idr protection or with
any kind of retries; allocation failure is allocation failure.

Releasing group ID should be done from do_make_slave(), along with clearing
group ID in vfsmount.

Care to do that using mountinfo-base in vfs-2.6.git as base tree?
