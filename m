Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbYEHVuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbYEHVuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYEHVt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:49:58 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40106 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbYEHVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:49:55 -0400
Date: Thu, 8 May 2008 22:48:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after suspend/resume
In-Reply-To: <E1JuCBA-0002NZ-4E@closure.thunk.org>
Message-ID: <Pine.LNX.4.64.0805082148060.3994@blonde.site>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Theodore Ts'o wrote:
> 
> I'm running a kernel based off of commit afa26be8 (just six commits
> after 2.6.26-rc1), and very shortly after I suspend/resume my X61s (with
> the Intel video chipset), the X server will lock up.  I can ssh into
> the machine remotely, and restart the X server, but the newly restarted
> X server will shortly lock up again, and the only way to solve the
> problem is to reboot.  If I drop back to a 2.6.25 based kernel, the
> problem goes away.
> 
> I've tried bisecting it, but the bisection points picked by git don't
> boot at all, and given that I'm travelling I havent had much time to try
> doing more bisecting; since I know a number of kernel developers have
> Lenovo X61 laptops, I thought before I wasted more time trying to get
> the git bisection to work, I'd check to see if anyone has seen this
> problem and if the fix is known.  I'll also try the latest bleeding edge
> kernel and hope it's fixed there....

I don't have a Lenovo X61, and I've no problem on my uniprocessor T43p.
But I also have a Fujitsu Siemens Esprimo Mobile, Core2 Duo and Intel
graphics like yours, and that's been behaving strangely after resume
from RAM since somewhere between 2.6.25 and 2.6.26-rc1.

Sounds like it might be the same problem, though I quickly moved away
trying it with X, and have been trying to investigate just from the
console for some days now.  Weird memory corruption after resume.

Like you, little success with bisection: probably-other bugs get in
the way.  Some bisection points don't boot, some don't come back from
resume at all, some hang before getting to test.  When, as a working
hypothesis, I assumed that not coming back from resume might be the
same problem manifesting in the return from resume itself, and shifted
around bisection points a bit to avoid non-booting, then it arrived at

commit 4fe29a85642544503cf81e9cf251ef0f4e65b162
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Wed Mar 19 14:25:23 2008 -0300
    x86: use specialized routine for setup per-cpu area

as the suspect commit.  But I couldn't see anything obviously wrong
with that; and it could well be no more guilty than shifting around
the kernel address space somewhat.  I've rather given up on the
bisection angle; and indeed, since found that how the problem
manifests varies somewhat from one day's git to another,
from one config to another.

It does not happen with maxcpus=1.  Yesterday it occurred to me
to try without CONFIG_PREEMPT=y; but reached no conclusion on that,
it turns out preemption has been somehow essential to resume from
RAM on this machine since before 2.6.25: clearly a separate issue.
And resume from RAM running 64-bit on it is also long problematic.

To reproduce the problem, I start off by building a kernel with
make -j3 (from habit, perhaps with priming the pagecache in mind),
then interrupt that around the time it gets to filemap.o, bootmem.o.
I pm-suspend, close the lid, wait a few seconds, open the lid;
make mrproper and start a make -j3 build again.  (Though the very
first time I noticed the problem, it was a segfault in a git pull
after resume.)

How quickly it goes bad varies a lot: often hangs right at the
start while sedding stuff before getting down to the build itself.
Often gets well into the build before gcc reports Real-time signal
(most commonly 14 but others seen) killed cc1.  But my favourite,
the most distinctive failure, is segfault (usually in sh or make)
at 20295564 ip .....2f2 error 6 in ld-2.6.1.so (openSUSE 10.3).

Always 20295564; and objdumping ld-2.6.1.so shows 0x14 of that is
just the offset from %edi, so the crucial address is 0x20295550.
Which is "PU) ", though I've not found that string anywhere in
the running vmlinux (but of course it does appear in kernel source).

Yesterday morning's git looked promising: because of the libata
70sec delay, I got diverted after the resume from RAM, left that
laptop idle, and found hald-something-or-other had come in every
few minutes and got that segfault at 20295564 (but with increasing
ip addresses: some address-space randomization effect, I suppose).
Well, I suppose it probably got run more often, but I'd only notice
the segfaulting ones.  So it can happen when close to idle; but
I've not been able to reproduce that since.

It's such a good signature, but I've failed to make progress with it.
Ted, please try doing the same (and check your logs for existing
segfault messages): let's see if you get the same number ;)
though I've no idea what it'd tell us.

Hugh
