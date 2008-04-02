Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYDBXU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYDBXU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbYDBXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:20:45 -0400
Received: from pat.uio.no ([129.240.10.15]:58757 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbYDBXUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:20:43 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402223637.GQ9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
	 <20080402205450.GO9785@ZenIV.linux.org.uk>
	 <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
	 <20080402214824.GP9785@ZenIV.linux.org.uk>
	 <1207174890.722.12.camel@heimdal.trondhjem.org>
	 <20080402223637.GQ9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 19:19:58 -0400
Message-Id: <1207178398.20254.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 132592FA2D3BFDF35A52AB5D2673FA4DFF472E34
X-UiO-SR-test: FEC867995BAD5FD41338331A8F1637B16E4150D0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 60 total 7672948 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 23:36 +0100, Al Viro wrote:
> On Wed, Apr 02, 2008 at 06:21:30PM -0400, Trond Myklebust wrote:
> > On Wed, 2008-04-02 at 22:48 +0100, Al Viro wrote:
> > > I disagree.  First of all, clear separation between operations on
> > > _filesystem_, which should all be namespace-agnostic and things
> > > that depend on vfsmount is a Good Thing(tm).  Think of that as
> > > of separation between server (superblock and everything related
> > > to it, starting with dentry tree) and clients; mixing those is a
> > > bloody bad idea.
> > 
> > Speaking of which: is there any reason why we can't get rid of the
> > vfsmount reference in struct file?
> > 
> > Most file operations, don't involve namespace traversal at all: aside
> > from fchdir(), and the *at() functions (all of which take file
> > descriptors, not pointers to struct file) the only function of that
> > vfsmount reference appears to be to prevent the superblock from going
> > away.
> 
> Huh?  Are you proposing to move that to descriptor table, of all things?
> Not to mention SCM_RIGHTS datagrams and hell knows what else...

I'm just suggesting splitting out the namespace-specific part of struct
file into a separate structure that would be private to the VFS.
Something like

struct file_descriptor {
	struct file *file;
	struct vfsmount *mnt;
	atomic_t refcount;
};

and then having the 'struct file' hold a reference to the superblock
instead of holding a reference to the vfsmount.

Why would that be problematic for SCM_RIGHTS? We don't allow people to
send arbitrary references to 'struct file' using SCM_RIGHTS now; they
have to send descriptors.

