Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXHASor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXHASor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762281AbXHASoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:44:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60483 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbXHASoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:44:18 -0400
Date: Wed, 1 Aug 2007 14:44:05 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <20070731171159.GA27234@filer.fsl.cs.sunysb.edu> <1185981810.18007.14.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185981810.18007.14.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:23:29AM -0500, Dave Kleikamp wrote:
> On Tue, 2007-07-31 at 13:11 -0400, Josef Sipek wrote:
> > On Tue, Jul 31, 2007 at 07:00:12PM +0200, Jan Blunck wrote:
> > > On Tue, Jul 31, Josef Sipek wrote:
> > > 
> > > > On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > > > > Introduce white-out support to ext2.
> > > > 
> > > > I think storing whiteouts on the branches is wrong. It creates all sort of
> > > > nasty cases when people actually try to use unioning. Imagine a (no-so
> > > > unlikely) scenario where you have 2 unions, and they share a branch. If you
> > > > create a whiteout in one union on that shared branch, the whiteout magically
> > > > affects the other union as well! Whiteouts are a union-level construct, and
> > > > therefore storing them at the branch level is wrong.
> > > 
> > > So you think that just because you mounted the filesystem somewhere else it
> > > should look different? This is what sharing is all about. If you share a
> > > filesystem you also share the removal of objects.
> > 
> > The removal happens at the union level, not the branch level. Say you have:
> > 
> > /a/
> > /b/foo
> > /c/foo
> > 
> > And you mount /u1 as a union of {a,b}, and /u2 as union of {a,c}.
> 
> Who does this?  I'm assuming that a is the "top" layer.  Aren't union
> mounts typically about sharing lower layers and having a separate rw
> layer for each union mount?
 
Alright not the greatest of examples, there is something to be said about
symmetry, so...let me try again :)

/a/
/b/bar		(whiteout for bar)
/c/foo/qwerty

Now, let's mount a union of {a,b,c}, and we'll see:

$ find /u
/u
/u/foo
/u/foo/qwerty
$ mv /u/foo /u/bar

Now what? How do you rename? Do you rename in the same branch (assuming it
is rw)? If you do, you'll get:

$ find /u
/u

Oops! There's a whiteout in /b that hides the directory in /c -- rename(2)
shouldn't make directory subtrees disappear.

There are two ways to solve this:

1) "cp -r" the entire subtree being renamed to highest-priority branch, and
rename there (you might have to recreate a series of directories to have a
place to "cp" to...so you got "cp -r" _AND_ "mkdir -p"-like code in the VFS!
1/2 a :) )

2) Don't store whiteouts within branches. This makes it really easy to
rename and remove the whiteout.

Sure, you could try to rename in-place and remove the whiteout, but what if
you have:

/a/
/b/bar		(whiteout)
/c/bar/blah
/d/foo/qwerty

$ mv /u/foo /u/bar

You can't just remove the whiteout, because that'd uncover the whited-out
directory bar in /c.

Josef 'Jeff' Sipek.

-- 
Bad pun of the week: The formula 1 control computer suffered from a race
condition
