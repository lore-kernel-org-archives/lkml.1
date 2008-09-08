Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYIHQ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYIHQ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYIHQ6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:58:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34225 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYIHQ6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:58:23 -0400
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <48C35DFC.9080903@cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
	 <1220553660.23386.60.camel@nimitz>  <48C35DFC.9080903@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 09:57:42 -0700
Message-Id: <1220893062.23386.176.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-07 at 00:52 -0400, Oren Laadan wrote:
> >> +	for (i = 0; i < fdt->max_fds; i++) {
> >> +		if (!fcheck_files(files, i)
> >> 			continue;
> >> 		if (n == max) {
> >> +			spin_unlock(&files->file_lock);
> >> +			kfree(fdlist);
> >> +			max *= 2;
> >> +			if (max < 0) {	/* overflow ? */
> >> +				n = -EMFILE;
> >> +				break;
> >> +			}
> >> +			goto repeat;
> >> +		}
> >> +		fdlist[n++] = i;
> >> +	}
> > 
> > My gut also says that there has to be a better way to find a good size
> > for fdlist() than growing it this way.  
> 
> Can you suggest a better way to find the open files of a task ?
> 
> Either I loop twice (loop to count, then allocate, then loop to fill),
> or optimistically try an initial guess and expand on demand.

I'd suggest the double loop.  I think it is much more straightforward
code.

> >> +	hh->f_version = file->f_version;
> >> +	/* FIX: need also file->f_owner */
> >> +
> >> +	switch (inode->i_mode & S_IFMT) {
> >> +	case S_IFREG:
> >> +		fd_type = CR_FD_FILE;
> >> +		break;
> >> +	case S_IFDIR:
> >> +		fd_type = CR_FD_DIR;
> >> +		break;
> >> +	case S_IFLNK:
> >> +		fd_type = CR_FD_LINK;
> >> +		break;
> >> +	default:
> >> +		return -EBADF;
> >> +	}
> > 
> > Why don't we just store (and use) (inode->i_mode & S_IFMT) in fd_type
> > instead of making our own types?
> 
> There will be others that cannot be inferred from inode->i_mode,
> e.g. CR_FD_FILE_UNLINKED, CR_FD_DIR_UNLINKED, CR_FD_SOCK_UNIX,
> CR_FD_SOCK_INET_V4, CR_FD_EVENTPOLL etc.

I think we have a basically different philosophy on these.  I'd say
don't define them unless absolutely necessary.  The less you spell out
explicitly, the more flexibility you have in the future, and the less
code you spend doing simple conversions.

Anyway, I see why you're doing it this way.

-- Dave

