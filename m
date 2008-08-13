Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYHMApg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYHMApg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYHMAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:45:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYHMAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:45:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Yf7+qzdQ0zPPJHooTvkJHSf6rxUxDoLccFzmnemMADxdmOQeNBR0j9AWthkYDG1jN
	hBGr0f06VlIb37uk9GZeg==
Message-ID: <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com>
Date: Tue, 12 Aug 2008 17:45:20 -0700
From: Pardo <pardo@google.com>
To: akpm@linux-foundation.org, mingo@elte.hu, hugh@veritas.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: pthread_create() slow for many threads; also time to revisit 64b context switch optimization?
Cc: briangrant@google.com, cgd@google.com, mbligh@google.com
In-Reply-To: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[First send rejected by vger.kernel.org due to HTML and/or test
program attachment.  Re-send without, please contact me for the test
program.]

mmap() is slow on MAP_32BIT allocation failure, sometimes causing
NPTL's pthread_create() to run about three orders of magnitude slower.
 As example, in one case creating new threads goes from about 35,000
cycles up to about 25,000,000 cycles -- which is under 100 threads per
second.  Larger stacks reduce the severity of slowdown but also make
slowdown happen after allocating a few thousand threads.  Costs vary
with platform, stack size, etc., but thread allocation rates drop
suddenly on all of a half-dozen platforms I tried.

The cause is NPTL allocates stacks with code of the form (e.g., glibc
2.7 nptl/allocatestack.c):

sto = mmap(0, ..., MAP_PRIVATE|MAP_32BIT, ...);
if (sto == MAP_FAILED)
  sto = mmap(0, ..., MAP_PRIVATE, ...);

That is, try to allocate in the low 4GB, and when low addresses are
exhausted, allocate from any location.  Thus, once low addresses run
out, every stack allocation does a failing mmap() followed by a
successful mmap().  The failing mmap() is slow because it does a
linear search of all low-space vma's.

Low-address stacks are preferred because some machines context switch
much faster when the stack address has only 32 significant bits.  Slow
allocation was discussed in 2003 but without resolution.  See, e.g.,
http://ussg.iu.edu/hypermail/linux/kernel/0305.1/0321.html,
http://ussg.iu.edu/hypermail/linux/kernel/0305.1/0517.html,
http://ussg.iu.edu/hypermail/linux/kernel/0305.1/0538.html, and
http://ussg.iu.edu/hypermail/linux/kernel/0305.1/0520.html. With
increasing use of threads, slow allocation is becoming a problem.

Some old machines were faster switching 32b stacks, but new machines
seem to switch as fast or faster using 64b stacks.  I measured
thread-to-thread context switches on two AMD processors and five Intel
procesors.  Tests used the same code with 32b or 64b stack pointers;
tests covered varying numbers of threads switched and varying methods
of allocating stacks.  Two systems gave indistinguishable performance
with 32b or 64b stacks, four gave 5%-10% better performance using 64b
stacks, and of the systems I tested, only the P4 microarchitecture
x86-64 system gave better performance for 32b stacks, in that case
vastly better.  Most systems had thread-to-thread switch costs around
800-1200 cycles.  The P4 microarchitecture system had 32b context
switch costs around 3,000 cycles and 64b context switches around 4,800
cycles.

It appears the kernel's 64-bit switch path handles all 32-bit cases.
So on machines with a fast 64-bit path, context switch speed would
presumably be improved yet further by eliminating the special 32-bit
path.  It appears this would also collapse the task state's fs and
fsindex fields, and the gs and gsindex fields.  These could further
reduce memory, cache, and branch predictor pressure.

Various things would address the slow pthread_create().  Choices include:
 - Be more platform-aware about when to use MAP_32BIT.
 - Abandon use of MAP_32BIT entirely, with worse performance on some machines.
 - Change the mmap() algorithm to be faster on allocation failure
(avoid a linear search of vmas).

Options to improve context switch times include:

 - Do nothing.
 - Be more platform-aware about when to use different 32b and 64b paths.
 - Get rid of the 32b path, which also appears it would make contexts smaller.

[Not] Attached is a program to measure context switch costs.
