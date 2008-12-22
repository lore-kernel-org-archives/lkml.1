Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYLVT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYLVT7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYLVT7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:59:41 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34731 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYLVT7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xmWEVpDlSArITwXYJUajq11jYWxgOvPePI19e++6UfzK+XZ5Rm0fudNF8FU++yY8Px
         vu2ZwTRRHK/fYi0yR+azWP2so9/jNtgIlgHaZ6acVeXUQo65dYGEWEe5EOsV8e9SJSLf
         C9ef85afWKUwwTvJ6WrM17jw6aZxbMGAsMoZE=
Message-ID: <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
Date: Mon, 22 Dec 2008 14:59:37 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1229916126.29604.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
X-Google-Sender-Auth: 36f07d5653a59dbb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 10:22 PM, Eric Paris <eparis@redhat.com> wrote:
> On Thu, 2008-12-18 at 18:36 -0500, C. Scott Ananian wrote:
>> As a desktop-search-and-indexing developer, it doesn't seem like
>> fanotify is going to give me anything I want.  [...]
> You are absolutely correct that fanotify doesn't help with object
> movement or path maintenance.  Neither had been requested, but
> notification (that an inode moved) shouldn't be impossible (although the
> hooks are going to be a lot more involved and will probably take some
> fighting with the VFS people, my current fanotify hooks use what is
> already being handed to fsnotify_* today)  To directly answer you
> requests
>
>>  1) An 'autoadd' option added to inotify directory watches, so that
>> newly-created subdirectories get atomically added to the watch.  That
>> would prevent missed IN_MOVED_FROM and IN_MOVED_TO in a newly created
>> directory.
> 1) autoadd isn't really what I'm looking at, but maybe someday I could
> take a peek, at first glance it doesn't seem unreasonable an idea, but I
> don't see how the userspace interface could work.  Without the call the
> inotify_init to get the watch descriptor how can userspace know what
> these new events are?  Only possibility I see for this is if inotify got
> an extensible userspace interface.  In any case I'd be hard pressed to
> call it a high priority since it's already possible to get this and the
> intention of the addition is to make userspace code easier.

Multiple calls to inotify_add_watch are allowed to return the same
watch descriptor, since the descriptor is unique to a pathname. I
think you would pass IN_DIR_AUTO_ADD as part of the 'mask' when you
set up the watch, and when a subdirectory is added you generate the
IN_CREATE as before but also atomically create a new watch on that
directory, adding it to the same inotify instance.  Since inotify
maintains an ordered queue, the userland will eventually get the
IN_CREATE, call inotify_add_watch on the subdirectory as before, and
get the automatically created watch descriptor.  Later events in this
directory which are already on this queue use this same descriptor, so
it "just works".

If you don't properly process the IN_CREATE or don't process queue
events in order, you could get events referring to a watch descriptor
you don't know about yet, but you can just defer them until you
process the IN_CREATE and discover the descriptor id.  These problems
would be of your own making, of course, but are solvable.  If you do
the obvious thing, you don't have to worry.

This is a narrow fix which removes a race condition and enables
straightforward code to "just work".

>>  2) A reasonable interface to map inode #s to "the current path to
>> this inode" -- or failing that, an iopen or ilink syscall.  This would
>> allow the search index to maintain inode #s instead of path names for
>> files, which saves a lot of IN_MOVE processing and races (especially
>> for directory moves, which require recursive path renaming).
> 2) major vfs and every FS redesign me thinks.

I'm not convinced of that.  I'm pretty certain one could export
symlinks /proc/<pid>/mountinfo/<dev>/<inode> -> <absolute path in
processes' namespace> with very little trouble, and no violence done
to the VFS, which already has an iget() function which does the heavy
lifting.

Would it be efficient?  Well, more efficient (and reliable!) than try
to maintain this same information in userland.  We only need to use
this when some action is actually taken by the desktop search (like
launching an application with some document resulting from a search),
which is less frequent than indexing operations.

>>  3) Dream case: in-kernel dirty bits.  I don't *really* want to know
>> all the details; I just want to know which inotify watches are dirty,
>> so I can rescan them.  To avoid races, the query should return a dirty
>> watch and atomically clear its dirty flag, so that if it is updated
>> again during my indexing, I'd be told to scan it again.
> 3) What you want is IN_MODIFY from every inode but you want them to all
> coallese until you grab one instead of only merging the same event type
> if they are the last 2 in the notification queue.  Not sure of a
> particularly clean/fast way to implement that right offhand, we'd have
> to run the entire notification queue every time before we add an event
> to the end, but at least this is doable with the constraints of the
> inotify user interface.

Yes, this sounds about right.  There are details to be hashed out: If
a/foo is modified and then moved to a/bar, do I get a combined event,
reordered events (IN_MOVE a/foo -> a/bar, then IN_MODIFY a/bar), or
dirty bits (IN_MOVE a/foo -> a/bar with an IN_DIRTY flag set on the
event).  But there are still atomicity concerns (next paragraph):

> Can't this already be done in userspace just by draining the queue,
> matching events, throwing duplicates away, and then processing whatever
> is left?  You know there is atomicity since removal of an event and the
> addition of an event both hold the inotify_dev->ev_mutex.

No, you break atomicity between draining the event and doing the
processing.  I can drain the queue but then have a/foo moved to a/bar
before I try to index a/foo.  Then indexing fails, and I have to
maintain some complicated user-space data structure to say, "oh, when
you find out where a/bar went to, you should index it".

Proper dirty bits would have an atomic "fetch and clear" operation.
So a/foo would be dirty, it would be returned on the queue and the
dirty bit would be atomically cleared.  If it was then moved to a/bar
before I got around to indexing, the index operation would fail, but
I'd know that a/bar would have its dirty bit set implicitly by the
move, and so would show up on the queue again.

More tricky details: The dirty bit would probably actually be set on
the directory 'a', and then when I scanned it I'd discover the
'foo->bar' rename.  But I'd still have to "remember" (in userspace)
that I didn't successfully scan a/foo and so scan a/bar.  This dirty
list could be a short list of "still dirty" inode numbers, and it
would only be used in this particular
move-after-dirty-read-and-before-index race.  If a/foo was modified
and then moved to a/bar, I'd simply see that both directory 'a' was
dirty and file 'bar' was dirty, and wouldn't need to use the "failed
index" list.

> In any case, I'm going to let your thoughts rattle around in my brain
> while I'm still trying to rewrite inotify and dnotify to a better base.
> My first inclination is to stop using inotify and start using fanotify.
> Abandon filenames and start using device/inode pairs and you get
> everything you need.  But I'm certain that isn't that case    :)

Well, except for being able to recreate the path from the inode,
without which ability inode numbers without directory notifications
are pretty useless.

BTW, I had some difficulty discovering the exact userland API you were
proposing for fanotify.  I eventually found in it the 'v1' and 'v2'
set of fanotify patches, before the split to fsnotify, but it would be
nice to see it restated in an easier-to-find place.  'google fanotify'
turns up:
   http://lwn.net/Articles/303277/
as the second hit, which is reasonable, but
   http://people.redhat.com/~eparis/fanotify/21-fanotify-documentation.patch
seems better?  I note that fanotify doesn't actually seem to return
the relevant inode number from (say) a CLOSE_WAS_WRITABLE event; I've
got to stat /proc/self/fd/<fd> to get that?
 --scott

-- 
                         ( http://cscott.net/ )
