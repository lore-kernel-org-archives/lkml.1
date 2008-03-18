Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYCST3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYCST3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYCST0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:11 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38409 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbYCST0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:07 -0400
Date: Tue, 18 Mar 2008 11:04:39 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Andreas Schwab <schwab@suse.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
Message-ID: <20080318150439.GB27000@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, Michael Tokarev <mjt@tls.msk.ru>,
	Andreas Schwab <schwab@suse.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <47DEFE26.80101@msgid.tls.msk.ru> <jeabkwaou7.fsf@sykes.suse.de> <47DF6E13.5050709@msgid.tls.msk.ru> <20080318125445.GS8368@mit.edu> <20080318143222.GF10722@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318143222.GF10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 02:32:22PM +0000, Al Viro wrote:
> The real issue is that it was not Plan 9 semantics to start with.
> 
> See 9/port/devproc.c and 9/port/devdup.c; the former is procfs and
> while it does have <pid>/fd, the sucker is not a directory - it's
> a text file containing (more or less) the pathnames of opened files
> of that process.  The latter is an entirely different thing - it's
> a separate filesystem (#d instead of #p, FWIW).  There you have
> per-descriptor files to open and yes, that'll give you dup().  What
> you do not have there is per-process part.
> 
> IOW, you can get pathnames of opened files for other processes via
> procfs *AND* you can get open-that-does-only-dup for files in your
> descriptor table - on a separate filesystem.

Well, what we did was to make readlink() return the pathname, and
open() return a dup of the filesystem.  I thought that was pretty
clever at the time, actually.

Yes, it wasn't completely the plan 9 semantics, but in terms of what
happened with when you opened the filesystem, it was equivalent to
dupfs.

Maybe our mistake was to make /dev/fd a symlink to /proc/self/fd, and
/dev/stdin a symlink to /proc/self/fd/0, et. al, since we don't get
the semantics exactly right compard to other operating systems.

> 1.2 tried to mix both.  I'm not actually sure that it was a good idea wrt
> security, while we are at it...

What is the security problem that you are worried about?  That it
might leak the pathname to someone who had an open file handle to the
file?  That doesn't seem like a huge deal to me....

> We could implement Plan 9 style dupfs, but to do that without excessive
> ugliness we'd need to change prototype of ->open() - it must be able to
> return a reference to struct file different from anything it got from
> caller; probably the least painful way would be to make it return
> 	NULL => success, use struct file passed to ->open()
> 	ERR_PTR(-err) => error
> 	pointer to struct file => success, caller should drop the
> reference to struct file it had passed to ->open() and use the return value.
> Still a mind-boggling amount of churn - probably too much to bother with.

Yeah, ouch.  The only other way to do it would be to add a new
function pointer to the file_operations() field which would only be
used filled in by procfs inodes, and then have the sys_open() routine
call that function pointer if open() was zero.  But that would be
quite ugly....

					- Ted
