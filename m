Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYI3Ie7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYI3Ie7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYI3Iew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:34:52 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:44915 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYI3Iev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:34:51 -0400
Date: Tue, 30 Sep 2008 04:34:48 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: linux-kernel@vger.kernel.org, Dylan Taft <d13f00l@gmail.com>
Subject: Re: questions about x86: mtrr cleanup for converting continuous to
 discrete layout
In-Reply-To: <47ed01bd0809291546q4d0dc85fif46667b75bfb7526@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0809300144090.4688@redclaw.mimosa.com>
References: <47ed01bd0809291546q4d0dc85fif46667b75bfb7526@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| From: Dylan Taft <d13f00l@gmail.com>

Thanks for your reply.

| To: linux-kernel@vger.kernel.org, yinghai@kernel.org, hugh@mimosa.com
| Subject: Re: questions about x86: mtrr cleanup for converting continuous to
|     discrete layout
| 
| I think a workaround in the kernel is absolutely necessary.  A lot of
| newer motherboards have this issue,

I agree.

| where a whole section of memory
| will be marked as write-back, and write-combining can't be
| embedded/nested.

To be more clear:

Uncachable can be nested within write-back but write-combining cannot
be nested within write-back.  These newer BIOSes, when they see 4GiB
or more of RAM, nest an uncachable MTRR for a video buffer inside a
larger write-back region.

The video driver cannot simply change the type of the inner MTRR
because write-combining cannot be nested within write-back.

| As far as I'm aware, changing MTRRs won't make a system unstable,
| especially if done so early on, when the kernel is starting up.  All
| it does is change the behavior on how the CPU will cache write
| requests to memory.

Two kinds of stability issues:

- if the MTRRs are being changed while other things are going on, it
  may be the case that memory accesses are performed with an improper
  configuration.

  This is quite possible if the changes are from a userland program,
  like mine.  It might happen in a kernel-based version if
  insufficient locking is performed.

- wise people have said that SMM code may make assumptions about MTRR
  settings.  Here are a couple of random messages that touch on this:

	http://lkml.org/lkml/2008/4/28/201
	http://lkml.org/lkml/2008/4/29/522

|  All system memory should be marked as write-back,
| how many MTRRs are used to do this...I'm not sure if it exactly
| matters.  You can set MTRR_SPARE_REG_NR and control how many MTRR
| slots the code will use.

There are only 8 MTRRs on current hardware, as far as I know.  You
cannot use more.  If you use 8 or fewer, the number probably doesn't
matter.

Clearly Yinghai Lu thinks the number of unused registers matters or he
would not have implemented MTRR_SPARE_REG_NR.  I don't know why.

| Is it legal to mark a write-combining range within a write-back range?

No.

| Ideally, maybe adding a minimal amount of MTRRs might be best, as D.
| Hugh Redelmeier's userspace app does,

My program aims to minimize MTRRs used in the hope that no
approximation need be used.

| I'm no kernel dev, I code a bit here and there, but I spent a LOT of
| time researching this when I ran into the problem myself on my new PC.

Hear hear!  This is a dark and ill documented corner of the world
with nasty things lurking there bite you.  Both of us are here because
we got bit.

I'm a bit disappointed that my messages to LKML haven't provoked more
reaction.

|  There's a lot of posts about it too in the intel bug tracker for
| people with newer boards and the g45 chipset.

Could you point me towards them?  I'd like to see if mtrr-uncover
works for their problems.

|  Most users shouldn't
| have to worry about this, and it should, "just work".

Yes.

| I don't think this should be pulled unless a different fix is in place
| in the kernel.

I agree.  But if it introduces new mysterious problems, then things
are not necessarily better.

That is why it defaults to being off.  At least I think it does.

I think/suspect/hope that my algorithm is safer.  I'm not advocating
userland code -- that's just a prototype.

| Here's what bios does with my MTRRs, write combining can't be set up
| for my video card
| reg00: base=0x1b0000000 (6912MB), size= 256MB: uncachable, count=1
| reg01: base=0x1c0000000 (7168MB), size=1024MB: uncachable, count=1
| reg02: base=0x00000000 (   0MB), size=8192MB: write-back, count=1
| reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
| reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
| reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
| reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1

Hmm. that's not what I saw in
http://bugs.freedesktop.org/show_bug.cgi?id=17782

A more readable presentation of the same information:
 2  0x000000000-0x1ffffffff write-back
         5  0x0c7e00000-0x0c7ffffff uncachable
         6  0x0c8000000-0x0cfffffff uncachable
         3  0x0d0000000-0x0dfffffff uncachable
         4  0x0e0000000-0x0ffffffff uncachable
         0  0x1b0000000-0x1bfffffff uncachable
         1  0x1c0000000-0x1ffffffff uncachable

Today's version of mtrr-uncover comes up with the following precise
solution:

 2' 0x000000000-0x07fffffff write-back
51' 0x080000000-0x0bfffffff write-back
52' 0x0c0000000-0x0c7ffffff write-back
         5  0x0c7e00000-0x0c7ffffff uncachable
 3T 0x0d0000000-0x0dfffffff uncachable
50  0x100000000-0x1ffffffff write-back
         0  0x1b0000000-0x1bfffffff uncachable
         1  0x1c0000000-0x1ffffffff uncachable

I made some changes to mtrr-uncover today

- it now makes sure that there is a distinct uncovered MTRR
  corresponding to each range the user specified.  This makes changing
  the region to WC easier.

  Before it often optimized away the target MTRR.  This generally was
  not a problem, but it could be if there were no free MTRR registers.

- I added another optimization.  Prompted by this example
  configuration (thanks!).  Without this optimization, the
  program could not fit a solution to this example in 8 MTRRs.

ftp://ftp.cs.utoronto.ca/pub/hugh/mtrr-uncover-2008sept30.tgz

| and with Yinghai Lu's patches in git tip, with working write-combining mark
| reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
| reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
| reg02: base=0xc0000000 (3072MB), size= 128MB: write-back, count=1
| reg03: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
| reg04: base=0x100000000 (4096MB), size=2048MB: write-back, count=1
| reg05: base=0x180000000 (6144MB), size= 512MB: write-back, count=1
| reg06: base=0x1a0000000 (6656MB), size= 256MB: write-back, count=1
| reg07: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

Interesting.  In this case, reg03 is nested within reg02.  I didn't
realize that Yinghai Lu's code allowed nesting.

This is an approximation:
0x1b0000000-0x1ffffffff is now UC but was WB

I would claim that mtrr-uncover's solution is therefore superior.
