Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbYI1GNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbYI1GNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 02:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYI1GM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 02:12:56 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:38211 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYI1GM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 02:12:56 -0400
X-Greylist: delayed 3762 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2008 02:12:55 EDT
Date: Sun, 28 Sep 2008 01:10:12 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: linux-kernel@vger.kernel.org
Subject: questions about x86: mtrr cleanup for converting continuous to
 discrete layout
Message-ID: <alpine.LRH.2.00.0809272343020.20325@redclaw.mimosa.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my current understanding of the MTRR problems.  Please correct
any mistakes.

There are two broad reasons (use cases) for Linux to change MTRRs

(1) to clean up after bad BIOSes.

(1a) Some BIOSes don't make all the MTRRs the same on all processors.
This is just wrong and the kernel fixes this.

(1b) Some BIOSes, for some memory configurations, fail to specify that
certain bits of RAM should be cached.  The current fix is to not use
that RAM, so the MTRRs are not actually changed, but they could be.

(2) to allow userland programs to adjust the caching regime for chunks
of memory.

The only use of this that I know of is by some (most) X device drivers
to change the video device buffer from Uncachable to Write-Combining.

(OK, I simplified: a very few other device drivers do the same thing,
eg. the ib_path Infiniband driver.)

Are there any other significant uses?


Currently, the kernel is not capable of using the MTRR mechanism to
change the caching behaviour of a range of memory that is a proper
subset of the range of an existing MTRR.  That is a carefully worded
statement -- I will unpack it:

- the desired effect might be achieved using PAT, but we are only
  dealing with MTRR here.

- by "proper subset" I mean smaller than and contained within

- generally, the BIOS sets up a distinct MTRR for a video buffer
  so this condition will manifest itself as nested MTRR ranges.
  But this isn't the only way it could arise.


There is a proposal to fix the problem: patch "x86: mtrr cleanup for converting continuous to discrete
layout, v8"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=95ffa2438d0e9c48779f0106b1c0eb36165e759c
and it apparently continues to be refined.

[I have a userland program to attack the same problem.  See
  ftp://ftp.cs.utoronto.ca/pub/hugh/mtrr-uncover-2008sept27.tgz
When I make changes, the date portion of the name changes -- it is a
work in progress.]

I have some doubts about the kernel patch.

(1) The name makes no sense to me.  The issue addressed is not whether
MTRRs are "continuous" or "discreet", it is whether they are any
nested MTRR ranges.  Another term for "nested" could be "overlapping"
but that isn't quite as precise.


(2) Ideally, the patch should reorganize MTRRs so that the ranges no
longer overlap but that the caching type ascribed to each address is
the same.

This often cannot be done: an exact solution often requires more MTRR
registers than the hardware provides.  So the patch will approximate
the solution, rounding region sizes to a multiple of mtrr_gran_size,
a user specified value.  Is there any reason to think that this
approximation does not compromise the integrity of the system?

The fact that the user specifies mtrr_gran_size is apparently taken as
some kind of consent.  Is there any likelihood of it being informed
consent?  MTRR issues are quite complicated and poorly documented.


(3) The real problem is not that MTRR ranges are nested, it is that a
userland program (an X video driver) may wish to change the caching
behaviour of a particular range of memory where that range is a proper
subset of an existing MTRR range.

This problem turns out to be solvable much more often than unnesting
every MTRR.  I base this on modest experience with my mtrr-uncover
program.  I've tested it with /proc/mtrr values contained within
various bug reports on the web.  My program has not implemented any
approximation and it has not been needed.  It has, however, often been
necessary to specify the range of interest.

Why is this likely to be so?  The reason a lot of MTRRs are required
stems from the fact that their sizes are limited to powers of two (and
their addresses must be aligned on a boundary that is a multiple of
the size).  A little range nested within a much large range must be
turned into a whole bunch of ranges (roughly: (log2 larger_size) -
(log2 smaller_size) extra MTRR registers).  This happens a lot in real
examples.

But those examples turn out not to matter.  Video device buffers (of
the kind X drivers wish to retype) are quite large.  Typically 256MiB
or more on the kind of system with 4GiB or more of RAM.  So the
horrible explosion of MTRR requirements does not happen when
uncovering them.

(4) I have seen comments made that SMM code may presume that the MTRRs
are set up as the BIOS has left them.  After all, it seems as if the
BIOS "owns" the MTRRs.  Wholesale changing of MTRRs might be
dangerous.

I have not seen any evidence to support this contention.  But those
making the claims are known to be wise.

Could someone point to anything that would clarify this issue?

================

I suggest that it would be much cleaner and safer if the kernel only
reorganized MTRRs as needed.  So, for example, when an X driver
requests that a region be changed to a different type, then, and only
then, work at reorganizing to accomplish that narrow task.

My program mtrr-uncover could be a prototype.  It is userland code and
I think that the proper solution is kernel code, so I think new code
is needed.

In any case, I'm not really comfortable with the existing patch.  It
rarely works without approximation and I'm not sure that the
approximation is safe.

================

In my opinion, there are a bunch of things wrong the the MTRR API
presented to userland.  I outlined a number of deficiencies with the
ioctl part in http://lkml.org/lkml/2008/8/5/62
I know more now.

A summary is that the interface is poorly described and more
complicated than needed for the use cases that I know.

Should we cut it back?
