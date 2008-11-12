Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYKLQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYKLQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYKLQMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYKLQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:45 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 21/21] fanotify: add Documentation
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:12:17 -0500
Message-ID: <20081112161217.25434.80361.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an example/test program which exercises all of fanotify's abilities and
include all of my writeup about fanotify in Documentation.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 Documentation/filesystems/fanotify/fanotify.txt    |  214 +++++++++++++++++
 .../filesystems/fanotify/fanotify_tester.c         |  255 ++++++++++++++++++++
 2 files changed, 469 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/fanotify/fanotify.txt
 create mode 100644 Documentation/filesystems/fanotify/fanotify_tester.c

diff --git a/Documentation/filesystems/fanotify/fanotify.txt b/Documentation/filesystems/fanotify/fanotify.txt
new file mode 100644
index 0000000..b07d401
--- /dev/null
+++ b/Documentation/filesystems/fanotify/fanotify.txt
@@ -0,0 +1,214 @@
+fanotify is a new fscking all notify subsystem.  Much as inotify
+provides notification of filesystem activity for some registered subset
+of inodes fanotify provides notification of filesystem activity for ALL
+of the system's S_ISREG() files.  fanotify has a smaller number of
+notifications than inotify.
+
+User interface work can be found in net/fanotify.  Events are pulled from
+the kernel using getsockopt() and responses are sent to the kernel using
+setsockopt.  An example program which implements most if not all of the
+fanotify features can be found in the documentation directory. 
+
+The main implementation is in fs/notify/.  My layout is like so
+
+fanotify.c     --- all functions called from the main kernel
+group.c        --- groups are my implementation of my multiple listeners
+                   you can register different groups to get different
+                   event types.
+notification.c --- implementation surrounding the sending of events to a
+                   userspace listener.
+fastpath.c     --- implementation surrounding the addition of inode
+                   fastpath entries for performance.
+access.c       --- implementation surrounding the processing of
+                   responses from userspace when the events require
+                   a response.
+
+GROUPS AND EVENTS:
+A "group" registers with fanotify and in doing so indicates what that
+group should be called, what types of events it wishes to receive and
+in what order it should receive events relative to other groups.  An
+"event" is simply a notification about some filesystem action.  The list
+of all fanotify events are read, write, open_for_exec, open,
+close_was_not_writable, close_was_writable, open_need_access_decision,
+read_for exec_need_access_decision, read_need access_decisions.  Any number
+of groups may be created for any subset of event types.  One group may
+register to get reads and writes while another maybe register for opens
+and read_need_access_desision.
+
+Any number of userspace listeners may be active in a single group.  Each
+group will get ONE copy of a given filesystem event.  If there are 10
+listeners in a single group and one fanotify event is generated only ONE
+of those listeners will get the event.  If more than one group registers
+for the same type of event one listener in EACH GROUP will get a copy of
+that event.
+
+It all starts when a listener registers a group.  Registering a group
+is as done by binding group information to a fanotify socket.  Simple
+operation is something like.
+
+addr.name = 123
+addr.priority = 456
+addr.mask = 0x002
+
+sock = socket(PF_FANOTIFY);
+fd = bind(sock, addr);
+
+123 is just the name of the group, used so it is unlikely two listeners
+will accidentally use the same priority and mask and stumble into each
+others events.  456 is the priority (only interesting for blocking/access
+events, will describe later) and 0x002 is FAN_WRITE.  If one wanted read
+and write you would use 0x03 = (FAN_ACCESS | FAN_WRITE).  If this is the
+first time a process has bound to this address a struct fanotify_group
+is allocated and initialized (see fanotify_find_group()).  The group is
+added to a kernel global list called groups.
+
+The listener should now call getsockopt(fd, FANOTIFY_GET_EVENT,...).
+Since at this point there are no events this will block waiting for an
+event.
+
+Now lets say the original process calls open().  Open is going to happen
+exactly as before until it gets to the fsnotify code (this is where both
+inotify and dnotify hook into the kernel.)  From fsnotify we will call
+into the function fanotify() with the mask FAN_OPEN.  We will then walk
+to global groups list (which is ordered by priority, low first) looking
+for any groups which want to receive notification about FAN_OPEN and
+let's say we will find the group '123' that was registered above. An
+fanotify_event is allocated and any data we want the listener process to
+get about the original process is added to the fanotify_event.  The
+event contains a struct path with the dentry and vfsmount from the open
+done by the original process.
+
+Now we call add_event_to_group_notification() to add the event to the
+group->notification_list.  This function has a little bit of magic.
+Since an event may be needed in multiple groups notification_list I
+created a helper structure, a struct fanotify_event_holder.  Each entry
+in the group->event_list points to a unique event_holder which in turn
+points to the ref counted event in question.
+
+(assuming 2 groups)
+group1->notification_list ==> fanotify_event_holder1 ==> single_fanotify_event
+group2->notification_list ==> fanotify_event_holder2 ==> single_fanotify_event
+
+The magic is that since we will always need at least 1 holder I embedded
+one fanotify_event_holder inside an fanotity_event.  This means that
+when removing an event from the group->notification_list we may need to
+free the fanotify_event_holder (if it was allocated seperately) or we
+may need to just clear it (if it was the embedded holder.)
+
+After the event is added to the group->notification_list we wake up the
+listener processes.  The original process never blocked and at this
+point and is returning to userspace with the completed open.
+
+Simultaneously the listener process will now remove the event from the
+group->notification_list, see remove_event_from_group_notification().
+Create a new file, fd, and install such in the listener process, see
+fanotify_notification_read().  We will put_event (since this group
+is finished with it) and will return the getsockopt() call to userspace.
+
+The listener process will get a structure filled back from teh
+getsockopt call which will include an fd and some metadata about that
+fd.  This includes things like the original files f_flags, the original
+processes pid and things like that.
+
+The listener process must call close() when it is finished with this
+new fd.  But lets assume the listener, for whatever reason, decides it
+doesn't want to hear any more of this type of message for this inode.
+That means the listener process needs to "create a fastpath" entry.  To
+do this the listener process will need to call setsockopt(fd,
+FANOTIY_SET_FASTPATH, ...) the struct with the setsockopt will include
+things like what kind of events we don't want to hear about and what
+file this is associated with.  All fastpaths will be cleared on the next
+fsnotify write event (happens the same place in the code as mtime
+update)
+
+Inside the kernel (fanotify_fastpath_add()) what happens is that we will
+create a new fanotify_fastpath_entry for the group and mask in question
+and attach it to the inode.  The next time a process opens the inode in
+question we will search the global groups list for a group that matches
+the mask and we will look at the inode to see if there is a fastpath
+entry for this group and mask.  If there is an entry no event will be
+added to the group->event_list.
+
+The need for fastpaths (or calling what it really is, an in kernel
+cache) has been questioned.  I decided to include a little unscientific data
+here.  On a 32 way machine a make -j 32 took about 9 minutes 12 seconds.
+With that same machine running having one group and 32 listeners receiving
+every fanotify event that the kernel could send to userspace while the 
+listeners were responding to accesses as fast as they could (just a very tight get
+event, allow loop) it took 95 minutes 12 seconds.  Same process with in kernel
+fastpaths/cache results took 19 minutes 5 seconds.  More reasonable event
+requirements and a single listener took 10 minutes 35 sec.  So about a 15%
+perf hit to do any kind of permission checking to userspace.  Anyway, the need
+for fastpaths is quite clear.
+
+Assuming the event was for FAN_OPEN_PERM much of the above is the
+same.  Biggest difference is that the place from the kernel we will call
+into the fanotify code is different (fsnotify is not in a good place to
+provide security hooks).  If a group is found that wants this event the
+event is added to the group->access_list AND to the group->event_list.
+The original process is then blocked for a (now fixed 5 second) timeout
+waiting for the event to get a non-zero event->response on the
+group->access_waitq.
+
+The listener process will get a notification exactly as above from the
+notification file but this time will need to write an answer to the
+access file.  The answer is again a simple string indicating the cookie
+and the response (allow/deny).  If a response is received from userspace
+the event is removed from the group->access_list and the original
+process is woken up to continue, either by looking for the next group or
+by returning -EPERM.  Userspace may also return FAN_RESETTIMER which
+will reset the 5 second timeout.  A badly behaving userspace may hang an
+open indeffinetly.
+
+If the original process times out waiting for the listener process to
+give a response we currently just allow the security access.
+
+An interesting part of the code is fastpath cleanup handling.  Any time
+fanotify gets a FAN_MODIFY event we clear the fastpath entries for the
+associated inode.  This means our notification and access decisions are
+NOT race free but the races are small.  This is not perfect security.  A
+'problomatic' sequence of events would be like such
+
+process1 calls read on file
+listener scans file and finds it safe
+process2 writes to file
+listener creates a fastpath entry for file
+
+Maybe I should add an explicit clear fastpath request so userspace can
+close that race when it gets the write notification on file (if it so
+chooses.)  Remember I'm not trying to protect against a rogue process
+intelligently and actively attacking the system.  I'm trying to stop a
+correctly functioning yum from reading a bad rpm that it downloaded.
+I'm trying to stop an NFS server from accepting bad files and then
+apache serving them out on the net.
+
+There is the also a race between when a process calls mmap() (at that
+point we get an event and scan) and when the process actually faults in
+a page which may have been changed by a write from another process.  Its
+not perfect, but it's damn sure better than what we have now.
+
+Object lifetime:
+
+fanotify_group - exists from registration to unregistration.
+Unregistration racing with some the associated special file notification
+open was a bitch to figure out but eventually I based it on the groups
+existence in the global groups list.
+
+fanotify_event - created inside the main fanotify loop which runs the
+events list.  An event lasts until both the main loop ends AND the event
+is no longer needed by all groups for which it was queued.  A refcnt on
+the event is taken every time it is added to a group notification/access
+list and is dropped when the group has removed the event from the list
+and is finished with its contents.
+
+fanotify_event_holder - allocated when an event is added to a group
+notification/access list.  destroyed when an event is removed from a
+notification/access list.  There is the special case of the embedded
+holder inside the fanotify_event.  The embedded holder is assumed to be
+available for use if holder->event_list is empty.
+
+fanotify_fastpath_entry - created when a process writes to the fastpath
+special file and added to the inode list.  This entry is destroy in 3
+possible places.  If an inode has a modify event we flush them all.  If
+an inode is eviced from core we flush them all.  If a group is
+unregistered we flush them all for that group.
diff --git a/Documentation/filesystems/fanotify/fanotify_tester.c b/Documentation/filesystems/fanotify/fanotify_tester.c
new file mode 100644
index 0000000..ba5e830
--- /dev/null
+++ b/Documentation/filesystems/fanotify/fanotify_tester.c
@@ -0,0 +1,255 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/socket.h>
+#include <signal.h>
+
+#include "fanotify.h"
+
+typedef void (*sighandler_t)(int);
+
+#ifndef SOL_FANOTIFY
+#define SOL_FANOTIFY 276
+#endif
+
+#ifndef AF_FANOTIFY
+#define AF_FANOTIFY 36
+#endif
+
+#ifndef PF_FANOTIFY
+#define PF_FANOTIFY AF_FANOTIFY
+#endif
+
+#define SEND_FASTPATH		0x01
+#define SEND_ACCESS_ALLOW	0x02
+#define SEND_ACCESS_DENY	0x04
+#define SEND_DELAY		0x08
+#define SEND_SURVIVE_WRITE	0x10
+
+#define SEND_ACCESS		(SEND_ACCESS_ALLOW | SEND_ACCESS_DENY)
+
+/* file descriptor we use for fanotify */
+int fan_fd;
+int get_evicted = 0;
+
+static int __send_fastpath(int fd, unsigned int mask)
+{
+	struct fanotify_so_fastpath fastpath;
+
+	fastpath.fd = fd;
+	fastpath.mask = mask;
+
+	return setsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_SET_FASTPATH, &fastpath, sizeof(struct fanotify_so_fastpath));
+}
+
+static int send_fastpath(struct fanotify_event_metadata *data)
+{
+	return __send_fastpath(data->fd, data->mask);
+}
+
+static int send_survive_write(struct fanotify_event_metadata *data)
+{
+	return __send_fastpath(data->fd, FAN_SURVIVE_WRITE);
+}
+
+static int send_access(struct fanotify_event_metadata *data, int allow)
+{
+	struct fanotify_so_access access;
+
+	access.cookie = data->cookie;
+	if (allow)
+		access.response = FAN_ALLOW;
+	else
+		access.response = FAN_DENY;
+
+	return setsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_SEND_RESPONSE, &access, sizeof(struct fanotify_so_access));
+}
+
+static int send_delay(struct fanotify_event_metadata *data)
+{
+	struct fanotify_so_access access;
+
+	access.cookie = data->cookie;
+	access.response = FAN_RESETTIMER;
+
+	return setsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_SEND_RESPONSE, &access, sizeof(struct fanotify_so_access));
+}
+
+/* timeout is in msec */
+static int send_set_timeout(int timeout)
+{
+	return setsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_SET_TIMEOUT, &timeout, sizeof(int));
+}
+
+static void clear_all_fastpath(int signum __attribute__((unused)))
+{
+	setsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_CLEAR_ALL_FASTPATH, NULL, 0);
+}
+
+static int get_response_opts(struct fanotify_event_metadata *data, char *path)
+{
+	unsigned int flags = 0;
+
+	if (data->fd < 0)
+		return flags;
+
+	if (data->mask & FAN_ALL_EVENTS_PERM)
+		flags = SEND_ACCESS_ALLOW;
+
+	if (!strcmp("/root/denyme", path)) {
+		flags &= ~SEND_ACCESS_ALLOW;
+		flags |= SEND_ACCESS_DENY;
+	} else if (!strcmp("/root/ignoreme", path)) {
+		flags = 0;
+	} else if (!strcmp("/root/delayme", path)) {
+		if (data->mask & FAN_ALL_EVENTS_PERM)
+			flags |= SEND_DELAY;
+	} else if (!strcmp("/root/surviveme", path)) {
+		flags |= (SEND_SURVIVE_WRITE | SEND_FASTPATH);
+	} else if (!strcmp("/root/evictme", path)) {
+		get_evicted = 1;
+	} else {
+		flags |= SEND_FASTPATH;
+
+		if (data->mask & FAN_ALL_EVENTS_PERM)
+			flags |= SEND_ACCESS_ALLOW;
+	}
+
+	if (get_evicted)
+		flags = 0;
+
+	return flags;
+}
+
+static int bind_fan_fd(char *argv[])
+{
+	struct fanotify_addr addr;
+	unsigned int priority;
+	unsigned int group_num;
+	unsigned int mask;
+
+	group_num = atoi(argv[1]);
+	priority = atoi(argv[2]);
+	mask = strtol(argv[3], (char **) NULL, 16);
+
+	memset(&addr, 0, sizeof(struct fanotify_addr));
+	addr.group_num = group_num;
+	addr.priority = priority;
+	addr.mask = mask;
+
+	return bind(fan_fd, (struct sockaddr *)&addr, sizeof(struct fanotify_addr));
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	unsigned long cnt;
+	socklen_t len;
+	sighandler_t sig;
+	struct fanotify_event_metadata metadata;
+	char readbuf[4096];
+	char path[4096];
+	unsigned int response_opts;
+
+	if (argc != 4) {
+		fprintf(stderr, "usage: %s group_num priority mask\n", argv[0]);
+		return 1;
+	}
+
+	sig = signal(SIGUSR1, clear_all_fastpath);
+	if (sig == SIG_ERR) {
+		fprintf(stderr, "unable to set the signal handler\n");
+		return 1;
+	}
+
+	fan_fd = socket(PF_FANOTIFY, SOCK_RAW, 0);
+	if (fan_fd == -1) {
+		perror("Creating socket");
+		return 1;
+	}
+
+	ret = bind_fan_fd(argv);
+	if (ret) {
+		perror("Binding");
+		goto out;
+	}
+
+	ret = send_set_timeout(1000);
+	if (ret) {
+		perror("Setting timeout");
+		goto out;
+	}
+
+	cnt = 0;
+
+	while (1) {
+		len = sizeof(struct fanotify_event_metadata);
+		/* get an event */
+		ret = getsockopt(fan_fd, SOL_FANOTIFY, FANOTIFY_GET_EVENT, &metadata, &len);
+		if (ret) {
+			perror("getsockopt");
+			goto out;
+		}
+
+		/* get the path */
+		if (metadata.fd >= 0) {
+			snprintf(readbuf, sizeof(readbuf), "/proc/self/fd/%d", metadata.fd);
+			ret = readlink(readbuf, path, sizeof(path)-1);
+			if (ret > 0)
+				path[ret] = '\0';
+			else
+				strcpy(path, "<error>");
+		} else {
+			strcpy(path, strerror(-metadata.fd));
+		}
+
+		/* using the event and path figure out how to respond */
+		response_opts = get_response_opts(&metadata, path);
+
+		/* should we send a fastpath? */
+		if (response_opts & SEND_FASTPATH) {
+			ret = send_fastpath(&metadata);
+			if (ret)
+				perror("Sending fastpath");
+		}
+
+		/* should out fastpath entry survive writes? */
+		if (response_opts & SEND_SURVIVE_WRITE) {
+			ret = send_survive_write(&metadata);
+			if (ret)
+				perror("Sending survive write");
+		}
+
+		/* should we delay this operation? */
+		if (response_opts & SEND_DELAY) {
+			int i;
+			for (i = 0; i < 14; i++) {
+				ret = send_delay(&metadata);
+				if (ret)
+					perror("Sending delay");
+				/* timeout is 1,000,000 so sleep for 750,000 */
+				usleep(750000);
+			}
+		}
+		/* do we need to send an access response? */
+		if (response_opts & SEND_ACCESS) {
+			ret = send_access(&metadata, !!(response_opts & SEND_ACCESS_ALLOW));
+			if (ret)
+				perror("Sending access");
+		}
+
+		/* dump something on the console so we know what events we took */
+		fprintf(stdout, "#%lu: mask:%x cookie:%llu fd:%d pid:%d tgid:%d f_flags:%x path:%s\n",
+			cnt++, metadata.mask, metadata.cookie, metadata.fd, metadata.pid, metadata.tgid,
+			metadata.f_flags, path);
+
+		/* if we got an open fd we need to close it */
+		if (metadata.fd >= 0)
+			close(metadata.fd);
+	};
+
+out:
+	close(fan_fd);
+	return ret;
+}

