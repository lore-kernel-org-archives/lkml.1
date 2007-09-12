Return-Path: <linux-kernel-owner+w=401wt.eu-S1765067AbXILUhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765067AbXILUhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbXILUhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:37:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60472 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757866AbXILUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:37:45 -0400
Date: Wed, 12 Sep 2007 15:37:44 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: O_NOLINK for open()
Message-ID: <20070912144128.D5573@pkunk.americas.sgi.com>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bear with me, I present the problem I'm trying to solve first,
and then propose O_NOLINK as a solution.  Responses to either my
shared memory problem or the O_NOLINK idea would be most appreciated.

I've run into a rather unusual set of circumstances calling for
use of shared memory, but haven't found a bulletproof solution
which can be used under Linux.

I have a need to share memory between two unrelated processes,
but without the ability for any other process to attach to it,
for security reasons (e.g. encryption keys and plaintext will
be exchanged via this shared memory area).  These unrelated
processes will in all likelihood not be owned by the same user
(i.e. one of them is a daemon).

System V shmem is right out because the IPC key is publicly
visible and there is no combination of permissions which
will allow sharing the segment with just one other process
(or at least just one other user).  To my knowledge Linux's
implementation doesn't provide ACLs for SysV shmem.  SGI's
proposed XPMEM suffers from the same problems for my purposes.

I had a mistaken notion that multiple mmap's of /dev/zero using
a common file descriptor (which could be passed between the
processes via an AF_UNIX socket) would result in shared memory,
but apparently my understanding of /dev/zero mmap's was subtlely
wrong, so it appears this won't work.

I could mmap a temporary tmpfs file (tmpfs so that if there is a
machine crash no sensitive data persists) which is created with
permissions of 0, immediately unlink it, and pass the file
descriptor through an AF_UNIX socket.  This does open up a very
small window of vulnerability if another process is able to chmod
the file and open it before the unlink.

However, it occurs to me that this problem goes away if there were
a method create a file in an unlinked state to begin with.  However
there does not appear to be any such mechanism in Linux's open()
interface.  A bit of Googling indicates that Hurd has an O_NOLINK
flag which seems to accomplish what I'd need, but Linux doesn't
implement such a flag.  There was some discussion of this in various
lkml threads in the past, but none that went anywhere.  Perhaps
the best an explaining why other mechanisms (i.e. directories
with particular permissions aren't a solution) is:

	http://marc.info/?l=linux-kernel&m=93032806224160&w=2

Of course it is reasonable to take the stance that if root or the
daemon's user are malicious, all bets are off anyway.

Fully understanding this, it was suggested to me that I could fire
this problem off to lkml to see if anyone has a solution I haven't
already dismissed, or as a trial balloon for considering adding
O_NOLINK to open().

Thoughts?

Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
