Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYLZA6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYLZA6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 19:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYLZA61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 19:58:27 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64799 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYLZA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 19:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=i4C+TQI8vTm0tZA3TmP7XcmjFm6dD6EHoVlAMwu/2LThLDoJ/bX3egWwTi9tSM2X+A
         Zc1ABRJvTDZvVyhpC6ggAYpiRzXufidDrfr0vTPUqxrvnynyGjzwFeI/2FB/emjqZI/6
         3Z9zQu+E8qbSb7JU4USxuJv8+yQA/75gkrfzM=
Message-ID: <c6d9bea0812251658o4710f761j113fbeec9e5e1c97@mail.gmail.com>
Date: Thu, 25 Dec 2008 19:58:23 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>, "Eric Paris" <eparis@redhat.com>
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081225203302.GS28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com>
	 <1229916126.29604.47.camel@localhost.localdomain>
	 <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com>
	 <20081222210410.GL28946@ZenIV.linux.org.uk>
	 <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
	 <20081222232125.GA25334@infradead.org>
	 <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com>
	 <20081225203302.GS28946@ZenIV.linux.org.uk>
X-Google-Sender-Auth: d49d4ababa472b8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 3:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 25, 2008 at 01:17:28PM -0500, C. Scott Ananian wrote:
>> getcwd doesn't actually hold a file descriptor to the working
>> directory.  If you reread my message, you'll find that I was explicit
>> about where the information was stored.
>
> Indeed - explicit, persistent and wrong.  For current directory of a process
> we store vfsmount and dentry.  And use those in getcwd() rather than playing
> hopeless games with inodes.

Geez.  Please don't treat me as if I can't read source code.

I suggested a Mach-like iopen mechanism to address some inotify races.
 In order to show that extreme VFS violence might not be necessary, I
pointed out that *in some cases* you can derive *some paths* to the
file from the inode number, using the iget()->i_dentry list.  But
you've driven me far off-topic.

Let's get back to the problem at hand.   The most obvious problem with
inotify is the race between mkdir/IN_CREATE and the userspace process
adding the watch on the new directory.  I proposed an 'autoadd'
mechanism earlier in this thread to address this (stolen from the racy
userspace version of this in python-inotify); the "Love-Trowbridge
algorithm" from:
  http://mail.gnome.org/archives/dashboard-hackers/2004-October/msg00022.html
is also targetted at this race.

But this isn't the only problem. The inotify interface on directories
returns (in effect) a <directory inode>,<filename> pair (the directory
watch is per inode; the event includes a filename).  This means that:
   echo foo >a/b; echo bar >a/c; mv a/c a/b
has an inherent race.  Our index service drains the inotify queue and
attempts to open and index a/b.  After the indexing, we check the
queue and discover IN_MOVED_FROM c and IN_MOVED_TO b.  There is no way
for the userspace process to know whether it managed to index the file
before or after the move.  (We're forced to track renames to detect
this situation and then attempt to reindex a/b, and of course we can
have another race; we must repeat until we finally succeed.)  If
inotify provided an inode number or file descriptor instead of a path
name, we'd be able to tell if we were indexing the thing we expected.

But this isn't the end.  How about:
   mkdir -p a/b a/c ; touch a/b/foo a/c/foo
 <read inotify queue here>
   mv a/b a/bb ; mv a/c a/b
When we index a/b/foo, we won't know whether this is the original
a/b/foo or the original a/c/foo.  In this case we can open 'a/b' and
check that the inode number is what we expect before using openat to
open 'foo' (but remember that the previous race means that we're still
not sure 'foo' is what we expect it to be, so we still need to use
that detection algorithm as well).

And remember that we're still expected to keep and update a map in
userspace mapping from directory watch ids to path names, and
presumably keep path name information updated in our search index as
well.  When a directory is moved, we need to recursively update path
information for all files in the index -- unless we keep path
information as <directory inode>;<filename> pairs, which avoids the
recursive update at the expense of having to maintain a redundant copy
of the filesystem's directory structure in userspace.

(These are the races I've found; it's possible there are others.)

As far as I can tell, none of the existing Linux desktop search tools
attempt to deal with these races.  (Beagle handles the 'mkdir' race,
but not the other rename races.)  This is acceptable only if an
unreliable file index is acceptable.

Some possible improvements to the situtation (all bad, in various ways
-- better suggestions wanted!):

  a) do nothing.  Most developers will ignore the races in inotify out
of ignorance or complexity, and most applications which use inotify
will be unreliable as a result.

  b) use inode numbers rather than path names uniformly, in both
inotify and the userland search index, along with an iopen() syscall,
as in Mach.  This decouples path maintenance from indexing.  This was
discussed in (for example)
http://www.coda.cs.cmu.edu/maillists/codalist/codalist-1998/0217.html
by Peter J. Braam and Ted Ts'o, but Al Viro has been objecting to the
idea here.  (If all you need to do is open found files after a search,
you can skip path maintenance entirely.)

 c) Pass file descriptors in the notification API from the kernel.
This solves the races associated with renames before indexing.
Userland still has to maintain its own copy of all the direntries for
indexed content, but at least this task is decoupled.  (The proposed
fanotify API passes file descriptors, but provides no mechanism (yet)
for path maintenance.)

d) Do all indexing in the filesystem.  BeOS used this option; in
Linux-land, this would probably be a thin FUSE shim which layered over
an existing filesystem.  The shim could grab the appropriate locks to
manage the races and ensure that the index's path information was
consistent with the filesystem.

Returning to fanotify, I'll recant some of my earlier judgement:
fanotify already solves the 'mkdir' race in inotify (by virtue of not
requiring separate watches on each directory) and the 'mv before
index' race (by passing an open file descriptor to userland).  If it
provided some basic directory-change support so that path information
can be maintained, it would be a clear win for desktop search, since
by simply processing events in order we can produce a coherent index
state.   The only remaining races would be during the initial scan.
If one wanted the simplest possible correct userspace, perhaps move
and create can be deferred by userland using the fanotify 'approval'
mechanism until the scan is complete.
  --scott

-- 
                         ( http://cscott.net/ )
