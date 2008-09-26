Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYIZVIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYIZVIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYIZVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:08:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYIZVIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:08:21 -0400
Subject: [RFC] 0/11 fanotify: fscking all notifiction and file access
	system (intended for antivirus scanning and file indexers)
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, david@lang.hm,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       peterz@infradead.org, Jonathan.Press@ca.com, riel@redhat.com
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:07:00 -0400
Message-Id: <1222463220.2872.193.camel@localhost.localdomain>
Mime-Version: 1.0
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
all notify is generally refered to as fanotify.  The ideas behind this
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

fanotify has 7 event types and only sends events for S_ISREG() files.
The event types are OPEN, READ, WRITE, CLOSE_WRITE, CLOSE_NOWRITE,
OPEN_ACCESS, and READ_ACCESS.  Events OPEN_ACCESS and READ_ACCESS
require that the listener return some sort of allow/deny/more_time
response as the original process blocks until it gets an event (or times
out.)  listeners may register a group which will get notifications about
any combination of these events.  Antivirus scanners will likely want
OPEN_ACCESS and READ_ACCESS while file indexers would likely use the
non-ACCESS form of these events.

groups are a construct in which userspace indicates what priority (only
really used for ACCESS type events) and what type of events its
listeners want to hear.  A single group may have unlimited listeners but
each event will only go to ONE listener.  Two groups may register for
the same type of events and one listener in EACH group will get a copy
of the event.

fanotify has 3 main 'special' files per group which a userspace listener
uses to interact with the kernel.

notification file - listeners read a string containing information about
an fs event from this file and a new fd will be created in the listener
context related to this event.

fastpath file - userspace programs may write a string into this file
which will add an fanotify_fastpath to the inode associated with the
given open fd.  A fastpath is merely an in core tag on an inode which
indicated that events for that inode do not need to be sent to the
fanotify listener until the file changes.

access file - some events require userspace permission (possibly open or
read.)  When userspace gets such an event from the notification file it
needs to write a response down the access file so the kernel can
complete the original action.

-----------------
fanotify, long winded:

Everything in a _user.c file is how the user interacts.  They typically
handle a single special file's IO and then call into functions in the
file with the corresponding name without _user.  My layout is like so

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
of all fanotify events are read, write, open, close,
open_need_access_decision, close_need_access_decision.  Any number of
groups may be created for any subset of event types.  One group may
register to get reads and writes while another maybe register for opens
and read_need_access_desision.

Any number of userspace listeners may be active in a single group.  Each
group will get ONE copy of any filesystem event.  If there are 10
listeners in a single group and one fanotify event is generated only ONE
of those listeners will get the event.  If more than one group registers
for the same type of event one listener in EACH GROUP will get a copy of
that event.

BASIC TERMINOLOGY:

listener process - The fanotify aware process which is receiving events
from the notification special file and possibly writing answers back to
the kernel over the fastpath or access file.

original process - A normal linux process which is doing 'something' on
the filesystem.  For the purposes of this example this process will be
opening a file.

registration file - the file, /security/fanotify/register, used to
create fanotify groups.

notification file - the file, /security/fanotify/[name]/notification,
used for the listener process to get events from the kernel.

fastpath file - the file, /security/fanotify/[name]/fastpath, used to
send fastpath or 'cache' information to the kernel.

access file - the file /security/fanotify/[name]/access, used to send
access decisions back to the kernel if they are required for a given
event.

It all starts when 'something' registers a group.  Registering a group
is as simple as 'echo "open_grp 50 0x10" > /security/fanotify/register.
open_grp is just the name of the group, 50 is the priority (only
interesting for blocking/access events, will describe later) and 0x10 is
FAN_OPEN. If one wanted open and close you would use 0x1c = (FAN_OPEN |
FAN_CLOSE).  Inside the kernel this creates the new directory called
'open_grp' and the notification, fastpath, and access file inside that
directory.  A struct fanotify_group is allocated and initialized (see
fanotify_register_group()).  The group is added to a kernel global list
called groups.

Next the listener process will open (RD_ONLY) the notification file. The
group num_clients is incremented at this time. We will call read() on
that file.  Since the group at this point has no events to send to
userspace the listener process will block on the group->event_waitq.

