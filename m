Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYJNUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYJNUwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYJNUwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:52:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37736 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbYJNUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:52:15 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 00/16] fanotify: novel all file access notification and
	permissions system
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:51:30 -0400
Message-ID: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a file notification and access system intended to allow
a variety of userspace programs to get information about filesystem
events no matter where or how they happen on a system and use that in
conjunction with the actual on disk data related to that event to
provide additional services such as file change indexing or content
based antivirus scanning.  Minor changes are almost certainly possible
to make this notification and access interface usable for HSMs.  fscking
all notify is generally refered to as fanotify, or for the weak of heart
you can call it file access notify system.  The ideas behind this
code are based on talpa the GPL antivirus interface originally pioneered
by Sophos and on the feedback from lkml and malware-list.  This is
however a complete rewrite from scratch, so if you remember talpa 'this
ain't it.'

the most up2date (but not always working) patch set can always be found
at http://people.redhat.com/~eparis/fanotify

comments, attacks, criticism, bad names, and really just about anything
can be sent to me but please lets not rehash useless conversations!  I
will send the full patch set to both lists, but I'm not going to cc
everyone individually.

**fanotify-executive-summary**

fanotify has 9 event types and only sends events for S_ISREG() files.
The event types are OPEN_NOEXEC, OPEN_EXEC, READ, WRITE, CLOSE_WRITE,
CLOSE_NOWRITE, OPEN_PERM, READ_EXEC_PERM, and READ_NOEXEC_PERM.
Events OPEN_PERM, READ_EXEC_PERM and READ_NOEXEC_PERM
require that the listener return some sort of allow/deny/more_time
response as the original process blocks until it gets an event (or times
out.)  listeners may register a group which will get notifications about
any combination of these events, it will be up to the listener to
determine what events they are interested in hearing a mediating access
decisions for.

groups are a construct in which userspace indicates what priority (only
really used for PERM type events) and what type of events its
listeners want to hear.  A single group may have unlimited listeners but
each event will only go to ONE listener.  Two groups may register for
the same type of events and one listener in EACH group will get a copy
of the event.

The user interface for fanotify is all through socket calls.  Userspace
pulls events from the kernel using getsockopt and sends responses to the
kernel using setsockopt.  These are the only socket operations defined
for PF_FANOTIFY sockets.

-----------------
fanotify, long winded:

User interface work can be found in net/fanotify.  The main
implementation is in fs/notify.  My layout is like so

fanotify.c     --- all functions called from the main kernel
group.c        --- groups are my implementation of my multiple listeners
                   you can register different groups to get different
                   event types.
notification.c --- implementation surrounding the sending of events to a
                   userspace listener.
fastpath.c     --- implementation surrounding the addition of inode
                   fastpath entries for performance.
access.c       --- implementation surrounding the processing of
                   responses from userspace when the events require
                   a response.

fanotify is a new fscking all notify subsystem.  Much as inotify
provides notification of filesystem activity for some registered subset
of inodes fanotify provides notification of filesystem activity for ALL
of the system's S_ISREG() files.  fanotify has a smaller number of
notifications than inotify.

GROUPS AND EVENTS:
A "group" registers with fanotify and in doing so indicates what that
group should be called and what type of events it wishes to receive and
in what order it should receive events relative to other groups.  An
"event" is simply a notification about some filesystem action.  The list
of all fanotify events are read, write, open_for_exec, open,
close_was_not_writable, close_was_writable, open_need_access_decision,
read_for exec_need_access_decision, read_need access_decisions.  Any number
of groups may be created for any subset of event types.  One group may
register to get reads and writes while another maybe register for opens
and read_need_access_desision.

Any number of userspace listeners may be active in a single group.  Each
group will get ONE copy of any filesystem event.  If there are 10
listeners in a single group and one fanotify event is generated only ONE
of those listeners will get the event.  If more than one group registers
for the same type of event one listener in EACH GROUP will get a copy of
that event.

It all starts when a listener registers a group.  Registering a group
is as done by binding group information to a fanotify socket.  Simple
operation is something like.

addr.name = 123
addr.priority = 456
addr.mask = 0x002

sock = socket(PF_FANOTIFY);
fd = bind(sock, addr);

123 is just the name of the group, used so it is unlikely two listeners
will accidentally use the same priority and mask and stumble into each
others events.  456 is the priority (only interesting for blocking/access
events, will describe later) and 0x002 is FAN_WRITE.  If one wanted read
and write you would use 0x03 = (FAN_ACCESS | FAN_WRITE).  If this is the
first time a process has bound to this address a struct fanotify_group
is allocated and initialized (see fanotify_find_group()).  The group is
added to a kernel global list called groups.

The listener should now call getsockopt(fd, FANOTIFY_GET_EVENT,...).
Since at this point there are no events this will block waiting for an
event.

