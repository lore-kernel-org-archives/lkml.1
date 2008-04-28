Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbYD1QTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbYD1QTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbYD1QSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:18:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40430 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbYD1QSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:18:50 -0400
Date: Mon, 28 Apr 2008 12:18:40 -0400
To: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080428161840.GD16831@fieldses.org>
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com> <20080428115321.GD30840@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428115321.GD30840@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 07:53:22AM -0400, Theodore Tso wrote:
> On Sun, Apr 27, 2008 at 09:43:05PM -0700, Ulrich Drepper wrote:
> > On Thu, Apr 24, 2008 at 1:59 PM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
> > >  So I am looking for ways to improve this.
> > 
> > Aside from what has already been proposed there is also the
> > readdirplus() route.  Unfortunately the people behind this and related
> > proposals vanished after the last discussions.  I was  hoping they
> > come back with a revised proposal but perhaps not.  Maybe it's time to
> > pick up the ball myself.
> > 
> > As a reminder, readdirplus() is an extended readdir() which also
> > returns (a subset of) the stat information for the file at the same
> > time.  The subset part is needed to account for the different
> > information contained in the inodes.  For most applications the subset
> > should be sufficient and therefore all that's needed is a single
> > iteration over the directory.
> 
> I'm not sure this would help in the cold cache case, which is what
> Soeren originally complained about.[1] The problem is whaever
> information the user might need won't be store in the directory, so
> the filesystem would end having to stat the file anyway, incurring a
> disk seek, which was what the user was complaining about.  A
> readdirplus() would save a whole bunch of system calls if the inode
> was already cached, yes, but I'm not sure that's it would be worth the
> effort given how small Linux's system call overhead would be.  But in
> the cold cache case, you end up seeking all over the disk, and the
> only thing you can do is to try to keep the inodes close to each
> other, and to have either readdir() or the caller of readdir() sort
> all of the returned directory entries by inode number to avoid seeking
> all over the disk.

The other reason for something like a readdirplus or a bulk stat is to
provide an opportunity for parallelism.

As my favorite example: cold-cache "git diff" of a linux tree on my
desktop (with an nfs-mounted /home) takes about 12 seconds.  That's
mainly just a sequential stat of about about 24000 files.  Patching git
to issue the stats in parallel, I could get that down to about 3.5
seconds.  (Still not great.  I don't know if it's disk seeks on the
server or what that are the limiting factor.)

In the case of git, it's looking just for files that it tracks--it's not
reading whole directories--so I don't know if readdirplus() specifically
would help.

--b.
