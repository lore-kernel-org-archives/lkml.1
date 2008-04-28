Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbYD1Lxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbYD1Lxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763352AbYD1Lxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:53:34 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36972 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763309AbYD1Lxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:53:34 -0400
Date: Mon, 28 Apr 2008 07:53:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080428115321.GD30840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ulrich Drepper <drepper@gmail.com>,
	Soeren Sandmann <sandmann@daimi.au.dk>,
	linux-kernel@vger.kernel.org
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 09:43:05PM -0700, Ulrich Drepper wrote:
> On Thu, Apr 24, 2008 at 1:59 PM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
> >  So I am looking for ways to improve this.
> 
> Aside from what has already been proposed there is also the
> readdirplus() route.  Unfortunately the people behind this and related
> proposals vanished after the last discussions.  I was  hoping they
> come back with a revised proposal but perhaps not.  Maybe it's time to
> pick up the ball myself.
> 
> As a reminder, readdirplus() is an extended readdir() which also
> returns (a subset of) the stat information for the file at the same
> time.  The subset part is needed to account for the different
> information contained in the inodes.  For most applications the subset
> should be sufficient and therefore all that's needed is a single
> iteration over the directory.

I'm not sure this would help in the cold cache case, which is what
Soeren originally complained about.[1] The problem is whaever
information the user might need won't be store in the directory, so
the filesystem would end having to stat the file anyway, incurring a
disk seek, which was what the user was complaining about.  A
readdirplus() would save a whole bunch of system calls if the inode
was already cached, yes, but I'm not sure that's it would be worth the
effort given how small Linux's system call overhead would be.  But in
the cold cache case, you end up seeking all over the disk, and the
only thing you can do is to try to keep the inodes close to each
other, and to have either readdir() or the caller of readdir() sort
all of the returned directory entries by inode number to avoid seeking
all over the disk.

							- Ted


[1] At least, not without making filesystem modifications; the problem
is that if you're going to store the inode information (or part of the
inode information) in the directory it has to get updated each time
the inode gets updated, and that gets painful with hardlinks.  There
was a Usenix paper which explored this idea over ten years ago, and
it's possible --- but then all directory entries need to have linked
list so that that you can either (a) find the "master" directory entry
which contains the inode information and be able to migrate inode
information to another directory entry when the originl "master"
dirent gets deleted, or (b) you keep the subset of the inode
information in all of the directory entries of the hardlink, and have
to update them all each time the inode information changes.


