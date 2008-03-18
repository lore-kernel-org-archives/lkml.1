Return-Path: <linux-kernel-owner+w=401wt.eu-S966042AbYCSVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966042AbYCSVVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762064AbYCSUAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762055AbYCSUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:22 -0400
Date: Tue, 18 Mar 2008 14:32:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, Michael Tokarev <mjt@tls.msk.ru>,
       Andreas Schwab <schwab@suse.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
Message-ID: <20080318143222.GF10722@ZenIV.linux.org.uk>
References: <47DEFE26.80101@msgid.tls.msk.ru> <jeabkwaou7.fsf@sykes.suse.de> <47DF6E13.5050709@msgid.tls.msk.ru> <20080318125445.GS8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318125445.GS8368@mit.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 08:54:45AM -0400, Theodore Tso wrote:

> The main issue is that at the moment, when you open /proc/self/fd/X,
> what you get is a new struct file, since the inode is opened a second
> time.  That is why you have to go through the access control checks a
> second time, and why there are issues when you have /dev/stdin
> pointing to a tty which was owned by user 1, and then when you su to
> user 2, you get a "permission denied" error.
> 
> On other operating systems, opening /proc/self/fd/X gives you a
> duplicate of the file descriptor.  That means that the seek pointer is
> also duplicated.  This has been remarked upon before.  Linux 1.2 did
> things "right" (as in, the same as Plan 9 and Solaris), but it was
> changed in Linux 2.0.  Please see:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/9609.2/0371.html

The real issue is that it was not Plan 9 semantics to start with.

See 9/port/devproc.c and 9/port/devdup.c; the former is procfs and
while it does have <pid>/fd, the sucker is not a directory - it's
a text file containing (more or less) the pathnames of opened files
of that process.  The latter is an entirely different thing - it's
a separate filesystem (#d instead of #p, FWIW).  There you have
per-descriptor files to open and yes, that'll give you dup().  What
you do not have there is per-process part.

IOW, you can get pathnames of opened files for other processes via
procfs *AND* you can get open-that-does-only-dup for files in your
descriptor table - on a separate filesystem.

1.2 tried to mix both.  I'm not actually sure that it was a good idea wrt
security, while we are at it...

We could implement Plan 9 style dupfs, but to do that without excessive
ugliness we'd need to change prototype of ->open() - it must be able to
return a reference to struct file different from anything it got from
caller; probably the least painful way would be to make it return
	NULL => success, use struct file passed to ->open()
	ERR_PTR(-err) => error
	pointer to struct file => success, caller should drop the
reference to struct file it had passed to ->open() and use the return value.
Still a mind-boggling amount of churn - probably too much to bother with.

PS: from Plan 9 proc(3) [they use section 3 for kernel filesystems]:
      The read-only fd file lists the open file descriptors of the process.
      The first line of the file is its current directory; subsequent lines
      list, one per line, the open files, giving the decimal file descriptor
      number; whether the file is open for read (r), write, (w), or both (rw);
      the type, device number, and qid of the file; its I/O unit (the amount
      of data that may be transferred on the file as a contiguous piece; see
      iounit(2)), its I/O offset; and its name at the time it was opened.

