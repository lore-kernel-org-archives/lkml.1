Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZC0NrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZC0NrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZC0NrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:47:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34231 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZC0NrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:47:10 -0400
Subject: Re: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090327130242.GW28946@ZenIV.linux.org.uk>
References: <1238158043.23703.20.camel@fatty>
	 <20090327130242.GW28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 14:47:03 +0100
Message-Id: <1238161623.23703.61.camel@fatty>
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

This particular usecase doesn't really require a specific order for the
events. Its enough to know that something changed in a directory, or a
subtree. I can't think of an event reordering that would cause us to not
eventually reindex the files was affected by a change. 

Note, I don't think its possible to track renames precisely so that we
know that a previosly indexed file is in another place now, but rather
that if we move a directory from a to b we now need to fully reindex
both the a and b subtrees.

However, the order might be important for other usecases, I can't really
tell. Is it possible to give any kind of guarantee for the event order?

As for representation, I guess there are two issues here, how the event
looks in the kernel side event queue and how it looks to userspace. I'm
no kernel developer, but i guess a rename could be something liks

struct path *old_dir;
char *old_name
struct path *new_dir;
char *new_name

and the userspace side could be:

int old_dir_fd
char *old_name
int new_dir_fd
char *new_name

