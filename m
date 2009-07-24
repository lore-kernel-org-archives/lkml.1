Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZGXWsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZGXWsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZGXWsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:48:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43986 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZGXWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:48:31 -0400
Date: Fri, 24 Jul 2009 23:48:14 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090724224813.GK27755@shareable.org>
References: <1248466429.3567.82.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248466429.3567.82.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> It is a new notification system that has a limited set of events (open,
> close, read, write) in which notification not only comes with metadata
> the describes what happened it also comes with an open file descriptor
> to the object in question.  fanotify will also allow the listener to
> make access decisions on open and read events.  This allows the
> implementation of hierarchical storage management systems or an access
> file scanning or integrity checking.

My first thought was to wonder, why not make it the same set of events
that inotify and dnotify provide?  That is: open, close, read, write,
create, delete, rename, attribute change?  In other words, I don't see
a good reason for it to be a subset of events.

Apart from aesthetics (which is my first thought), creating, renaming
and deleting files and symlinks also has security implications on
typical Linux systems.  Since that fanotify is motivated by security
applications among other things, surely those type of events are of
interest too?

For example, just as you have the power to block a file open request
from some application, you may also need the power to block a
symlink(2) request.

> fanotify comes in two flavors 'directed' and 'global.'  'Directed' is
> like inotify or dnotify in that you register specific inodes of interest
> and only get events pertaining to those inodes.  Global means you are
> registering interest for event types system wide.  With global mode the
> listener program can later exclude objects from future events.

On a large multi-user system with, say, 10k users in /home and 100
logged in at any time, if you want to monitor the files in
/var/lib/ftp/some.ftp.site/, neither 'directed' nor 'global' are going
to be efficient.

Similarly, if you have 'enhanced rsync' as someone else has mentioned
(good example), it will want to monitor /home/me/kernels/2.6 only,
without slowing down the system when any of the other 4 million files
in /home/me are accessed.

I appreciate fanotify does not try to be perfect for every
application.  But if we can make it handle a few more things in a more
scalable way without much code, and a clean interface too, that can
only be good.

> fanotify kernel/userspace interaction is over a new socket protocol.  A
> listener opens a new socket in the new PF_FANOTIFY family.  The socket
> is then bound to an address.  Using the following struct:
> 
> struct fanotify_addr {
>         sa_family_t family;
>         __u32 priority;
>         __u32 group_num;
>         __u32 mask;
>         __u32 f_flags;
>         __u32 unused[16];
> }  __attribute__((packed));
> 
> The priority field indicates in which order fanotify listeners will get
> events.  Since 2 fanotify listeners would 'hear' each others events on
> the new fd they create fanotify listeners will not hear events generated
> by other fanotify listeners with a lower priority number.

I'm not sure if I understand the priority mechanism.  If it means that
events are only delivered to the highest priority listener, that makes
the fanotify subsystem virtually useless for things like 'enhanced
rsync' which someone else has mentioned.  Those programs need to know
they will receive all events, not miss some events when another
program is running.

But maybe I misunderstood the priority mechanism?

> The group_num is at the moment not used, but the plan was to allow 2
> processes to bind to the same fanotify group and share the load of
> processing events.

That's an interesting idea.  I like it.

Couldn't both processes simply read from the same socket, so you
wouldn't need group_num?  I think that would be cleaner and simpler.

For example, look at how Apache waits for incoming connections:
multiple processes call accept() on the same socket, and exactly one
process is woken with each new connection.  This is quite efficient.

You could do the same: have each process read from the same socket,
blocking until there is an event, and only send the event to one of
the waiting processes.

It is important that the kernel code to handle reads dequeues events
in each process efficiently, without the "thundering herd" problem
(look it up, Apache used to have it with accept()).

> The f_flags is the flags which the fanotify listener wishes to use when
> opening their notification fds.  On access scanners would want to use
> O_RDONLY, whereas HSM systems would need to use O_WRONLY.

Interesting.  An option for file change trackers who don't care about
the open file descriptor would be good too.  Perhaps they are just
logging.

