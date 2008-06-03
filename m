Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYFCKs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYFCKs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYFCKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:48:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44664 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYFCKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:48:17 -0400
Date: Tue, 3 Jun 2008 11:48:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jesper@krogh.cc, raven@themaw.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603104814.GU28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk> <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <E1K3Ttv-0005ji-Cx@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K3Ttv-0005ji-Cx@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:37:59PM +0200, Miklos Szeredi wrote:
> > http://www.kerneloops.org/raw.php?rawid=12419&msgid=
> > 
> > Looks like a negative inode in S_ISDIR(mnt->mnt_root->d_inode->i_mode),
> > which would be due to NFS not properly filling in its root dentry?
> 
> On second thought it's S_ISDIR(path->dentry->d_inode->i_mode), which
> means it's an autofs thing.

It is path->dentry, all right, but the question is how'd it get that way.
Look: we got that nd.path.dentry out of path_lookup() with LOOKUP_FOLLOW
as flags.  Then we'd passed it through do_new_mount() to do_add_mount()
without changes.  And went through
        /* Something was mounted here while we slept */
        while (d_mountpoint(nd->path.dentry) &&
               follow_down(&nd->path.mnt, &nd->path.dentry))
                ;
