Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZKDT3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZKDT3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZKDT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:29:04 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:46682 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbZKDT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:29:03 -0500
From: Jim Meyering <jim@meyering.net>
To: Ulrich Drepper <drepper@gmail.com>, Ulrich Drepper <drepper@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point dirent.d_ino
In-Reply-To: <a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
	(Ulrich Drepper's message of "(unknown date)")
References: <87y6oyhkz8.fsf@meyering.net> <20090901201943.GB6996@mit.edu>
	<a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
Date: Wed, 04 Nov 2009 20:29:00 +0100
Message-ID: <87my32rsw3.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On Tue, Sep 1, 2009 at 13:19, Theodore Tso<tytso@mit.edu> wrote:
>> Furthermore, there are
>> plenty of Unix systems that have received POSIX certifications despite
>> having this behavior.
>
> A common misunderstanding of certification.
>
> Like for all certifications, being POSIX certified doesn't mean the
> certification is valid for all situations.  it only means that there
> is (at least) one configuration which meets the requirements.  In this
> case it means the environment simply uses one single filesystem and no
> mount points.  This way the problem doesn't even arise.
>
>> Fixing it is also going to be decidedly non-trivial since it depends
>> on how the directory was orignally accessed.  [...]
>
> I guess that this is really a difficult way to solve.  I wouldn't want
> to pay for something which is hardly ever really used.
>
> But there are programs out there which would like to use the inode
> uniqueness.  Therefore the next best thing to do is perhaps to return
> a flag in the getdents information (in d_type, perhaps) to indicate
> that this is a mount point and/or that there are multiple ways to
> access the file in question.  Then programs which can use the inode
> information can be watching for this flag and enter the slow path only
> if it's set.

Hi Uli,

Here is another reason to do what you suggest.
This bug report started it:

    on the fly varying device numbers on a NFS mount point
    http://bugzilla.redhat.com/501848

More discussion here:

    http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/18553/focus=18822

The problem is with hierarchy traversals again.  The first time
a mount-point directory is encountered, fts opens it (with openat),
stats it and records dev,ino, and then reads entries.  The first readdir
triggers the automount and thus, the assignment of a new device number
to the already-open directory.  When the traversal process finishes
processing the hierarchy and traverses back "up" to that mount point,
it fails due to the old-st_dev/new-st_dev mismatch.[1]  Normally such
a mismatch indicates that someone is attempting to subvert a traversal,
or perhaps has inadvertently moved a subtree while it's being traversed.
In any case, once such a mismatch has been detected, there is no way
the traversal can safely continue.

One way to accommodate the current automount semantics, is to make fts.c
incur, _for every directory traversed_, the cost of an additional
stat (fstatat, actually) call just in case this happens to be one of
those rare mount points.

I would really rather not pessimize most[*] hierarchy-traversing
command-line tools by up to 17% (though usually far less) in order
to accommodate device-number change semantics that arise
for an automountable directory.

Jim

[*] At least the following GNU tools would be affected: find, chmod,
chown, chgrp, chcon, du, rm, and possibly soon, cp and ls.

[1] Note that if the mounted hierarchy is not too deep (I think it's
4 or 5 levels), cached "active-directory" file descriptors mask the
problem, because when we traverse back to the mount point, we still
have an open file descriptor for that directory.  In that case, we don't
even need to perform the dev/inode comparison.
