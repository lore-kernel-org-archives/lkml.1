Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYLVOp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYLVOp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYLVOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:45:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYLVOpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:45:50 -0500
Subject: Re: [RFC PATCH -v4 07/14] fsnotify: add in inode fsnotify markings
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081222134300.GA21807@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215151.27112.71399.stgit@paris.rdu.redhat.com>
	 <20081213030701.GD807@ioremap.net>
	 <1229186110.29167.100.camel@localhost.localdomain>
	 <20081222134300.GA21807@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 09:45:28 -0500
Message-Id: <1229957128.3619.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 13:43 +0000, Al Viro wrote:
> On Sat, Dec 13, 2008 at 11:35:09AM -0500, Eric Paris wrote:
> 
> > So to find an entry we need to first grab the inode->i_lock and start to
> > walk the inode->i_fsnotify_mark_entries list.  Since we hold the i_lock
> > we are not allowed to grab any other locks nor are we allowed to change
> > anything other than entry->i_list.  The secret sauce is that we actually
> > move the entry from the inode list to a private list which we can walk
> > and modify lockless.  Inside the event we actually have to use a
> > different list, free_i_list, for this operation so nothing else that
> > races with us can mess stuff up.  We run the entire inode we are trying
> > to free all entries for an put the entries on the private list.  We do
> > NOT modify event->inode.
> 
> And just what happens if #3 ("remove entry") hits us in the meanwhile?  Freed
> object sitting on free_i_list?

In the code on list, nothing.  Evgeniy Polyakov pointed out that I
grabbed my marks at the wrong time.

http://lkml.org/lkml/2008/12/13/94

The corrected idea is that while under the i_lock I call
fsnotify_get_mark() on every inode mark that I am moving to the
free_i_list.  When #3 races it actually does all of the cleanup,
including setting the "freeme" flag.  But it won't be able to get the
refcnt down to 0.  Once we finish 'cleaning up,' we call put on the
object and the refcnt will actually go to 0 and be freed.

The memory can't be freed as long as it is on a free_{i,g}_list.

-Eric

