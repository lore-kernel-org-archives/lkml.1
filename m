Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYLVDWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYLVDWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 22:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYLVDWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 22:22:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYLVDWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 22:22:12 -0500
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
From: Eric Paris <eparis@redhat.com>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 21 Dec 2008 22:22:06 -0500
Message-Id: <1229916126.29604.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 18:36 -0500, C. Scott Ananian wrote:
> On Fri, Dec 12, 2008 at 4:51 PM, Eric Paris <eparis@redhat.com> wrote:
> > The following series implements a new generic in kernel filesystem
> > notification system, fsnotify.  On top of fsnotify I reimplement dnotify and
> > inotify.  I have not finished with the change from inotify although I think
> > inotify_user should be completed.  In kernel inotify users (aka audit) still
> > (until I get positive feedback) relay on the old inotify backend.  This can be
> > 'easily' fixed.
> > All of this is in preperation for fanotify and using fanotify as an on access
> > file scanner.   So you better know it's coming.
> > Why is this useful?  Because I actually shrank the struct inode.  That's
> > right, my code is smaller and faster.  Eat that.
> 
> As a desktop-search-and-indexing developer, it doesn't seem like
> fanotify is going to give me anything I want.  The inotify/dnotify
> restructuring to fsnotify seems reasonable, but not exciting (to me).
> 
> From a desktop search perspective, my wishlist reads like this:
>  1) An 'autoadd' option added to inotify directory watches, so that
> newly-created subdirectories get atomically added to the watch.  That
> would prevent missed IN_MOVED_FROM and IN_MOVED_TO in a newly created
> directory.
>  2) A reasonable interface to map inode #s to "the current path to
> this inode" -- or failing that, an iopen or ilink syscall.  This would
> allow the search index to maintain inode #s instead of path names for
> files, which saves a lot of IN_MOVE processing and races (especially
> for directory moves, which require recursive path renaming).
>  3) Dream case: in-kernel dirty bits.  I don't *really* want to know
> all the details; I just want to know which inotify watches are dirty,
> so I can rescan them.  To avoid races, the query should return a dirty
> watch and atomically clear its dirty flag, so that if it is updated
> again during my indexing, I'd be told to scan it again.
> 
> From the indexing perspective, dealing with a sequence of operations like:
>    1) mkdir -p abc/def
>    2) echo "foo" > abc/def/ghi
>    3) mv abc xyz
>    4) mv xyz/def/ghi jkl
> is entirely too much "fun".  Depending on the races between kernel and
> user space, I might get only:
>    CREATE abc
>    IN_MOVED_TO jkl
> and if I do get my watches put in place after step (1) I've still got
> to deal with a recursive rename in step (3), the possibility of
> getting notification of (2) after the rename in (3) (so abc/def/ghi no
> longer exists), and other delights.
> 
> As far as I can tell, fanotify only helps with the 'recursive watch'
> problem (which could be solved with 'autoadd' or just using the
> algorithm in http://mail.gnome.org/archives/dashboard-hackers/2004-October/msg00022.html
> ), and doesn't give me any tools to deal with the actual hard races or
> path-maintenance problems.

You are absolutely correct that fanotify doesn't help with object
movement or path maintenance.  Neither had been requested, but
notification (that an inode moved) shouldn't be impossible (although the
hooks are going to be a lot more involved and will probably take some
fighting with the VFS people, my current fanotify hooks use what is
already being handed to fsnotify_* today)  To directly answer you
requests

1) autoadd isn't really what I'm looking at, but maybe someday I could
take a peek, at first glance it doesn't seem unreasonable an idea, but I
don't see how the userspace interface could work.  Without the call the
inotify_init to get the watch descriptor how can userspace know what
these new events are?  Only possibility I see for this is if inotify got
an extensible userspace interface.  In any case I'd be hard pressed to
call it a high priority since it's already possible to get this and the
intention of the addition is to make userspace code easier.

2) major vfs and every FS redesign me thinks.

3) What you want is IN_MODIFY from every inode but you want them to all
coallese until you grab one instead of only merging the same event type
if they are the last 2 in the notification queue.  Not sure of a
particularly clean/fast way to implement that right offhand, we'd have
to run the entire notification queue every time before we add an event
to the end, but at least this is doable with the constraints of the
inotify user interface.

Can't this already be done in userspace just by draining the queue,
matching events, throwing duplicates away, and then processing whatever
is left?  You know there is atomicity since removal of an event and the
addition of an event both hold the inotify_dev->ev_mutex.

In any case, I'm going to let your thoughts rattle around in my brain
while I'm still trying to rewrite inotify and dnotify to a better base.
My first inclination is to stop using inotify and start using fanotify.
Abandon filenames and start using device/inode pairs and you get
everything you need.  But I'm certain that isn't that case    :)

-Eric

