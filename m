Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbXBFDVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbXBFDVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965281AbXBFDVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:21:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXBFDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:21:04 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Mon, 5 Feb 2007 19:20:35 -0800
User-Agent: KMail/1.9.5
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <1170701906.5934.41.camel@lade.trondhjem.org> <20070205190230.GA23104@infradead.org>
In-Reply-To: <20070205190230.GA23104@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051920.36057.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 11:02, Christoph Hellwig wrote:
> On Mon, Feb 05, 2007 at 10:58:26AM -0800, Trond Myklebust wrote:
> > On Mon, 2007-02-05 at 18:44 +0000, Christoph Hellwig wrote:
> > > Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> > > the vfs_ helpers, so you should discuss this with him.
> > >
> > > Looking at the actual patches I see you're lazy in a lot of places.
> > > Please make sure that when you introduce a vfsmount argument somewhere
> > > that it is _always_ passed and not just when it's conveniant.  Yes,
> > > that's more work, but then again if you're not consistant anyone
> > > half-serious will laught at a security model using this infrasturcture.
> >
> > nfsd in particular tends to be a bit lazy about passing around vfsmount
> > info. Forcing it to do so should not be hard since the vfsmount is
> > already cached in the "struct export" (which can be found using the
> > filehandle). It will take a bit of re-engineering in order to pass that
> > information around inside the nfsd code, though.
>
> I actually have a patch to fix that.  It's part of a bigger series
> that's not quite ready, but I hope to finish all of it this month.

It's actually not hard to "fix", and nfsd would look a little less weird. But 
what would this add, what do pathnames mean in the context of nfsd, and would 
nfsd actually become less weird?

On the wire, nfs transmits file handles, not filenames. The file handle 
usually contains the inode numbers of the file and the containing directory.

The code in fs/exportfs/expfs.c:find_exported_dentry() shows that fh_verify() 
should return a dentry that may be connected or not, depending on the export 
options and whether it's a file or directory. Together with the vfsmount from 
the svc_export, we could compute a pathname.

But there is no way to tell different hardlinks to the same inode in the same 
directory from each other (both the file and directory inode are the same), 
and depending on the export options, we may or may not be able to distinguish 
different hardlinks across directories.

If the nohide or crossmnt export options are used, we might run into similar 
aliasing issues with mounts (I'm not sure about this).

So we could compute pathnames, but they wouldn't be very meaningful. Instead 
of going that way, it seems more reasonable to not do pathname based access 
control for the kernel kernel nfsd at all. Passing NULL as the vfsmounts does 
that. With a properly configured nfsd, the areas that remote users could 
access would still be well confined.

The focus with this whole pathname based security stuff really is to be able 
to better confine local processes. The kernel nfsd is a kernel thread, and as 
such, confining it from a security point of view cannot really work, anyway.

> > Note also that it might be nice to enforce the vfsmount argument by
> > replacing the existing dentry parameters with a struct path instead of
> > adding an extra reference to the vfsmount to existing functions.
>
> That definitly sounds like a good idea, independent of whether we want
> to pass the vfsmount in more places or not.

Note that you can still pass a NULL vfsmount in a struct path.

Thanks,
Andreas
