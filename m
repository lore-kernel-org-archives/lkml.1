Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXFCSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXFCSxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXFCSxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:53:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4518 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbXFCSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:53:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 11:53:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <4663067C.9050002@redhat.com>
Message-ID: <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <4663067C.9050002@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> > #define FD_UNSEQ_BASE	(1U << 28)
> 
> I agree with Ingo, no need for a second magic value.  Use the same value
>  as FD_UNSEQ_ALLOC which will just mean this exact value should never be
> used as a file descriptor.

I explained this in my answer to Ingo...



> If it's not too expensive, I would prefer to see fdmap_newfd to return
> more or less random descriptor values.  This way nobody can try to rely
> on a specific sequence.  Plus it might add a tiny bit of extra security.

Random can be expensive. At the moment is FIFO. I'm missing though how 
this can be a security flaw, when the legacy one is exactly predictable.




> While dup2() and fcntl() might seem like good candidates to introduce
> the new functionality I think we should jump the gun and do it right.
> There are both not the best fit, as can be seen by your description.
> The parameter is now a hint.  Additionally everybody who'd use
> dup2/fcntl would have to issue a close syscall right after it.  Finally,
> I'm worried about accidental use of the new functionality.  Not too
> likely but it can happen.  This will cause hard to debug problems.
> 
> I think it's better to have a dedicated interface:
> 
>    int nonseqfd (int fd, int flags);
> 
> The semantics would include returning the new descriptor, closing the
> old descriptor (maybe this can be overwritten with a flags bit).  I
> guess I would also like to see the default of close_on_exit changed but
> perhaps the caller can be required to set an appropriate bit in the
> flags parameter.
> 
> This approach is cleaner, no magic constants exported from the kernel
> and it should be more efficient in general.  It probably will also spark
> reevaluating the choice of the interface for fdmap_newfd.  I don't like
> overloading a parameter to be used as a flag and a value at the same time.

I can do a new syscall, no problem (I actually even slightly prefer). We 
cannot break dup2() and F_DUPFD though, so we have to handle those too.
I was just trying to use Linus suggestion of using sus_dup2().



> The flags parameter will also allow to specify the additional
> functionality needed.  For instance, by default descriptors allocated
> this way *should* appear in /proc/self/fd.  You mentioned web servers
> which don't care about sequential allocation and are slowed down by the
> current strict allocation.  Those should have the descriptor appear in
> /proc/self/fd.  On the  other hand, uses of the interfaces in,  say,
> glibc or valgrind should create invisible descriptor.  Well, descriptors
> visible in perhaps /proc/self/fd-private or so.

Ohh, my last work yesterday was changing procfs/base.c to have them show 
up in there. We have quite a few flags available (31 or 63) to be 
assicated with each fd, so I guess we could use one for that.



> BTW: those whose perfect knowledge of the English language, I guess
> non-sequential is better than unsequential, right?  This would require
> renaming.

Yeah :D



> >  repeat:
> > +	if (files->fd_count >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
> > +		return -EMFILE;
> 
> I haven't studied the entire patch completely.  So, help me understand
> this.  ->fd_count is the exact count for the number of descriptors which
> is open.  This would make sense.

Yes, that's the count of open fds.



> But I hope everybody realizes that this is a change in the ABI.  So far
> RLIMIT_NOFILE specified the highest file descriptor number which could
> be returned by an open call etc.
> 
> There is a fine difference.  Even if yo have just a couple of
> descriptors open, you could not, for instance, dup2 to a descriptor
> higher than RLIMIT_NOFILE.  With this patch it seems possible, even for
> processes not using non-sequential descriptors.  This means programs
> written on new kernels might not run on older kernels.
> 
> I don't say that this is unacceptable.  It is a change.  If it can be
> minimized this would be better but the new RLIMIT_NOFILE semantics is
> certainly also correct according to POSIX.

If you look a few lines below, there's also (this is inside the lagacy 
fd allocator BTW):

	if (fd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
		goto out;

So the POSIX behaviour does not change. You cannot dup2() to an fd higher 
than RLIMIT_NOFILE (when using legacy fd allocation), *and* you cannot 
open more than RLIMIT_NOFILE files.
This means that if you have RLIMIT_NOFILE==1000 and you have 999 files 
open in the nonsequential area, you can only open one file in the legacy 
area.



- Davide

