Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYCUI5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYCUI5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 04:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYCUI5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 04:57:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41099 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYCUI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 04:57:40 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
In-reply-to: <20080320214319.GS10722@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 20 Mar 2008 21:43:19 +0000)
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk>
Message-Id: <E1Jcd3y-0000gA-Nh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 09:57:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IOW, mark_mounts_for_expiry() should do the following:
> 	grabbing namespace_sem exclusive
> 	grab vfsmount_lock
> 	walk the list as it does now, except that it should do the right
> check from the very beginning (propagate_mount_busy())
> 	without dropping the vfsmount_lock, go through the collected list,
> calling umount_tree()
> 	drop the locks
> 	do release_mounts()
> The second pass is needed since umount_tree() might do interesting things
> to expiry list, so we make life easier for ourselves by leaving that to
> second pass when we just want to drain the resulting list until it's empty.
> 
> Does anybody see holes in the above?
> 
> shrink_submounts() is _probably_ similar (lock/collect/umount_tree on all/
> unlock/release_mounts), but I'm not sure if I understand WTF is really
> attempted in there.
> 
> Is there any reason why we do that in ->umount_begin() and not *after*
> it, unconditionally, straight from do_umount()?  AFAICS, the only reason
> why it's done from fs-specific code is figuring out which mount-list
> should the stuff go back to, and that's both broken *and* not needed
> with sanitized locking as above.  While we are at it, I'd rather return
> ->umount_begin() to its previous prototype, TYVM - the less filesystem
> sees vfsmounts, the better off we all are...

All of that seems sane to me.

Miklos
