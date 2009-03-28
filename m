Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZC1Uik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZC1Uik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 16:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZC1Uib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 16:38:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZC1Uia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 16:38:30 -0400
Subject: Re: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090327130242.GW28946@ZenIV.linux.org.uk>
References: <1238158043.23703.20.camel@fatty>
	 <20090327130242.GW28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 21:38:25 +0100
Message-Id: <1238272705.23703.77.camel@fatty>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 13:02 +0000, Al Viro wrote:
> On Fri, Mar 27, 2009 at 01:47:23PM +0100, Alexander Larsson wrote:
> 
> > In order to write an app using the fanotify API satisfying the above
> > needs we would need the following events:
> > * the event queue overflowed, (you need to reindex everything)
> > * An inode was linked into the filesystem (creat, O_CREAT,
> > mkdir, link, symlink, etc)
> > * An inode was unlinked (unlink, rmdir, rename replaced existing file)
> > * An inode was moved in the filesystem (rename)
> 
> Erm...  Just how would you represent and *order* the events?  Note that
> "serialize all directory operations on given fs" is a non-starter...

So, I've been thinking a bit more about this. You're right that
serializing all directory operations is way to expensive. And I don't
actually need it for my usecase. However, the event types I listed above
are more or less taken from the "inotify style" events, and they sort of
demand an ordering (or much of the arguments are useless).

That information would not be used by an indexer like the one i
described anyway, so i think the set of events could be drastically
simplified.

Basically, we would need a single event for all the namespace changing
events (link, unlink, rename, etc). This event would say "some name in
this directory changed", you'll get a single event of these for a
link/unlink and two of them for a rename.

Furthermore, since ordering is not specified multiple events to the same
location is meaningless. So instead of "queue of events" we're more
talking about a set of changed files/dirs, containing all the things
that changed since you last read the event.

This simplification means we can drop a lot of data from the events,
cutting down on memory use. It also means we only have to store one
event for each dentry or struct file that changes, meaning less memory
use. (Although the event "queue" would have to turn into some other form
of datatype that allows quickly finding if a file is already in the
queue.

This also simplifies the userspace API, so that the current fanotify
userspace event struct with an fd + a mask doesn't have to be changed.


