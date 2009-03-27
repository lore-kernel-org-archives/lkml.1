Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZC0Mrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZC0Mrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZC0Mre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:47:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZC0Mrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:47:33 -0400
Subject: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 27 Mar 2009 13:47:23 +0100
Message-Id: <1238158043.23703.20.camel@fatty>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took a look at fanotify to see if it would be a better fit for a
filesystem indexer (like tracker or beagle), as inotify is pretty bad.
I think it is a better fit in general, but it needs some additions.

Lets first define the requirements. By "indexer" I mean a userspace
program that keeps a database that stores information about files on
some form of pathname basis. You can use this to do a query for
something and reverse-map back to the filename. As a minimally complex,
yet sufficient model we have locate/updatedb that lets you quickly
search for files by filename. However, instead of indexing everything
each night we want to continuosly index things "soon" after they change,
for some loose definition of soon (say within a few minutes in the
normal case). 

Its not realistic to imagine the indexer handling each file change as
they happen, as modern machines can dirty a lot of files in a short
time which would immediately result in change event queues
overflowing. It as also not really what isis desired. Many kinds of
activities produce a lot of filesystem activity with creation of
temporary files and changing of files multiple times over some time
(for instance a compile). What we really want is to ignore all these
temporary files and the flury of changes and wait for a more quiescent
state to reindex.

One of the core properties of the indexer is that it knows what the
filesystem looked like last time it indexed, so a more adequate model
for changes would be to get told on a per-directory basis that
"something changed in this directory" with a much more coarse-grained
time scale, say e.g. at most once every 30 seconds. The indexer could
then schedule a re-indexing of that directory, comparing mtimes with
what is stored in its db to see which files changed. This is how the
MacOS FSEvents userspace framework[1] works, and it seems reasonable.  

updatedb keeps track of the full filesystem tree, based on the
"current" mounts in it (at the time updatedb ran). While this was
probably valid when it was designed it is not really adequate for
current use which is much more dynamic in how things get plugged in and
out. A more modern way to look at this is to consider the full set of
mounted filesystems being a forrest of trees, with the current process
namespace being composed of a subset of these mounted in various places
in the namespace.

So, in order to handle a filesystem being unmounted, and then later
e.g. mounted in another place or another filesystem mounted in the
same location we shouldn't index based on how things are mounted, but
rather keep an index per filesystem. The kernel identifier for a
filesystem is the major:minor of the block device its mounted on. This
is not a persistent identifier, but given such an identifier a
userspace app could use a library like libvolume_id to make up a
persistent identifier for use as the key in its index. It would then
store each item in its database by a volume id + relative path pair,
which can be mapped to a pathname in the current namespace by using
e.g. /proc/self/mountinfo.

In order to write an app using the fanotify API satisfying the above
needs we would need the following events:
* the event queue overflowed, (you need to reindex everything)
* An inode was linked into the filesystem (creat, O_CREAT,
mkdir, link, symlink, etc)
* An inode was unlinked (unlink, rmdir, rename replaced existing file)
* An inode was moved in the filesystem (rename)
* A file handle that was written to was closed
* optionally: A file handle was written to (this is somewhat expensive
to track as there are a lot of these events)

For these events we need some form of identifier that references the
file that was affected. There are two types of changes above, pure
name changes (link/unlink/rename) and inode changes
(close/write). fanotify currently only gives "inode changes" kind of
events, and it uses a file descriptor as the identifier.

Using an fd as an identifier is interesting, because it avoids the
problems with absolute pathnames and namespaces. The user of the API
can use readlink on /proc/self/fd/<fd> to get at the pathname of the
file that was opened (in its namespace), we can also use fstat to get
the block device of the file and /proc/self/mountinfo to calculate the
filesystem relative path. Additionally, by using a fd like this we're
basically given a userspace reference to a dentry. This means that the
link in /proc will be updated as the filename changes. So we can rely
on the paths gotten from the events to be up to date wrt any namespace
changes during the time of the change to the time we're handling the
event. We don't have to manually update events due to e.g. later
rename events.  

However, this is somewhat of a problem in the name change events. For
instance, for rename if we have an fd to the moved file we can't
really know its original position. For these types of changes we want
the fd of the parent directory and the filename that changed. 

With these events we should be able to track any directory that has
changed files in it, with these exceptions:
* Sometimes we can only say "everything might have changed" (queue
overflow)
* We only track locally originating changes
* If a hardlinked file is updated in-place we only know of the change
in the filename used to open the file.
* If we chose not to pick up every write event (for performance
reasons) we won't know of writes to files that weren't closed (like
e.g. logfiles)

I think these exceptions are reasonable for most usecases.

Its unlikely that users actually want to index all files in the
system. In practice its more likely that they want to index their
homedirs, removable media and maybe a few other directories. So, in
order to lower the total system load due to changes on areas where we're
not interested in changes it would be nice to be able to set up either
blacklists like the current fastpath, or even better subscriptions,
where we ignore everything not specifically requested. I don't really
think the fastpaths that are currently in fanotify are good enought
for file indexing, as they are per file, and there are potentially
millions of files that we want to ignore.

Instead I would like a form of subscription based on block major+minor
and dentry prefix. So, you'd say "I want everything on block 8:1
affecting the subtree under the dentry specified by this fd I
opened". The fd should be optional, and probably the minor nr too. In 
fact, even the major nr should probably be optional too if you really
want events for every change in the system. In an indexer this would
be used by reading the set of paths that the user specified as
wanting indexed, looking up in /proc/self/mountinfo what this
corresponds to wrt devices and registering the required subscriptions.

---

[1] http://arstechnica.com/apple/reviews/2007/10/mac-os-x-10-5.ars/7


