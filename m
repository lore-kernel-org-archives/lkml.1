Return-Path: <linux-kernel-owner+w=401wt.eu-S936846AbYD1Vy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936846AbYD1Vy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935215AbYD1Vxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:53:31 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49271 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935036AbYD1Vx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:29 -0400
Date: Mon, 28 Apr 2008 17:53:13 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080428215313.GE28142@fieldses.org>
References: <20080424142857.GF15214@ZenIV.linux.org.uk> <200804241729.m3OHTnNx016180@agora.fsl.cs.sunysb.edu> <20080424181332.GB5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424181332.GB5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 07:13:32PM +0100, Al Viro wrote:
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

This looks like the same ugly stuff that the nfsv4 server is currently
doing; see, e.g., fs/nfsd/nfs4state.c:nfs4_upgrade_open().

A concrete example of a bug (e.g., export FOOfs over nfsd, do an open
upgrade, watch the oops) would be great motivation to finally get this
fixed, if you know of such an example off the top of your head....

--b.
