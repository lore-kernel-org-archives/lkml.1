Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXKXE5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXKXE5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXKXE5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:57:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:13072 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXKXE5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:57:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K0D1uOmLnmfFMXY6B0s4Ae7gk8paihiGRef2CYKX1JQffQ78ClMSnFTyb8kGMP8IP5f2eXz5cecADYOSQbx6fHUX06Tmb4YR+NJks++bxbEcHChiTTgfw/+qlRabp8ajdfWgs5f94AjQEZQZbWUBnQoCEAy1m4vo091J6cxVTAI=
Message-ID: <64bb37e0711232057v611a7114i9d8ba3ef6a0d6fc2@mail.gmail.com>
Date: Sat, 24 Nov 2007 05:57:21 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Alasdair G Kergon" <agk@redhat.com>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Milan Broz" <mbroz@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
In-Reply-To: <20071124034907.GD22843@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
	 <20071119075627.GB28432@elte.hu>
	 <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
	 <4741F97D.6090808@redhat.com>
	 <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
	 <20071124034907.GD22843@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007 4:49 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, Nov 23, 2007 at 11:42:36PM +0100, Torsten Kaiser wrote:
> > ... or I just don't see the bug.
>
> See my earlier post in this thread: there's a race in the write loop
> where a work struct could be used twice on the same queue.
> (Needs data structure change to fix that, which nobody has attempted
> to do yet.)

As I wrote in an earlier post:
I did see this lockdep message even with
agk-dm-dm-crypt-move-bio-submission-to-thread.patch reverted, so the
work struct is not used in the write loop.

> BTW To eliminate any internal lockdep concerns (and people say there
> should be no problem) temporarily add a second struct instead of reusing
> one on two queues.

I think, this might really be a lockdep bug, but as I'm not fluent
enough with C, please check, if my logik is correct:

The freed-locked-lock-test is the only function that uses this in lockdep.c:
static inline int in_range(const void *start, const void *addr, const void *end)
{
        return addr >= start && addr <= end;
}
This  will return true, if addr is in the range of start (including)
to end (including).

But debug_check_no_locks_freed() seems does:
const void *mem_to = mem_from + mem_len
-> mem_to is the last byte of the freed range, that fits in_range
lock_from = (void *)hlock->instance;
-> first byte of the lock
lock_to = (void *)(hlock->instance + 1);
-> first byte of the next lock, not last byte of the lock that is being checked!
(Or am I reading this wrong?)

The test is:
if (!in_range(mem_from, lock_from, mem_to) &&
                                        !in_range(mem_from, lock_to, mem_to))
                        continue;
So it tests, if the first byte of the lock is in the range that is freed ->OK
And if the first byte of the *next* lock is in the range that is freed
-> Not OK.

That would also explain the rather strange output:
=========================
[ BUG: held lock freed! ]
-------------------------
kcryptd/1022 is freeing memory
FFFF81011EBEFB00-FFFF81011EBEFB3F, with a lock still held there!
  (kcryptd){--..}, at: [<ffffffff80247dd9>] run_workqueue+0x129/0x210
2 locks held by kcryptd/1022:
 #0:  (kcryptd){--..}, at: [<ffffffff80247dd9>] run_workqueue+0x129/0x210
 #1:  (&io->work#2){--..}, at: [<ffffffff80247dd9>] run_workqueue+0x129/0x210

That claims that the lock of the *workqueue* struct, not the work
struct is getting freed!
But I'm still happily using the dm-crypt device, even 19 hours after
that message.

So my current best guess to the source of this message is, that with
the change in the ref counting it is now possible that the work struct
is really getting freed before the workqueue function returns. But as
the comment in run_workqueue() says, that is still legal.
But now the first byte of the next lock is part of the freed memory
and so the wrong "held lock freed" is triggered.

Torsten
