Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYFCKpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYFCKpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYFCKpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:45:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57072 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYFCKph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:45:37 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, jesper@krogh.cc, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080603104035.GT28946@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 3 Jun 2008 11:40:35 +0100)
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk> <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk>
Message-Id: <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jun 2008 12:45:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > http://www.kerneloops.org/raw.php?rawid=12419&msgid=
> > 
> > Looks like a negative inode in S_ISDIR(mnt->mnt_root->d_inode->i_mode),
> > which would be due to NFS not properly filling in its root dentry?
> 
> Look more carefully.  It's path->dentry; aside of the fact that dentry
> pointer is fetched at offset 8 from one of the arguments (fits path->dentry,
> too low for mnt->mnt_root),

Yup, realized this after posting.

> do_add_mount() itself has just done S_ISLNK
> on the very same thing, so it'd die before getting to graft_tree().
> 
> No, it's either path_lookup() somehow returning a negative dentry in
> do_mount() (which shouldn't be possible, unless it's some crap around
> return_reval in __link_path_walk()) or it's follow_down() giving us
> a negative dentry.  Which almost certainly would've exploded prior to
> that...

I think it must be autofs4 doing something weird.  Like this in
autofs4_lookup_unhashed():

			/*
			 * Make the rehashed dentry negative so the VFS
			 * behaves as it should.
			 */
			if (inode) {
				dentry->d_inode = NULL;


Miklos
