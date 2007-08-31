Return-Path: <linux-kernel-owner+w=401wt.eu-S966311AbXHaTEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311AbXHaTEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965985AbXHaTD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:03:57 -0400
Received: from pat.uio.no ([129.240.10.15]:48871 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965707AbXHaTD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:03:56 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 15:03:49 -0400
Message-Id: <1188587029.19730.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.072)
X-UiO-Scanned: 0B74DCE9C7B5417A6B4FBA133F8EF36D5BCEAB97
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 35 total 3593729 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 10:01 -0700, Linus Torvalds wrote:
> 
> On Fri, 31 Aug 2007, Trond Myklebust wrote:
> >
> > The best I can do given the constraints appears to be to have the kernel
> > first look for a superblock that matches both the fsid and the
> > user-specified mount options, and then spawn off a new superblock if
> > that search fails.
> 
> I think this is probably acceptable to get roughly the old behaviour, but 
> I still think it's a bit stupid.
> 
> What happens at "mount -o remount,..." time?
> 
> The fact is, the whole "match the fsid and user mount options, and re-use 
> the mount" sounds like it's trying to solve a problem that doesn't need 
> solving. If the user really wants to duplicate the mount, he really should 
> be using a a bind-mount instead.
> 
> In other words, let's assume that the user has /some/nfs/mount mounted 
> over NFS, and wants to re-mount it (or even just a subset of it) somewhere 
> else, the sane thing to do is not to mount it again, but to just do
> 
> 	mount --bind /some/nfs/mount/subdir /new/mount/place
> 
> instead. That *guarantees* that the low-level filesystem uses the same 
> flags, and it also means that things like re-mounting have sane and 
> well-defined semantics, and will fail or succeed predictably.

I agree for the cases where you can use bind mounts, however you can't
always do that.

Consider the fairly common setup where /foo, /foo/a, /foo/b are all on
the same filesystem on the server, but only /foo/a and /foo/b are
exported.
There can be plenty of files that are contain hard links in both
directories, but because you cannot mount the parent, /foo, you will not
be able to ensure that these common files are cached to the same inode
(which they need to be).

IOW: with this scenario, you can't ensure that local posix semantics
hold (i.e. that if my client is the only user, then the filesystem will
behave as if it were a posix filesystem). That would be a major
regression.

> In contrast, if a user wants to create a new NFS mount, it really should 
> be independent of the old one, because that's (a) what other systems do, 
> and (b) also makes the semantics of re-mounting it with other flags be 
> clear and unambiguous (ie the remount has nothing what-so-ever to do with 
> the independent NFS mount).

(a) I'm not sure that is true: see (b).
(b) You gain remount clarity at the expense of local posix filesystem
correctness.

Trond

