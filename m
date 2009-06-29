Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZF2UJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZF2UJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZF2UJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:09:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZF2UJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:09:00 -0400
Subject: fanotify: the fscking all notification system
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
Content-Type: text/plain
Date: Mon, 29 Jun 2009 16:08:45 -0400
Message-Id: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's back to that time.  I'm not quite sure how to present fanotify.
I can start sending patches (they are available), but this message is
just going to be a re-into, what questions and problems are still out
there?

Long ago the anti-malware vendors started asking the community for a
reasonable way to do on access file scanning, historically they have
used syscall table rewrites and binary LSM hook hacks to get their
information.  Customers and Linux users keep demanding this stuff and in
an effort give them a supportable method to use these products I have
been working to develop fanotify.

fanotify provides two things:
1) a new notification system, sorta like inotify, only instead of an
arbitrary 'watch descriptor' which userspace has to know how to map back
to an object on the filesystem, fanotify provides an open read-only fd
back to the original object.  It should be noted that the set of
fanotify events is much smaller than the set of inotify events.

2) an access system in which processes may be blocked until the fanotify
userspace listener has decided if the operation should be allowed.

There was a long discussion in which I was asked to define the security
model being implemented and at the end of the day the answer is that
there is no security model here.  This is NOT an LSM.  This is not
intended to provide system security.  fanotify is intended to provide an
interface for on access file scanning and permissions gating based on
the results of those scans.  fanotify does not prevent, nor does it
attempt to prevent, malicious code running on the Linux machine.  Read
that again, once malicious code is running on the Linux machine this
interface (along with whatever magic someone creates in userspace) is
not intended to prevent malicious actions.  There is some hope in that
if userspace can identify the malicious code it could prevent it from
every being executed by a normal program and so there is clearly
security benefit possible, but it is a very very weak assurance.  Those
long discussion can be found at:
http://thread.gmane.org/gmane.linux.kernel.malware/22
http://thread.gmane.org/gmane.linux.kernel/716539

fanotify is close to working, although some of the 'features' are
completely untested and a couple are unimplemented but it's pretty
close.  It's currently implemented over 34 patches which hopefully are
each small enough for good review, I'll be sending them a couple or so
at a time for review but first I want to make sure we are all on the
same page....

fanotify has two basic 'modes' directed and global.  fanotify directed
works much like inotify in that userspace marks inodes it is interested
in and gets events from those inodes.  fanotify global instead indicates
that it wants everything on the system and then individually marks
inodes that it doesn't care about.  They both have the same userspace
interface and rely on the same fsnotify in kernel infrastrucute
(although the infrastructure did have to modified to support the global
listener concept)

In either case the fanotify userspace interface is based on socket calls
loosely of this format.  

1) open an fanotify socket
2) bind the socket here you define yourself and directed or global and
if global define all the events you want.
2.5) if directed call setsockattr to attach marks to inodes you care
about.
3) call getsockattr on the socket to get back data about events that
took place and to get fd's opened in your context

At the very end of the message is a small program which, might even
build, and will printf for every single open that takes place on the
system as a reference for a brief understanding of the interface.
(although it does not provide an example of access decisions)

fanotify has a limited set of events, open, close, access(read),
modify(write) and a permissions event for open and modify.  fanotify
provides no means to notice mv/rename.  This is something I plan to look
into to simplify fanotify's use for use file indexers, but at this time
the requisite information is not available in the right places in the
kernel.

When userspace gets an event it comes in the form of one or more struct
fanotify_event_metadata in the getsockopt buffer.

struct fanotify_event_metadata {
        __u32 event_len;
        __s32 fd;
        __u32 mask;
        __u32 f_flags;
        pid_t pid;
        pid_t tgid;
        __u64 cookie;
}  __attribute__((packed));

This provides information about the event including the type, the
location of the new fd that was opened pointing to the object in
question, and it provides information about the process which triggered
the event.

If the event was a permissions gating event type (FAN_ACCESS_PERM |
FAN_OPEN_PERM) then cookie will be non-zero and userspace will need to
tell the kernel if the original calling process should be allowed or
denied.  This is done with a setsockopt() call passing the

struct fanotify_so_access {
        __u64 cookie;
        __u32 response;
}  __attribute__((packed));

