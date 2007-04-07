Return-Path: <linux-kernel-owner+w=401wt.eu-S966343AbXDGUgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966343AbXDGUgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966344AbXDGUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:36:37 -0400
Received: from thunk.org ([69.25.196.29]:52816 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966343AbXDGUgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:36:35 -0400
Date: Sat, 7 Apr 2007 16:36:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070407203633.GA21555@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 09:57:32AM -0700, Ulrich Drepper wrote:
> In their closed chambers (well, workshops,
> http://lwn.net/Articles/226351/), the filesystem developers complain
> about readdir.  I fully appreciate the difficulties.  But what I fail
> to see so far is any proposal for an alternative interface.
> 
> The phase to get new functionality included in the next revision of
> POSIX is over.  But that does not mean we should not try to get some
> sensible new implementation in place.  There is, for example, the
> "High End Computing Extensions Working Group" (the guys who showed up
> here with their statlite and readdirplus proposals).  This is an
> official working group at the OpenGroup which can produce a document
> which can be the basis of inclusion in the next revision and become a
> OpenGroup specification earlier than that.
> 
> So, if anybody has a proposal for better interfaces let's hear them.
> "Now" is a very good time to start working on this.

The problem isn't as much readdir() as it is telldir()/seekdir(),
which fundamentally assumes that the directory is a linear file.  JFS
for example was forced to implement an entire separate btree whose
only purpose was to record telldir cookies.  

With ext3 and htree we return the directories in hash tree sort order.
This sacrifices some performance with readdir/stat workloads unless
the userspace program does a readdir/qsort on inode number/stat
replacement.  In addition, there is the risk of hash collusions
because of the pathetically small size of the telldir cookie (32
bits).  If this happens, the readdir() guarantees of only returning
each directory entry at most once are compromised.  We use a keyed
hash with a per-filesystem superblock secret to prevent someone from
deliberately finding a hash collision and proving that we're not POSIX
compliant in the edge cases.  Cheasy, yes, but only loser programs
should be using telldir/seekdir anyway.  :-)

So how do we solve this problem?  I can think of two solutions:

1) Deprecate telldir/seekdir() altogether.  Relatively few progams use
this functionality, and it is highly questionable how useful it is,
anyway.  If you use telldir/seekdir and keep the cookie for a long
time, even the POSIX-provided guarantees about files that are created
and deleted between the telldir() and seekdir() points in time makes
its utility highly dubious.

2) If application programs must have telldir/seekdir, than expand the
size of the cookie from 32-bits to a minimum of 128 bits, and
preferably larger --- say 512 bits, to accomodate systems that might
be using 512-bit variant of SHA-2.   So something like this?

/* TELLDIR_COOKIE_SIZE must be >= 64 */
#define TELLDIR_COOKIE_SIZE 64
typedef unsigned char ltelldir_cookie_t[TELLDIR_COOKIE_SIZE];

int ltelldir(int fd, ltelldircookie_t *cookie);
int lseekdir(int fd, ltelldircookie_t *cookie);


My personal preference would be #1, though.  :-)

						- Ted