Now lets say the original process calls open().  Open is going to happen
exactly as before until it gets to the fsnotify code (this is where both
inotify and dnotify hook into the kernel.)  From fsnotify we will call
into the function fanotify() with the mask FAN_OPEN.  We will then walk
to global groups list (which is ordered by priority, low first) looking
for any groups which want to receive notification about FAN_OPEN and we
will find the group 'open_grp' that was registered above. An
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
is finished with it) and will return the read() call to userspace.

The listener process will get a string that looks like "fd=10 cookie=0
mask=10."  This is telling the listener process that a new fd has been
created, #10.  The cookie (if this notification required an access
decision) was 0 and the mask of the event was 0x10 (FAN_OPEN.)

The listener process must call close(10) when it is finished with this
new fd.  But lets assume the listener, for whatever reason, decides it
doesn't want to hear any more of this type of message for this inode.
That means the listener process needs to "create a fastpath" entry.  To
do this the listener process needs to open (or have open) the fastpath
file.  After that all it needs to do is write to that file something
like "10 0x10."  This says 'create a fastpath entry for the inode
associated with my fd #10 for events of type 0x10 (FAN_OPEN).'

Inside the kernel (fanotify_fastpath_add()) what happens is that we will
create a new fanotify_fastpath_entry for the group and mask in question
and attach it to the inode.  The next time a process opens the inode in
question we will search the global groups list for a group that matches
the mask and we will look at the inode to see if there is a fastpath
entry for this group and mask.  If there is an entry no event will be
added to the group->event_list.

This is the end of 'a day in the life of fanotify when there are no
access decisions.'

Assuming the event was for FAN_OPEN_ACCESS much of the above is the
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


 fs/Kconfig                    |   39 --
 fs/Makefile                   |    5 
 fs/aio.c                      |    7 
 fs/compat.c                   |    5 
 fs/dnotify.c                  |  194 ----------
 fs/inode.c                    |    6 
 fs/inotify.c                  |  773 ------------------------------------------
 fs/inotify_user.c             |  768 -----------------------------------------
 fs/nfsd/vfs.c                 |    4 
 fs/notify/Kconfig             |   52 ++
 fs/notify/Makefile            |    6 
 fs/notify/access.c            |  160 ++++++++
 fs/notify/access_user.c       |  144 +++++++
 fs/notify/dnotify.c           |  194 ++++++++++
 fs/notify/fanotify.c          |  172 +++++++++
 fs/notify/fanotify.h          |  159 ++++++++
 fs/notify/fastpath.c          |  204 +++++++++++
 fs/notify/fastpath_user.c     |  159 ++++++++
 fs/notify/group.c             |  204 +++++++++++
 fs/notify/group_user.c        |  158 ++++++++
 fs/notify/info_user.c         |   85 ++++
 fs/notify/inotify.c           |  773 ++++++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify_user.c      |  768 +++++++++++++++++++++++++++++++++++++++++
 fs/notify/notification.c      |  174 +++++++++
 fs/notify/notification_user.c |  306 ++++++++++++++++
 fs/open.c                     |    7 
 fs/read_write.c               |   14 
 include/linux/fanotify.h      |   76 ++++
 include/linux/fs.h            |    5 
 include/linux/fsnotify.h      |   31 +
 include/linux/sched.h         |    1 
 31 files changed, 3859 insertions(+), 1794 deletions(-)

(without the inotify/dnotify move its more like 2000 insertions 50 deletions)

01-fsnotify-subdir: move inotify and dnotify into a subdir
02-fsnotify-files-not-inodes - pass files not inodes to fsnotify
03-fanotify - basic implementation of groups and notification
04-fanotify-group-info - export info about groups RO
05-fanotify-fastpaths - implementation of fastpaths
06-fanotify-group-priorities - add group priorities
07-fanotify-access-decisions - access file and permissions
08-fanotify-access-reset-timer - reset the timeout for a read if listener still working
09-fanotify-metadata-pid - send original process pid to listener
10-fanotify-metadata-tgid - send original process tgid to listener
11-fanotify-metadata-flags - send original process f_flags to listener