In which this answer indicates the cookie from the event in question and
the response (allow/deny)

The third type of message, the inode mark, is done by passing

struct fanotify_so_inode_mark {
        __s32 fd;
        __u32 mask;
        __u32 ignored_mask;
}  __attribute__((packed));

to a setsockopt() call.  If using fanotify in a 'directed' manor this
will mark an inode that we are interested in events in mask.  The
ignored mask is used to indicate events we no longer want to hear,
although the ignored mask is cleared on inode modification.  So if one
were to register FAN_ACCESS and after the first one send FAN_ACCESS in
the ignored_mask userspace would not get any more FAN_ACCESS events
until after the inode was next modified.

fanotify global groups use these similarly, only they are unable to set
anything in the mask and can only use the ignored_mask.

So what problems do people have?  What complaints?  What questions?
What do you want to know?  What do you wish it could do?  How could this
interface be better?  What other information do you want?

Later today a 'working' set of fanotify patches should be available at
  git://git.infradead.org/users/eparis/notify.git fanotify-experimental
THIS BRANCH WILL REGULARLY REBASE, I'm not trying to work nicely with
downstream trees!  Patches gladly accepted, merge requests? not so much.

[paris@paris kernel-2]$ git diff f82c9a712458d835 | diffstat -p1
 fs/compat.c                          |    5 
 fs/exec.c                            |    7 
 fs/nfsd/vfs.c                        |    4 
 fs/notify/Kconfig                    |   13 
 fs/notify/Makefile                   |    2 
 fs/notify/dnotify/dnotify.c          |    7 
 fs/notify/fanotify/Kconfig           |   27 +
 fs/notify/fanotify/Makefile          |    1 
 fs/notify/fanotify/af_fanotify.c     |  694 +++++++++++++++++++++++++++++++++++
 fs/notify/fanotify/af_fanotify.h     |   21 +
 fs/notify/fanotify/fanotify.c        |  364 ++++++++++++++++++
 fs/notify/fanotify/fanotify.h        |   38 +
 fs/notify/fsnotify.c                 |   86 +++-
 fs/notify/fsnotify.h                 |    9 
 fs/notify/group.c                    |  128 +++++-
 fs/notify/inode_mark.c               |   16 
 fs/notify/inotify/inotify_fsnotify.c |   50 ++
 fs/notify/inotify/inotify_user.c     |    4 
 fs/notify/notification.c             |  167 +++++---
 fs/notify/second_q.c                 |  128 ++++++
 fs/open.c                            |    2 
 fs/read_write.c                      |    8 
 include/linux/Kbuild                 |    1 
 include/linux/fanotify.h             |  134 ++++++
 include/linux/fsnotify.h             |   60 ++-
 include/linux/fsnotify_backend.h     |   80 +++-
 include/linux/init_task.h            |    8 
 include/linux/sched.h                |    4 
 include/linux/security.h             |    5 
 include/linux/socket.h               |    5 
 kernel/audit_tree.c                  |    7 
 kernel/audit_watch.c                 |    7 
 kernel/fork.c                        |    5 
 net/core/sock.c                      |    6 
 security/security.c                  |   18 
 35 files changed, 1955 insertions(+), 166 deletions(-)

Example program to printf for every open on a system!

int main(void) {
	int fan_fd, len;
	struct fanotify_addr addr;
	socklen_t socklen;
	char buf[4096];
	struct fanotify_event_metadata *metadata;
        
        memset(&addr, 0, sizeof(addr));
        addr.family = AF_FANOTIFY;
        addr.group_num = 123456;
        addr.priority = 32768;
        addr.mask = FAN_OPEN | FAN_GLOBAL_LISTENER;

        fan_fd = socket(PF_FANOTIFY, SOCK_RAW, 0);
	bind(fan_fd, (struct sockaddr *)&addr, sizeof(addr));
	while (1) {
		socklen = sizeof(buf);
		getsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_GET_EVENT,
			   buf, &socklen);
		metadata = &buf;
		len = socklen;
		while(FAN_EVENT_OK(metadata, len)) {
			printf("got event!\n"
			close(metadata->fd);
			metadata = FAN_EVENT_NEXT(metadata, len);
		}
	}
}

