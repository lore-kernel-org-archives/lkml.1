Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZHYB0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZHYB0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZHYB0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:26:44 -0400
Received: from THUNK.ORG ([69.25.196.29]:45477 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZHYB0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:26:43 -0400
Date: Mon, 24 Aug 2009 21:26:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Shanab <jshanab@earthlink.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early
	research
Message-ID: <20090825012638.GO17684@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Shanab <jshanab@earthlink.net>, linux-kernel@vger.kernel.org
References: <4A93284C.7060604@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93284C.7060604@earthlink.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:54:52PM -0700, Jeff Shanab wrote:
>     I was thinking that a good way to handle this is that it starts with
> a file change in a directory. The directory entry contains a sum already
> for itself and all the subdirs and an adjustment is made immediately to
> that, it should be in the cache. Then we queue up the change to be sent
> to the parent(s?). These queued up events should be a low priority at a
> more human time like 1 second. If a large number of changes come to a
> directory, multiple adjustments hit the queue with the same (directory
> name, inode #?) and early ones are thrown out. So levels above would see
> at most a 1 per second low priority update.

Is this something that you want to be stored in the file system, or
just cached in memory?  If it is going to be stored on disk, which
seems to be implied by your description, and it is only going to be
updated once a second, what happens if there is a system crash?  Over
time, the values will go out of date.  Fsck could fix this, sure, but
that means you have to do the equivant of running "du -s" on the root
directory of the filesystem after an unclean shutdown.

You could write the size changes in a journal, but that blows up the
size of information that would need to be stored in a journal.  It
also slows down the very common operaton of writing to a file, all for
the sake of speeding up the relatively uncommon "du -s" operation.
It's not at all clear it's worthwhile tradeoff.

In addition, how will you handle hard links?  An inode can have
multiple hard links in different directories, and there is no way to
find all of the directories which might contain a hard link to a
particular inode, short of doing a brute force search.  Hence if you
have a file living in src/linux/v2.6.29/README, and it is a hard link
to ~/hacker/linux/README, and a program appends data to the file
~/hacker/linux/README, this would also change the result of running du
-s src/linux/v2.6.29; however, there's no way for your extension to
know that.

> title: "User Metadata" aka "pet peeve reduction"
>     I would like to maintain a few classifications of metadata, most
> optional and configurable.

Most Linux filesystems already have extended attributes that can be
used to store your proposed metadata.  Changing user application
programs to store the keywords, etc., is an exercise in
application-level programming; the kernel-side support is already
there.

						- Ted
