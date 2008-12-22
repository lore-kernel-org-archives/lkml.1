Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYLVUxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYLVUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYLVUxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:53:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbYLVUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:53:35 -0500
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
From: Eric Paris <eparis@redhat.com>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
	 <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 15:53:31 -0500
Message-Id: <1229979211.9566.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 14:59 -0500, C. Scott Ananian wrote:
> On Sun, Dec 21, 2008 at 10:22 PM, Eric Paris <eparis@redhat.com> wrote:

> > In any case, I'm going to let your thoughts rattle around in my brain
> > while I'm still trying to rewrite inotify and dnotify to a better base.
> > My first inclination is to stop using inotify and start using fanotify.
> > Abandon filenames and start using device/inode pairs and you get
> > everything you need.  But I'm certain that isn't that case    :)
> 
> Well, except for being able to recreate the path from the inode,
> without which ability inode numbers without directory notifications
> are pretty useless.

fanotify doesn't have directory notifications.  You get notifications
about the individual inodes.  I don't have mv tracking, and I'm not sure
how much trouble it'll be.  Maybe not that bad since a mv doesn't have
to deliver the fd to userspace.  I promise to think about how to make
this better for you.  In any case, you can get pathnames, dev, and inode
very quickly.

> BTW, I had some difficulty discovering the exact userland API you were
> proposing for fanotify.  I eventually found in it the 'v1' and 'v2'
> set of fanotify patches, before the split to fsnotify, but it would be
> nice to see it restated in an easier-to-find place.  'google fanotify'
> turns up:
>    http://lwn.net/Articles/303277/
> as the second hit, which is reasonable, but
>    http://people.redhat.com/~eparis/fanotify/21-fanotify-documentation.patch

This is probably the best there is ATM.  It includes a program which
uses all of the fanotify functionality I wrote.

> seems better?  I note that fanotify doesn't actually seem to return
> the relevant inode number from (say) a CLOSE_WAS_WRITABLE event; I've
> got to stat /proc/self/fd/<fd> to get that?

For pathname you readlink on /proc/self/fd/[event->fd]

For dev and ino you stat [event->fd]

where event was filled from your getsockopt call.

In any case, event coallessing seems like it needs to work by walking
the notification queue starting at the back and working forwards.  If
you find a duplicate just drop.  If you find a mv, place this one at the
end.  Kinda sucks that we are taking and O(1) operation and making it
O(n).

At least with fanotify you don't have mv races, since you have an open
fd which still gives you the access you need even if it mv'd.

don't worry I won't forget your thoughts.

-Eric

