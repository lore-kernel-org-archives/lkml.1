Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDWW4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDWW4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXDWW4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:56:51 -0400
Received: from thunk.org ([69.25.196.29]:40834 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbXDWW4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:56:50 -0400
Date: Mon, 23 Apr 2007 18:56:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Hopper <hopper@omnifarious.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-ID: <20070423225640.GA1663@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Hopper <hopper@omnifarious.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <462C2E5B.1080008@redhat.com> <Pine.LNX.4.64.0704230353000.25153@server.thyself> <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423135216.GA2744@omnifarious.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 06:52:16AM -0700, Eric Hopper wrote:
> Oh, two things really interest me about Reiser4.  First, I despise
> having to care about how many tiny files I leave lying around when
> writing a program.  Berkeley DB and its ilk are evil, evil programs that
> obscure data and make things harder.  Secondly, the moves Reiser4 has
> made towards having actual transactions at the filesystem level also
> intrigue me.
> 
> I want to use the filesystem as a DB.  IMHO, there is no reason that
> filesystems shouldn't be a DB sans query language.  If there were a more
> DB-like way to deal with filesystems, I think that it would be that much
> easier to make something that was a decent replacement for NFS and
> actually worked.

One of the big problems of using a filesystem as a DB is the system
call overheads.  If you use huge numbers of tiny files, then each
attempt read an atom of information from the DB takes three system
calls --- an open(), read(), and close(), with all of the overheads in
terms of dentry and inode cache.

Hans of course had a solution to this problem --- namely the
sys_reiser4 system call, where you download a program to the kernel to
execute a open/read/close via a single system call, and which returns
the combined results to userspace.  But now you have more complexity
since there is now a reseir4-specific interpreter embeddeed in the
kernel, the userspace application needs to write the equivalent of an
channel program such as what was found in an IBM/360 mainframe (need I
mention this can be a rich source of security bugs), and then the
userspace application *still* needs to parse the result returned by
the sys_reiser4() system call?

So it adds a huge amount of complexity, and at the end of the day,
given that you don't have the search capability, it is (a) less
functional, (b) more complexitated, and (c) probably less performant
than simply calling out to a database.

> Sadly, unless someone pays me to maintain it, I can't do the fork
> myself, and I likely wouldn't anyway as being a kernel hacker of
> something as important as a filesystem is a full-time job and I have
> other things that interest me a lot more.

Unfortunately, the way OSS works is that you either (a) have to do the
work yourself, (b) convince someone else to do the work, or (c)
convince someone that it's worth paying you to do it.

Personally, if I controlled large budget for Linux filesystem
development, I'd put a lot more money into something like Val's
chunkfs idea than resier4.  Being able to have filesystems designed
for fast recovery given disks getting larger and larger (but not more
reliable), is a whole lot more improtant than trying to create an
alternate solution to an already solved problem --- namely that of a
database.  When you consider that a similar idea, WinFS, was partially
responsible for delaying Vista by years due to the complexity of
shoving a database where it has no place being, it's another reason
why I personally think that chunkfs is a much more promising avenue
for future filesystem investment than reiserfs.

But hey, the advantage of Open Source is that if *you* want to work on
Reiser4, you're perfectly free to do so.  My personal opinion is that
it'd be a waste of your time, but you're free to spend your time
whichever way that you want.  What you don't get do is whine about how
other people get to spend *their* time, or *their* money.

						- Ted
