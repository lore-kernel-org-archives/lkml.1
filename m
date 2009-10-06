Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZJFJB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZJFJB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZJFJB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:01:27 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:44624 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZJFJB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B5DQAbYL8HgnvT3hP3SFEs5zhBZ+mUBRjI6LfSeJ3FkHzTBvKq8zBqBAcFaLsqQkta
         PQCf5nZcFeRP4qGFsuYoA6J6JjYYohOxyX7i0M2OcenXzOFxUxowJyX2xi3CuZrq0/aa
         nquuCVlNc0IzbU2H1smpV57BfyJ0GN6Rxhkr0=
MIME-Version: 1.0
In-Reply-To: <20091006084120.GJ5216@kernel.dk>
References: <20091002195815.GE4494@redhat.com>
	 <20091002222756.GG4494@redhat.com>
	 <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	 <20091003133810.GC12925@redhat.com>
	 <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	 <20091004121122.GB18778@redhat.com>
	 <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	 <x49my457uef.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
	 <20091006084120.GJ5216@kernel.dk>
Date: Tue, 6 Oct 2009 11:00:48 +0200
Message-ID: <4e5e476b0910060200i7c028b3fr4c235bf5f18c3aa1@mail.gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler 
	based IO controller V10)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 10:41 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 05 2009, Corrado Zoccolo wrote:
>> On Mon, Oct 5, 2009 at 5:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > It stands for residual, not residency.  Make more sense?
>> It makes sense when computed, but not when used in rb_key computation.
>> Why should we postpone queues that where preempted, instead of giving
>> them a boost?
>
> We should not, if it is/was working correctly, it should allow both for
> increase/descrease of tree position (hence it's a long and can go
> negative) to account for both over and under time.

I'm doing some tests with and without it.
How it is working now is:
definition:
        if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
                cfqq->slice_resid = cfqq->slice_end - jiffies;
                cfq_log_cfqq(cfqd, cfqq, "resid=%ld",
cfqq->slice_resid);
        }
* here resid is > 0 if there was residual time, and < 0 if the queue
overrun its slice.
use:
                rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
                rb_key += cfqq->slice_resid;
                cfqq->slice_resid = 0;
* here if residual is > 0, we postpone, i.e. penalize.  If residual is
< 0 (i.e. the queue overrun), we anticipate it, i.e. we boost it.

So this is likely not what we want.
I did some tests with and without it, or changing the sign, and it
doesn't matter at all for pure sync workloads.

The only case in which it matters a little, from my experiments, is
for sync vs async workload. Here, since async queues are preempted,
the current form of the code penalizes them, so they get larger
delays, and we get more bandwidth for sync.
This is, btw, the only positive outcome (I can think of) from the
current form of the code, and I think we could obtain it more easily
by unconditionally adding a delay for async queues:
                rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
		if (!cfq_cfqq_sync(cfqq)) {
                        rb_key += CFQ_ASYNC_DELAY;
	        }

removing completely the resid stuff (or at least leaving us with the
ability of using it with the proper sign).

Corrado
>
> --
> Jens Axboe
>
>