Now lets say the original process calls open().  Open is going to happen
exactly as before until it gets to the fsnotify code (this is where both
inotify and dnotify hook into the kernel.)  From fsnotify we will call
into the function fanotify() with the mask FAN_OPEN.  We will then walk
to global groups list (which is ordered by priority, low first) looking
for any groups which want to receive notification about FAN_OPEN and
let's say we will find the group '123' that was registered above. An
fanotify_event is allocated and any data we want the listener process to
get about the original process is added to the fanotify_event.  The
event contains a struct path with the dentry and vfsmount from the open
done by the original process.

Now we call add_event_to_group_notification() to add the event to the
group->notification_list.  This function has a little bit of magic.
Since an event may be needed in multiple groups notification_list I
created a helper structure, a struct fanotify_event_holder.  Each entry
in the group->event_list points to a unique event_holder which in turn
points to the ref counted event in question.

(assuming 2 groups)
group1->notification_list ==> fanotify_event_holder1 ==> single_fanotify_event
group2->notification_list ==> fanotify_event_holder2 ==> single_fanotify_event

The magic is that since we will always need at least 1 holder I embedded
one fanotify_event_holder inside an fanotity_event.  This means that
when removing an event from the group->notification_list we may need to
free the fanotify_event_holder (if it was allocated seperately) or we
may need to just clear it (if it was the embedded holder.)

After the event is added to the group->notification_list we wake up the
listener processes.  The original process never blocked and at this
point and is returning to userspace with the completed open.

Simultaneously the listener process will now remove the event from the
group->notification_list, see remove_event_from_group_notification().
Create a new file, fd, and install such in the listener process, see
fanotify_notification_read().  We will put_event (since this group
is finished with it) and will return the getsockopt() call to userspace.

The listener process will get a structure filled back from teh
getsockopt call which will include an fd and some metadata about that
fd.  This includes things like the original files f_flags, the original
processes pid and things like that.

The listener process must call close() when it is finished with this
new fd.  But lets assume the listener, for whatever reason, decides it
doesn't want to hear any more of this type of message for this inode.
That means the listener process needs to "create a fastpath" entry.  To
do this the listener process will need to call setsockopt(fd,
FANOTIY_SET_FASTPATH, ...) the struct with the setsockopt will include
things like what kind of events we don't want to hear about and what
file this is associated with.  All fastpaths will be cleared on the next
fsnotify write event (happens the same place in the code as mtime
update)

Inside the kernel (fanotify_fastpath_add()) what happens is that we will
create a new fanotify_fastpath_entry for the group and mask in question
and attach it to the inode.  The next time a process opens the inode in
question we will search the global groups list for a group that matches
the mask and we will look at the inode to see if there is a fastpath
entry for this group and mask.  If there is an entry no event will be
added to the group->event_list.

The need for fastpaths (or calling what it really is, an in kernel
cache) has been questioned.  I decided to include a little unscientific data
here.  On a 32 way machine a make -j 32 took about 9 minutes 12 seconds.
With that same machine running having one group and 32 listeners receiving
every fanotify event that the kernel could send to userspace while the 
listeners were responding to accesses as fast as they could (just a very tight get
event, allow loop) it took 95 minutes 12 seconds.  Same process with in kernel
fastpaths/cache results took 19 minutes 5 seconds.  More reasonable event
requirements and a single listener took 10 minutes 35 sec.  So about a 15%
perf hit to do any kind of permission checking to userspace.  Anyway, the need
for fastpaths is quite clear.

Assuming the event was for FAN_OPEN_PERM much of the above is the
same.  Biggest difference is that the place from the kernel we will call
into the fanotify code is different (fsnotify is not in a good place to
provide security hooks).  If a group is found that wants this event the
event is added to the group->access_list AND to the group->event_list.
The original process is then blocked for a (now fixed 5 second) timeout
waiting for the event to get a non-zero event->response on the
group->access_waitq.

The listener process will get a notification exactly as above from the
notification file but this time will need to write an answer to the
access file.  The answer is again a simple string indicating the cookie
and the response (allow/deny).  If a response is received from userspace
the event is removed from the group->access_list and the original
process is woken up to continue, either by looking for the next group or
by returning -EPERM.  Userspace may also return FAN_RESETTIMER which
will reset the 5 second timeout.  A badly behaving userspace may hang an
open indeffinetly.

If the original process times out waiting for the listener process to
give a response we currently just allow the security access.

An interesting part of the code is fastpath cleanup handling.  Any time
fanotify gets a FAN_MODIFY event we clear the fastpath entries for the
associated inode.  This means our notification and access decisions are
NOT race free but the races are small.  This is not perfect security.  A
'problomatic' sequence of events would be like such

process1 calls read on file
listener scans file and finds it safe
process2 writes to file
listener creates a fastpath entry for file

