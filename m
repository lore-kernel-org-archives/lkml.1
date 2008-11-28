Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYK1Xd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYK1Xd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYK1XdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:33:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYK1XdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:33:17 -0500
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
 backend
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <20081128045446.GG28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
	 <20081128045446.GG28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 18:32:59 -0500
Message-Id: <1227915179.3393.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 04:54 +0000, Al Viro wrote:
> On Tue, Nov 25, 2008 at 12:21:18PM -0500, Eric Paris wrote:
> 
> What the hell is ->notification_list and what in this patchset would
> add stuff to it?  Even more interesting question: how long would these
> guys remain there and what's to prevent a race with umount?  At least
> 'inode-only' events will pin down the inode and leaving the matching
> iput() until after umount() is a Bad Thing(tm)...

It's not in this set, my failure.  But I'm glad you noticed it since you
can help me get it right before I send the fanotify stuff....

If you look at the "fsnotify()" function in

http://marc.info/?l=linux-kernel&m=122650641702090&w=2

you will see users.  I've since moved fanotify_add_event_to_notif() to
be a per group function.  dnotify doesn't make use of the
notification_list.  fanotify will.  I can remove that for this patch set
(but removing everything that isn't in preperation for fanotify leaves
us with little new and useful)

Anyway at the fsnotify_BLAH my intention is to only put events which
include a struct path (for which I've take a path_get()).  When the
event is later pulled off of the queue I call dentry_open.  I assume
that a normal opened fd, if it returns is always safe vs umount.  Since
I've taken a ref to the path I assume it's safe to use in an open call.

In my previous patch set these entries with struct path can survive
forever if userspace fanotify listeners suck.  I saw it as a future
improvement to drop notification events on a timer if needed...

-Eric

