Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYFCKku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYFCKku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYFCKkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:40:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44467 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYFCKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:40:38 -0400
Date: Tue, 3 Jun 2008 11:40:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jesper@krogh.cc, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603104035.GT28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk> <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:13:54PM +0200, Miklos Szeredi wrote:
> 
> http://www.kerneloops.org/raw.php?rawid=12419&msgid=
> 
> Looks like a negative inode in S_ISDIR(mnt->mnt_root->d_inode->i_mode),
> which would be due to NFS not properly filling in its root dentry?

Look more carefully.  It's path->dentry; aside of the fact that dentry
pointer is fetched at offset 8 from one of the arguments (fits path->dentry,
too low for mnt->mnt_root), do_add_mount() itself has just done S_ISLNK
on the very same thing, so it'd die before getting to graft_tree().

No, it's either path_lookup() somehow returning a negative dentry in
do_mount() (which shouldn't be possible, unless it's some crap around
return_reval in __link_path_walk()) or it's follow_down() giving us
a negative dentry.  Which almost certainly would've exploded prior to
that...
