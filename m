Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbYDXTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbYDXTmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763147AbYDXTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:41:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49234 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761435AbYDXTls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:41:48 -0400
Date: Thu, 24 Apr 2008 15:40:03 -0400
Message-Id: <200804241940.m3OJe32l030977@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 19:13:32 BST."
             <20080424181332.GB5882@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424181332.GB5882@ZenIV.linux.org.uk>, Al Viro writes:
> On Thu, Apr 24, 2008 at 01:29:49PM -0400, Erez Zadok wrote:
> > In message <20080424142857.GF15214@ZenIV.linux.org.uk>, Al Viro writes:
> > > On Thu, Apr 24, 2008 at 04:09:18PM +0200, Miklos Szeredi wrote:
> > [...]
> > > FWIW, I'm not all that happy about the way ecryptfs_interpose() is done,
> > > while we are at it.  We get the sucker opened by whoever steps on given
> > > place in the tree first, with subsequent operations done using the resulting
> > > struct file.  With fallback to r/o open.  What happens to somebody who
> > > tries to open it with enough permissions to do r/w?
> > 
> > Yes, ecryptfs_interpose() calls ecryptfs_init_persistent_file() which calls
> > dentry_open(O_RDWR).  What's the proposed solution for this in the face of
> > r/o vfsmounts?  How could ecryptfs avoid calling this dentry_open in the
> > first place?
> 
> Doesn't have anything to do with vfsmounts (you have one to deal with and
> if it's r/o, it's equivalent to just doing the entire thing on top of r/o
> fs; not interesting).
> 
> No, what I'm worried about is much simpler.  Look: we have a file on
> underlying fs, owned by root.root with 644 for permissions.  Comes a
> luser and tries to open the counterpart of that file in ecryptfs; that
> triggers ecryptfs_interpose() and attempts to open file.  Of course,
> that's going to fail - it's not world-writable.  So then it (actually
> ecryptfs_init_persistent_file()) falls back to opening with O_RDONLY.
> Which succeeds just fine and file (opened r/o) is set as ->lower_file.
> 
> Now comes root and tries to open the damn thing r/w.  It should be able
> to and if it came first it'd get it; as it is, what it gets is ->lower_file
> and that puppy is opened read-only and you have no guarantee that underlying
> fs will not go bonkers seeing write attempts on it (e.g. open for write
> doing a bit more setup of ->private_data, etc.).

Ah, I see.  Yes: ecryptfs_init_persistent_file does have this odd "try to
open readwrite and if that failed, try readonly" code there.  I can't really
say why it's done that way: Mike?  Maybe it was a workaround to not having
the right permissions to open that persistent file?

This could be a similar issue to how I had to handle the .wh.* files in
unionfs.  Because they are separate files, and they get created/destroyed
directly by unionfs, I cannot rely on the caller's capabilities to be able
to create/remove these .wh.* files.  So in several places I have to call
cap_raise temporarily.  (Of course, if/when there'd be native whiteout
support in the most most common file systems, I could happily rip out this
whiteout code. :-)

Erez.
