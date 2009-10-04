Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZJDMrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZJDMrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZJDMrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:47:22 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:37021 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZJDMrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aUNhZ2gSpvh5misjJertQN6r93fZWpY2WtAWt3D67fqTW2jCQd8bNCYxpP92Q82uwN
         6PTmjTVqil158SeO72atRpkI5FR3CjPMrFc/hxMG34qiLVmShFbdXx/toA9bk49jmFzc
         OGXBbC1fcTGM3yhcyIfMSVDtMKtpqH9/TL2co=
MIME-Version: 1.0
In-Reply-To: <20091004121122.GB18778@redhat.com>
References: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	 <20091002154020.GC4494@redhat.com>
	 <12774.1254502217@turing-police.cc.vt.edu>
	 <20091002195815.GE4494@redhat.com>
	 <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	 <20091002222756.GG4494@redhat.com>
	 <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	 <20091003133810.GC12925@redhat.com>
	 <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	 <20091004121122.GB18778@redhat.com>
Date: Sun, 4 Oct 2009 14:46:44 +0200
Message-ID: <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler 
	based IO controller V10)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Sun, Oct 4, 2009 at 2:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Oct 04, 2009 at 11:15:24AM +0200, Corrado Zoccolo wrote:
>> Hi Vivek,
>> My guess is that the formula that is used to handle this case is not
>> very stable.
>
> In general I agree that formula to calculate the slice offset is very
> puzzling as busy_queues varies and that changes the position of the task
> sometimes.
>
> I am not sure what's the intent here by removing busy_queues stuff. I have
> got two questions though.

In the ideal case steady state, busy_queues will be a constant. Since
we are just comparing the values between themselves, we can just
remove this constant completely.

Whenever it is not constant, it seems to me that it can cause wrong
behaviour, i.e. when the number of processes with ready I/O reduces, a
later coming request can jump before older requests.
So it seems it does more harm than good, hence I suggest to remove it.

Moreover, I suggest removing also the slice_resid part, since its
semantics doesn't seem consistent.
When computed, it is not the residency, but the remaining time slice.
Then it is used to postpone, instead of anticipate, the position of
the queue in the RR, that seems counterintuitive (it would be
intuitive, though, if it was actually a residency, not a remaining
slice, i.e. you already got your full share, so you can wait longer to
be serviced again).

>
> - Why don't we keep it simple round robin where a task is simply placed at
>  the end of service tree.

This should work for the idling case, since we provide service
differentiation by means of time slice.
For non-idling case, though, the appropriate placement of queues in
the tree (as given by my formula) can still provide it.

>
> - Secondly, CFQ provides full slice length to queues only which are
>  idling (in case of sequenatial reader). If we do not enable idling, as
>  in case of NCQ enabled SSDs, then CFQ will expire the queue almost
>  immediately and put the queue at the end of service tree (almost).
>
> So if we don't enable idling, at max we can provide fairness, we
> esseitially just let every queue dispatch one request and put  at the end
> of the end of service tree. Hence no fairness....

We should distinguish the two terms fairness and service
differentiation. Fairness is when every queue gets the same amount of
service share. This is not what we want when priorities are different
(we want the service differentiation, instead), but is what we get if
we do just round robin without idling.

To fix this, we can alter the placement in the tree, so that if we
have Q1 with slice S1, and Q2 with slice S2, always ready to perform
I/O, we get that Q1 is in front of the three with probability
S1/(S1+S2), and Q2 is in front with probability S2/(S1+S2).
This is what my formula should achieve.

Thanks,
Corrado

>
> Thanks
> Vivek
>