> The mask is the indication of the events this group is interested in.
> The set of events of interest if FAN_GLOBAL_LISTENER is set at bind
> time.  If FAN_GLOBAL_LISTENER is not set, this field is meaningless as
> the registration of events on individual inodes will dictate the
> reception of events.
> 
> * FAN_ACCESS: every file access.
> * FAN_MODIFY: file modifications.
> * FAN_CLOSE: files are closed.
> * FAN_OPEN: open() calls.
> * FAN_ACCESS_PERM: like FAN_ACCESS, except that the process trying to
> access the file is put on hold while the fanotify client decides whether
> to allow the operation.
> * FAN_OPEN_PERM: like FAN_OPEN, but with the permission check.
> * FAN_EVENT_ON_CHILD: receive notification of events on inodes inside
> this subdirectory. (this is not a full recursive notification of all
> descendants, only direct children)
> * FAN_GLOBAL_LISTENER: notify for events on all files in the system.
> * FAN_SURVIVE_MODIFY: special flag that ignores should survive inode
> modification.  Discussed below.
> 
> After the socket is bound events are attained using the read() syscall
> (recv* probably also works haven't tested).  This will result in the
> buffer being filled with one or more events like this:
> 
> struct fanotify_event_metadata {
>         __u32 event_len;
>         __s32 fd;
>         __u32 mask;
>         __u32 f_flags;
>         __s32 pid;
>         __s32 tgid;
>         __u64 cookie;
> }  __attribute__((packed));
> 
> fd specifies the new file descriptor that was created in the context of
> the listener.  (readlink of /proc/self/fd will give you A pathname)
> mask indicates the events type (bitwise OR of the event types listed
> above).  f_flags here is the f_flags the ORIGINAL process has the file
> open with.  pid and tgid are from the original process.  cookie is used
> when the listener needs to allow, deny, or delay the operation.

So far it looks quite similar to inotify, with some differences.
Some things taken away:

   - Very similar events, but missing a few like renames (which you
     are thinking of adding).
   - No file name for things that happen in a subdirectory.
     Application expected to call readlink("/proc/self/fd") if it
     cares about the file name.  But that won't work for every kind of
     event!

Some things (useful I agree) added:

   - Returns an open file descriptor to the affected file.
   - Returns some other attributes, like accessing pid/tgid (uid though?).
   - Can block the process trying to access the file.

API-wise, is there a particular reason for using a new socket
interface, rather than extending the inotify interface with a few more
flags and a different event structure?

By the way, you may not know the history of inotify originally.  It
used a device, /dev/inotify, when it was a third-party patch.  To get
into the mainline kernel, it was requested that it be changed to use
system calls.  The same happened to epoll.  So you may have better
luck with a system call interface than using a socket.  That shouldn't
affect discussions of any other technical aspect, though.

> If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> must send a response before the 5 second timeout.  If no response is
> sent before the 5 second timeout the original operation is allowed.  If
> this happens too many times (10 in a row) the fanotify group is evicted
> from the kernel and will not get any new events.  Sending a response is
> done using the setsockopt() call with the socket options set to
> FANOTIFY_ACCESS_RESPONSE.  The buffer should contain a structure like:
> 
> struct fanotify_so_access {
>         __u64 cookie;
>         __u32 response;
> }  __attribute__((packed));
> 
> Where cookie is the cookie from the notification and response is one of:

What happens when a process sends a cookie that it did not receive,
but another process received it?

> FAN_ALLOW: allow the original operation
> FAN_DENY: deny the original operation
> FAN_RESET_TIMEOUT: reset the timeout.
> 
> The last main interface is the 'marking' of inodes.  The purpose of
> inode marks differ between 'directed' and 'global' listeners.  Directed
> fanotify listeners need to mark inodes of interest.  They do that also
> using setsockopt() of type FANOTIFY_SET_MARK with the buffer containing
> a structure like:
> 
> struct fanotify_so_inode_mark {
>         __s32 fd;
>         __u32 mask;
>         __u32 ignored_mask;
> }  __attribute__((packed));
> 
> Where fd is backed by the inode in question.  Mask is the events of
> interest (only used in directed mode) and ignored_mask is the mask of
> events which should be ignored.  

It's hard to see how this differs much from inotify_add_watch, except
- is this mark global to all processes, or local to the process
setting the mark?

> The ignored_mask is cleared every time an inode receives a modification
> events unless FAN_SURVIVE_MODIFY is also set.  The ignored_mask is
> mainly used for 2 purposes.  Global listeners may just have no interest
> in lots of events, so they should spam inodes with an ignored mask.  The
> ignored mask is also used to 'cache' access decisions.  If the listener
> sets FAN_ACCESS_PERM in the ignored mask all access operations will be
> permitted without the call out to userspace.  If the inode is modified
> the ignored_mask will be cleared and userspace will again have to
> approve the access.  If userspace REALLY doesn't care ever they can use
> the special FAN_SURVIVE_MODIFY flag inside the ignored_mask.

I do like the idea of caching access decisions.  Are these flags
global to the whole system, or local to the listening process setting
the flags (or to the specific listener's socket)?

> The only other current interface is the ability to ignore events by
> superblock magic number.  This makes it easy to ignore all events
> in /proc which can be difficult to accomplish firing FANOTIFY_SET_MARK
> with ignored_masks over and over as processes are created and destroyed.
> 
> ***********
> 
> Future direction:

Here's one more thing which may be needed to make hard guarantees for
security applications:

   - Mount events, which it would be natural for fanotify to block
     temporarily while it assesses the impact and/or synchronises it's
     map of the mounts against the change.  Mounts do change the set
     of visible files, after all.

> There are 2 things I'm interested in adding.
> - Rename events.
> 	The updatedb/mlocate people are interested in fanotify as a means to
> not thrash the harddrive every night.  They could instead update the db
> in real time as files are moved.

Great!

I'm interested in the same thing on narrower (but still large)
subdirectories, for things like enhanced rsync, make, git, indexing,
and complex caching of compiled things.  You get the idea: it has a
lot of uses.

> - subtree notification.
> 	Currently to only watch /home and all of it's descendants one must
> either register a directed watch on every directory or use a global
> listener.  The global listener with ignored_mask is not as bad as it
> sounds in my testing, but decent subtree registration and notification
> would be a big win in a lot of people's mind.

I believe we've talked about one suggestion for how to do this, on
lwn.net.  I'll repeat it here.

Efficient recursive notifications method:

   - You register for event on a directory with a RECURSIVE flag "give
     me events for this directory and all paths below it".

   - That listener gets events for any access of the appropriate type
     whose path is via that directory, *using the specific run-time
     path used for the access*.

   - That _doesn't_ mean hard-link files need to know all their parent
     directories, which would be silly and impossible.  The event path
     is just the one used at run-time for access, by the application
     attempting to open/write/whatever.

   - If a listener needs to track all accesses to a particular
     hard-linked file, it's the responsibility of the listener to
     ensure it listens to enough directories to cover every path to
     that file - or listen to the file directly.  It knows from
     i_nlink and the mount map when it has enough directories.

   - Notifying just the access path may seem counterintuitive, but in
     fact it's what inotify and dnotify do already, and it does
     actually work.  Often a listener is maintaining a cache or index
     of some kind, in which case it will already have sufficient
     knowledge about where the hard-linked files are (or know that it
     needs an initial indexing), and whether it has covered enough
     parent directories to see all accesses to them.

   - In practice it means each access traverses the path, following
     parent directories until reaching a mount point, broadcasting
     events on each one where there's a recursive listener.  That's
     not as inefficient as it looks, because paths don't usually have
     a large number of components.

   - I'm not sure exactly how fast/slow it is, though, and it may a
     few thoughtfully cached flags in each dentry to elide traversals.
     I won't discuss the details here, for fear of complicating the
     discussion too much.  They might well mesh with the 'access
     decision cache' flags you mentioned.

   - It is necessary that link(2) create an attribute-change event
     (for i_nlink!) on the source path of the link.  dnotify/inotify
     don't do that now (unless they changed recently), but they should
     to make this work.

Please shoot down the idea.  I think it is good enough
for reliable subtree notifications, but I'd love to be proven wrong.

-- Jamie
