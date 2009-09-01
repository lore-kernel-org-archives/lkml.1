Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZIAUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZIAUTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZIAUTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:19:44 -0400
Received: from THUNK.ORG ([69.25.196.29]:45763 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbZIAUTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:19:44 -0400
Date: Tue, 1 Sep 2009 16:19:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point
	dirent.d_ino
Message-ID: <20090901201943.GB6996@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jim Meyering <jim@meyering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87y6oyhkz8.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6oyhkz8.fsf@meyering.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 03:07:23PM +0200, Jim Meyering wrote:
> Currently, on all unix and linux-based systems the dirent.d_ino of a mount
> point (as read from its parent directory) fails to match the stat-returned
> st_ino value for that same entry.  That is contrary to POSIX 2008.

The language which you referenced has been around for a very long
time; it's not new to POSIX.1-2008.  At the same time, the behaviour
of what is returned for direct.d_ino at a mount point has been around
for a very long time, and it's not new either.  Furthermore, there are
plenty of Unix systems that have received POSIX certifications despite
having this behavior.  (I just checked and Solaris behaves exactly the
same way, as I expect; pretty much all Unix systems work this way.)

If you're going to quote chapter and verse, the more convincing one
would probably be from the non-normative RATIONALE section for
readdir():

    When returning a directory entry for the root of a mounted file
    system, some historical implementations of readdir() returned the
    file serial number of the underlying mount point, rather than of
    the root of the mounted file system. This behavior is considered
    to be a bug, since the underlying file serial number has no
    significance to applications.

> I'm bringing this up today because I've just had to disable an
> optimization in coreutils ls -i:

I'm not sure how many poeple will care about this, since (a) stat(2)
is fast, so this only becomes user-visible in the cold cache case, and
(b) "ls -i" is generally not considered a common case.

Fixing it is also going to be decidedly non-trivial since it depends
on how the directory was orignally accessed.  For example, suppose
/usr is a mount point; and we do a readdir on '/'.  In that case, when
we return 'usr' we should return the inode number of the covering
inode.  But if we have a bind mount ("mount --bind / /root") and we
are calling readdir on the exact same directory, but it was opened via
opendir("/root"), now when we return 'usr', we should return the
underlying directory's inode.  This means that before returning from
readdir, we would have to scan every single directory entry against
the combination of the orignal dentry used to open the directory plus
the d_name field to see if it exists in the current process's mount
namespace.

This would require burning extra CPU time for every single entry
returned by readdir(2), all for catching a case is a technical
violation of the POSIX spec, but which all historical Unix
implementations have had the same behaviour, all to enable an
optimization for a use case ("/bin/ls -i") which isn't very common.
Hence, even a "nyah, nyah, but Cygwin gets this case right" may not be
a big motivator for people to work on making this change to Linux.

Playing devil's advocate for the moment, you could even make the case,
ignoring the non-normative POSIX rationale and writing off standards
authors as wankers who don't care about real world issues, and noting
that in POSIX world, "mounts" are hand-waved away as not being within
the scope of the standard, that the current behaviour makes *sense*.
That is, the inode number of the directory entry is what it is, but
when you mount a filesystem, what happens is when you dereference the
directory entry, you get something else, much like the difference
between what happens with stat(2) vs. lstat(2) in the presence of a
symlink.  It is because it makes *sense* from a computer science point
of view that all Unix implementations do things the same way Linux
does.  Given all of this, it's not surprising that even an OS as anal
about being standards-compliant as Solaris has ignored this one...

						- Ted