Maybe I should add an explicit clear fastpath request so userspace can
close that race when it gets the write notification on file (if it so
chooses.)  Remember I'm not trying to protect against a rogue process
intelligently and actively attacking the system.  I'm trying to stop a
correctly functioning yum from reading a bad rpm that it downloaded.
I'm trying to stop an NFS server from accepting bad files and then
apache serving them out on the net.

There is the also a race between when a process calls mmap() (at that
point we get an event and scan) and when the process actually faults in
a page which may have been changed by a write from another process.  Its
not perfect, but it's damn sure better than what we have now.

Object lifetime:

fanotify_group - exists from registration to unregistration.
Unregistration racing with some the associated special file notification
open was a bitch to figure out but eventually I based it on the groups
existence in the global groups list.

fanotify_event - created inside the main fanotify loop which runs the
events list.  An event lasts until both the main loop ends AND the event
is no longer needed by all groups for which it was queued.  A refcnt on
the event is taken every time it is added to a group notification/access
list and is dropped when the group has removed the event from the list
and is finished with its contents.

fanotify_event_holder - allocated when an event is added to a group
notification/access list.  destroyed when an event is removed from a
notification/access list.  There is the special case of the embedded
holder inside the fanotify_event.  The embedded holder is assumed to be
available for use if holder->event_list is empty.

fanotify_fastpath_entry - created when a process writes to the fastpath
special file and added to the inode list.  This entry is destroy in 3
possible places.  If an inode has a modify event we flush them all.  If
an inode is eviced from core we flush them all.  If a group is
unregistered we flush them all for that group.

---

Eric Paris (16):
      fanotify: send file f_flags along with notifications
      fanotify: send tgid with notification messages
      fanotify: send pid with fanotify notification events
      fanotify: ability for userspace to delay responses
      fanotify: user interface for access decisions
      fanotify: give a special access permission check
      fanotify: blocking and access granting
      fanotify: add group priorities
      fanotify: add a userspace interface for fastpaths
      fanotify: fastpath to ignore certain in core inodes
      fanotify: add a userspace interface for fanotify notifications
      fanotify: make use of the new fsnotify_open_exec calls
      fsnotify: sys_execve and sys_uselib do not call into fsnotify
      fanotify: fscking all notify, system wide file access notification
      fsnotify: pass a file instead of an inode to open, read, and write
      filesystem notification: create fs/notify to contain all fs notification


 fs/Kconfig                 |   39 --
 fs/Makefile                |    5 
 fs/aio.c                   |    7 
 fs/compat.c                |    5 
 fs/dnotify.c               |  194 -----------
 fs/exec.c                  |   15 +
 fs/inode.c                 |    6 
 fs/inotify.c               |  773 --------------------------------------------
 fs/inotify_user.c          |  781 --------------------------------------------
 fs/nfsd/vfs.c              |    4 
 fs/notify/Kconfig          |   52 +++
 fs/notify/Makefile         |    6 
 fs/notify/access.c         |  187 +++++++++++
 fs/notify/dnotify.c        |  194 +++++++++++
 fs/notify/fanotify.c       |  152 +++++++++
 fs/notify/fanotify.h       |  111 ++++++
 fs/notify/fastpath.c       |  230 +++++++++++++
 fs/notify/group.c          |  142 ++++++++
 fs/notify/inotify.c        |  773 ++++++++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify_user.c   |  781 ++++++++++++++++++++++++++++++++++++++++++++
 fs/notify/notification.c   |  277 ++++++++++++++++
 fs/open.c                  |    7 
 fs/read_write.c            |   14 +
 include/linux/Kbuild       |    1 
 include/linux/fanotify.h   |  186 ++++++++++
 include/linux/fs.h         |    5 
 include/linux/fsnotify.h   |   39 ++
 include/linux/sched.h      |    1 
 include/linux/socket.h     |    5 
 mm/mmap.c                  |    7 
 mm/mprotect.c              |    6 
 mm/nommu.c                 |    7 
 net/Makefile               |    1 
 net/core/sock.c            |    6 
 net/fanotify/Makefile      |    5 
 net/fanotify/af_fanotify.c |  270 +++++++++++++++
 net/fanotify/af_fanotify.h |   20 +
 37 files changed, 3503 insertions(+), 1811 deletions(-)
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/access.c
 create mode 100644 fs/notify/dnotify.c
 create mode 100644 fs/notify/fanotify.c
 create mode 100644 fs/notify/fanotify.h
 create mode 100644 fs/notify/fastpath.c
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/inotify.c
 create mode 100644 fs/notify/inotify_user.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fanotify.h
 create mode 100644 net/fanotify/Makefile
 create mode 100644 net/fanotify/af_fanotify.c
 create mode 100644 net/fanotify/af_fanotify.h
