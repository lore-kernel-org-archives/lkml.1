Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbXFCSVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbXFCSVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFCSVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:21:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXFCSVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:21:04 -0400
Message-ID: <4663067C.9050002@redhat.com>
Date: Sun, 03 Jun 2007 11:20:44 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
In-Reply-To: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> #define FD_UNSEQ_BASE	(1U << 28)

I agree with Ingo, no need for a second magic value.  Use the same value
 as FD_UNSEQ_ALLOC which will just mean this exact value should never be
used as a file descriptor.

If it's not too expensive, I would prefer to see fdmap_newfd to return
more or less random descriptor values.  This way nobody can try to rely
on a specific sequence.  Plus it might add a tiny bit of extra security.

While dup2() and fcntl() might seem like good candidates to introduce
the new functionality I think we should jump the gun and do it right.
There are both not the best fit, as can be seen by your description.
The parameter is now a hint.  Additionally everybody who'd use
dup2/fcntl would have to issue a close syscall right after it.  Finally,
I'm worried about accidental use of the new functionality.  Not too
likely but it can happen.  This will cause hard to debug problems.

I think it's better to have a dedicated interface:

   int nonseqfd (int fd, int flags);

The semantics would include returning the new descriptor, closing the
old descriptor (maybe this can be overwritten with a flags bit).  I
guess I would also like to see the default of close_on_exit changed but
perhaps the caller can be required to set an appropriate bit in the
flags parameter.

This approach is cleaner, no magic constants exported from the kernel
and it should be more efficient in general.  It probably will also spark
reevaluating the choice of the interface for fdmap_newfd.  I don't like
overloading a parameter to be used as a flag and a value at the same time.

The flags parameter will also allow to specify the additional
functionality needed.  For instance, by default descriptors allocated
this way *should* appear in /proc/self/fd.  You mentioned web servers
which don't care about sequential allocation and are slowed down by the
current strict allocation.  Those should have the descriptor appear in
/proc/self/fd.  On the  other hand, uses of the interfaces in,  say,
glibc or valgrind should create invisible descriptor.  Well, descriptors
visible in perhaps /proc/self/fd-private or so.


> It'd be possible to add a new O_UNSEQFD flag to open(2) and make sys_open()
> to allocate the new descriptor inside the unsequential map.

Again, I agree with Ingo.  This should be done.  If my CLOEXEC patches
are acceptable the same kind of change for Unix domain sockets can be
applied for non-sequential descriptors.

BTW: those whose perfect knowledge of the English language, I guess
non-sequential is better than unsequential, right?  This would require
renaming.


>  repeat:
> +	if (files->fd_count >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
> +		return -EMFILE;

I haven't studied the entire patch completely.  So, help me understand
this.  ->fd_count is the exact count for the number of descriptors which
is open.  This would make sense.

But I hope everybody realizes that this is a change in the ABI.  So far
RLIMIT_NOFILE specified the highest file descriptor number which could
be returned by an open call etc.

There is a fine difference.  Even if yo have just a couple of
descriptors open, you could not, for instance, dup2 to a descriptor
higher than RLIMIT_NOFILE.  With this patch it seems possible, even for
processes not using non-sequential descriptors.  This means programs
written on new kernels might not run on older kernels.

I don't say that this is unacceptable.  It is a change.  If it can be
minimized this would be better but the new RLIMIT_NOFILE semantics is
certainly also correct according to POSIX.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGYwZ82ijCOnn/RHQRAsvGAJ4jXamjOJVq4ImmVYT3/ghBXTB1bgCdGF0O
Y4nv9i7L98UEDEKc09Wt0VU=
=OS4+
-----END PGP SIGNATURE-----
