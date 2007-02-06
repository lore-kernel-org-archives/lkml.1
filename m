Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbXBFIwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbXBFIwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXBFIwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:52:01 -0500
Received: from pat.uio.no ([129.240.10.15]:59804 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbXBFIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:51:59 -0500
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <200702051920.36057.agruen@suse.de>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	 <1170701906.5934.41.camel@lade.trondhjem.org>
	 <20070205190230.GA23104@infradead.org>  <200702051920.36057.agruen@suse.de>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 00:51:52 -0800
Message-Id: <1170751912.6242.30.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 12470DEB67EC577D0EF1F62F82E5830E8DB1347F
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1658 total 278179 max/h 2716 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 19:20 -0800, Andreas Gruenbacher wrote:
> On Monday 05 February 2007 11:02, Christoph Hellwig wrote:
> > On Mon, Feb 05, 2007 at 10:58:26AM -0800, Trond Myklebust wrote:
> > > On Mon, 2007-02-05 at 18:44 +0000, Christoph Hellwig wrote:
> > > > Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> > > > the vfs_ helpers, so you should discuss this with him.
> > > >
> > > > Looking at the actual patches I see you're lazy in a lot of places.
> > > > Please make sure that when you introduce a vfsmount argument somewhere
> > > > that it is _always_ passed and not just when it's conveniant.  Yes,
> > > > that's more work, but then again if you're not consistant anyone
> > > > half-serious will laught at a security model using this infrasturcture.
> > >
> > > nfsd in particular tends to be a bit lazy about passing around vfsmount
> > > info. Forcing it to do so should not be hard since the vfsmount is
> > > already cached in the "struct export" (which can be found using the
> > > filehandle). It will take a bit of re-engineering in order to pass that
> > > information around inside the nfsd code, though.
> >
> > I actually have a patch to fix that.  It's part of a bigger series
> > that's not quite ready, but I hope to finish all of it this month.
> 
> It's actually not hard to "fix", and nfsd would look a little less weird. But 
> what would this add, what do pathnames mean in the context of nfsd, and would 
> nfsd actually become less weird?
> 
> On the wire, nfs transmits file handles, not filenames. The file handle 
> usually contains the inode numbers of the file and the containing directory.
> 
> The code in fs/exportfs/expfs.c:find_exported_dentry() shows that fh_verify() 
> should return a dentry that may be connected or not, depending on the export 
> options and whether it's a file or directory. Together with the vfsmount from 
> the svc_export, we could compute a pathname.
> 
> But there is no way to tell different hardlinks to the same inode in the same 
> directory from each other (both the file and directory inode are the same), 
> and depending on the export options, we may or may not be able to distinguish 
> different hardlinks across directories.

Who cares? There is no way to export a partial directory, and in any
case the subtree_check crap is borken beyond repair (see cross-directory
renames which lead to actual changes to the filehandle - broken, broken,
broken!!!!).

> If the nohide or crossmnt export options are used, we might run into similar 
> aliasing issues with mounts (I'm not sure about this).

Wrong. Those create new export points since you are crossing into a
different filesystem.

> So we could compute pathnames, but they wouldn't be very meaningful. Instead 
> of going that way, it seems more reasonable to not do pathname based access 
> control for the kernel kernel nfsd at all. Passing NULL as the vfsmounts does 
> that. With a properly configured nfsd, the areas that remote users could 
> access would still be well confined.

Huh? Even if you don't pass in a vfsmount, you _still_ need to pass in a
super_block. Inodes are only unique per filesystem.
In fact, on an ideal NFS export, there is no ambiguity between the two
(see above comment about subtree_check) since the entire filesystem will
be exported.

> The focus with this whole pathname based security stuff really is to be able 
> to better confine local processes. The kernel nfsd is a kernel thread, and as 
> such, confining it from a security point of view cannot really work, anyway.
> 
> > > Note also that it might be nice to enforce the vfsmount argument by
> > > replacing the existing dentry parameters with a struct path instead of
> > > adding an extra reference to the vfsmount to existing functions.
> >
> > That definitly sounds like a good idea, independent of whether we want
> > to pass the vfsmount in more places or not.
> 
> Note that you can still pass a NULL vfsmount in a struct path.

...but we will have Dick Cheney track you down and shoot you if you do.
The point is that you only have to check _one_ argument (the
initialisation of the struct path) instead of having a check for every
function argument in the vfs.

Trond

