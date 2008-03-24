Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYCXITj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYCXITj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYCXIT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:19:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43294 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYCXIT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:19:27 -0400
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
From: Ram Pai <linuxram@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080322162700.GC10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu>
	 <20080313212735.741834181@szeredi.hu>
	 <20080319114844.GK10722@ZenIV.linux.org.uk>
	 <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
	 <20080319182005.GP10722@ZenIV.linux.org.uk>
	 <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
	 <20080322162700.GC10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 01:19:41 -0700
Message-Id: <1206346782.2961.16.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 16:27 +0000, Al Viro wrote:
> On Wed, Mar 19, 2008 at 07:37:51PM +0100, Miklos Szeredi wrote:
> > set_mnt_shared() is called from namespace.c as well, without
> > vfsmount_lock.  But agreed, that's not the real issue.
> 
> How about the following: let's separate set_mnt_shared() and inventing
> group ids.  All we need is this:
> invent_group_ids(mnt)	/* call under namespace_sem */
> 	for all vfsmounts p in subtree rooted at mnt
> 		if p->mnt_share is non-empty
> 			continue
> 		get ID for p
> 		if allocation fails
> 			goto cleanup
> 	return 0
> cleanup:
> 	for all vfsmounts q in subtree rooted at mnt
> 		if q == p
> 			break
> 		if q->mnt_share is non-empty
> 			continue
> 		release ID of q
> 	return -ENOMEM
> 
> Now here's what we do:
> 	* in do_change_type(), outside of vfsmount_lock, do invent_group_ids()
> If it fails - bugger off, if not - proceed as now.

Has it to be done outside vfsmount_lock?  AFAICT, invent_group_ids()
does not sleep, nor does change_mnt_propagation().

> 	* in attach_recursive_mnt() if IS_MNT_SHARED(dest_mnt) do
> invent_group_ids() on the dest_mnt immediately and if it fails do

I think you meant, invent_group_ids() on the source_mnt.  But again
applying invent_group_ids() on the source_mnt has to be done carefully,
because, source_mnt may have been shared to begin with.

right?
RP

> umount_tree(dest_mnt, 0, ) under vfsmount_lock, then release_mounts()
> and bugger off (FWIW, we might want to lift the last part to caller
> and do the same to release_mounts() in propagate_mnt()).  If it hadn't
> failed, we proceed as now.
> 	* in clone_mnt() do
> 	int new_group = group ID of old;
> 	int free_group = 0;
> 	if (flag & (CL_SLAVE | CL_PRIVATE))
> 		new_group = 0; /* not a peer of original */
> 	if ((flag & CL_MAKE_SHARED) && !new_group)
> 		new_group = allocate new ID
> 		if failed
> 			return 0;
> 		free_group = 1;
> 	}
> 	mnt = alloc_vfsmount();
> 	if (mnt) {
> 		set group ID of mnt to new_group;
> 		free_group = 0;
> 		/* as in mainline */
> 	}
> 	if (free_group)
> 		release group ID found in new_group;
> 	return mnt;
> 
> then (after allocating new vfsmount) set its group ID to new_group if
> alloc_vfsmount() succeeds.  Otherwise release group ID if needed and
> bugger off as usual.
> 
> No need to mess with any additional exclusion for idr protection or with
> any kind of retries; allocation failure is allocation failure.
> 
> Releasing group ID should be done from do_make_slave(), along with clearing
> group ID in vfsmount.
> 
> Care to do that using mountinfo-base in vfs-2.6.git as base tree?

