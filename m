Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZC3Rgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZC3Rgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbZC3RgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:36:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41243 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZC3RgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:36:16 -0400
Subject: [PATCH] inotify: add hook to catch fsync/msync events
From: Simo Sorce <ssorce@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
       Eric Paris <eparis@redhat.com>, Jeff Layton <jlayton@redhat.com>,
       Rik van Riel <riel@redhat.com>, ssorce <ssorce@redhat.com>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 13:36:07 -0400
Message-Id: <1238434567.3597.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!

Attached find a patch that adds a new IN_SYNC watch type to inotify to catch
fsync/msync events.
A new fsnotify_sync() internal inline function is provided.

This event is triggered when an application explicitly calls fsync() or msync()
on a file to sync the file contents. 
I actually excluded msync events when the MS_ASYNC flag is specified.
I did that because the MS_ASYNC flag basically turns the msync operation into a
complete noop and makes it explicitly useless.
If, for consistency reasons, it is thought that firing on MS_ASYNC msync()
requests is important, I will change the patch to that effect.



And here's the rationale:

There are 2 reasons why I think it is useful to catch an explicit sync
request performed by an application.

1. When using mmap there is no way to be notified of any change to a file.
The normal IN_MODIFY event does not obviously trigger as no write(2) is
performed.
An msync() call, on the other hand normally, signals the application has
finished writing a chunk of coherent data and thinks the data is safe to be
stored on disk as is, this is an "interesting" event.

2. Applications that perform complex operations on a file may do many write(2)
operations on a file, possibly waiting for events between writes, until all
the data is saved and the file is in a consistent state. At that point the
application will perform an fsync to safely store data on disk.
Using IN_MODIFY with these applications may be a lot less interesting than it
would appear at a first glance because each single write tells you only that
something changed but not that what's on disk is necessarily consistent.
An IN_SYNC event instead would signal that the application currently
manipulating the file has very probably reached an interesting state (for an
external observer).

Use case:
Databases that write on disk normally use msync to complete a transaction to
make sure the data is on disk.
What matter in this case is not much when the data actually hits the disk or
that the data is really actually on disk. What matters is that the application
calling the msync thinks the data is actually coherent and good to be stored
on disk.
In my specific case I am using a database engine (TDB) that supports
transactions. This database uses byte range locking and can support multiple
readers (and multiple writers, although not when using transactions) and is
often used as a way to share data between different processes (not necessarily
strictly related processes either).

In some use cases it is useful to know if one of the process changed the
database contents without having to periodically polling the database file
just to find out.

A very good indication that something changed is the fact that a transaction
has been completed and the file is in a "good" state once again. The mechanism
is not interesting for any sort of synchronization between process, but just
to optimize access to the database to check for changes (new records, existing
records changed).

An external application that is interested to know if a database file has
changed (in a meaningful way), would have no other way but to listen for
IN_SYNC events.
As said, when using normal file operations IN_MODIFY events are not necessarily
really interesting, and may cause just way too many needless wakeups on the
listening application. When using mmap, IN_MODIFY is simply not available, so
there is no way to know that a file has changed at all (except, maybe, if it is
closed).

Simo.

P.S: I am not subscribed to these lists, please keep me in CC


>From b614bf00ba1e39105ea064d8ff899de8bff49dc3 Mon Sep 17 00:00:00 2001
From: Simo Sorce <idra@samba.org>
Date: Sun, 29 Mar 2009 11:01:42 -0400
Subject: [PATCH] Add inotify hook to catch fsync/msync events

Signed-off-by: Simo Sorce <ssorce@redhat.com>
---
 fs/sync.c                |    5 +++++
 include/linux/fsnotify.h |   15 +++++++++++++++
 include/linux/inotify.h  |    3 ++-
 mm/msync.c               |    3 +++
 4 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 7abc65f..f2631d2 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/fsnotify.h>
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
@@ -153,6 +154,10 @@ static int do_fsync(unsigned int fd, int datasync)
 		ret = vfs_fsync(file, file->f_path.dentry, datasync);
 		fput(file);
 	}
+
+	if (!ret)
+		fsnotify_sync(file->f_path.dentry);
+
 	return ret;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 00fbd5b..3593ca6 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -166,6 +166,21 @@ static inline void fsnotify_modify(struct dentry *dentry)
 }
 
 /*
+ * fsnotify_sync - file was synced
+ */
+static inline void fsnotify_sync(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	u32 mask = IN_SYNC;
+
+	if (S_ISDIR(inode->i_mode))
+		mask |= IN_ISDIR;
+
+	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
+	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+}
+
+/*
  * fsnotify_open - file was opened
  */
 static inline void fsnotify_open(struct dentry *dentry)
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 37ea289..5a2734a 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -38,6 +38,7 @@ struct inotify_event {
 #define IN_DELETE		0x00000200	/* Subfile was deleted */
 #define IN_DELETE_SELF		0x00000400	/* Self was deleted */
 #define IN_MOVE_SELF		0x00000800	/* Self was moved */
+#define IN_SYNC			0x00001000	/* File was synced */
 
 /* the following are legal events.  they are sent as needed to any watch */
 #define IN_UNMOUNT		0x00002000	/* Backing fs was unmounted */
@@ -63,7 +64,7 @@ struct inotify_event {
 #define IN_ALL_EVENTS	(IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
 			 IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
 			 IN_MOVED_TO | IN_DELETE | IN_CREATE | IN_DELETE_SELF | \
-			 IN_MOVE_SELF)
+			 IN_MOVE_SELF | IN_SYNC)
 
 /* Flags for sys_inotify_init1.  */
 #define IN_CLOEXEC O_CLOEXEC
diff --git a/mm/msync.c b/mm/msync.c
index 4083209..2918d1d 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
+#include <linux/fsnotify.h>
 
 /*
  * MS_SYNC syncs the entire file - including mappings.
@@ -83,6 +84,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 			get_file(file);
 			up_read(&mm->mmap_sem);
 			error = vfs_fsync(file, file->f_path.dentry, 0);
+			if (!error)
+				fsnotify_sync(file->f_path.dentry);
 			fput(file);
 			if (error || start >= end)
 				goto out;
-- 
1.6.0.6


-- 
Simo Sorce * Red Hat, Inc * New York

