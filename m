Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZGXRWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZGXRWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZGXRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:22:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:56275 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZGXRWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:22:36 -0400
Date: Fri, 24 Jul 2009 13:22:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Status of ext4 online defrag?
Message-ID: <20090724172227.GH5675@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Clemens Eisserer <linuxhippy@gmail.com>,
	linux-kernel@vger.kernel.org
References: <194f62550907240636o5ba623cdy1f16deb7f6d70eeb@mail.gmail.com> <200907241700.24170.diegocg@gmail.com> <194f62550907240829m1834bc26r8e23baba4b295ae4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <194f62550907240829m1834bc26r8e23baba4b295ae4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 11:29:40AM -0400, Clemens Eisserer wrote:
> >> Does anybody know what the current state of ext4 online defrag is?
> >
> > It got merged for 2.6.31 (commit 748de6736c1e482e111f9d1b5a5d5b1787600cad)
> 
> Thanks, how cool!
> I feared already that this feature is dead, glad to hear it is not :)

It's not dead, but it's not fully complete.  There are more patches
that introduce a half-dozen or so new ioctl's that still need review,
and the e4defrag tool is still quite primitive and needs to (a) use
the new ioctls, and (b) be made more intelligent about defragging free
space.

At the moment what e4defrag will do is to ask the filesystem to
allocate new space, and if the new space contains fewer fragments that
the current file, use an ioctl to atomically copy the data to the new
blocks and swap the blocks so that the file being defragged uses the
newly allocated blocks.  If the filesystem's free space is not badly
fragmented, this will tend to defrag individual files, but e4defrag
doesn't currently have any kind of global knowledge of where files
live and any global knowledge of the free space and how to move blocks
around so that the free space will get defragmented.

The new ioctls are designed to give the userspace program the tools to
do this, but (a) we haven't had the time to review the ioctls and new
code so they haven't been merged yet, and (b) the userspace program
hasn't been taught to use these new ioctls.

> When compiling e2fsprogs from git, I get:
> > e4defrag.c:388: error: conflicting types for ‘fallocate’
> > /usr/include/bits/fcntl.h:240: note: previous declaration of ‘fallocate’ was here
> > make: *** [e4defrag.o] Error 1
> 
> I had to comment out fallocate in fcntl.h, no idea who is wrong here.

Eric Sandeen has patches that he sent out in the last two weeks to fix
e4defrag so it will compile on glibc's that define fallocate.  I just
haven't had a chance to get them applied into mainline.  Things like
fixing bugs where off-line resize2fs could corrupt ext4 filesystems
were higher priority.  :-(

The bottom line is that online defrag is something that is happening,
it's just not happening as fast as we would all like, mainly due to
resource issues.

Regards,

					- Ted
