Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbXGHSUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbXGHSUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXGHSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:20:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45155 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXGHST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:19:59 -0400
Date: Sun, 8 Jul 2007 19:19:54 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer	dereference - git-bisect result
Message-ID: <20070708181954.GH21668@ftp.linux.org.uk>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk> <469121DA.6030600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469121DA.6030600@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 10:41:46AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Al Viro wrote:
> > Like hell.  At the very least you want it to be opened for write.
> > And even that is dubious, since "process has write access to file"
> > is not quite the same thing as "somebody had given the process a
> > descriptor opened for write".
> 
> But the real permissions tests are performed in notify_change.  I think
> all this is consistent with how, for instance, fchmod works.  The
> additional tests in fchmod which aren't here (IS_RDONLY and IS_APPEND)
> would also apply to the case where a file name is given.  So, either the
> code was inconsistent already are these tests are really not needed.

Yes, it's either that, or you haven't bothered to read what it really
does.  ATTR_UID et.al. are checked in inode_change_ok().  So is
ATTR_MTIME_SET (only owner can explicitly set timestamps).  ATTR_MTIME
is not and *should* *not* be checked there.  Exactly because it's
done as a side effect of many operations with access control of their
own and nothing that could be pushed down into notify_change() path.
Think of e.g. write(2) - by the time you get to notify_change(), you
don't even have a file descriptor.  Just the dentry and process writing
to file doesn't have to have *any* permissions on it.

Hell, _try_ it.  Build the kernel with your patch and without it.
Call utimes() with NULL second argument on a file you have no write
access to.  See if the timestamps change.
