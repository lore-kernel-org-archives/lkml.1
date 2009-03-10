Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZCJPEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZCJPEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZCJPDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:03:51 -0400
Received: from mail-gx0-f163.google.com ([209.85.217.163]:47773 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbZCJPDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JwNX5U+38UrFVN0wRJYr18pqyQXfSmKXQEcvTPc5UmUPPKDfVFjGLeuCMavPaE8s6g
         4JD5+h02y51Ey7X8RS+yXaUUjNSU4RvgnPb2CQb2ppObzMH8RfUODych+U5l+NgkFvcL
         v7g+h7md1UR1RQi8aeUr2rCYv3NFPsz/lJGfg=
MIME-Version: 1.0
In-Reply-To: <1236695198.25234.329.camel@laptop>
References: <b6a2d2e20903100449k7bb325eau26ad724e6303080b@mail.gmail.com>
	 <1236695198.25234.329.camel@laptop>
Date: Tue, 10 Mar 2009 15:03:45 +0000
Message-ID: <b6a2d2e20903100803nb815353pc4d36c4c9f144d71@mail.gmail.com>
Subject: Re: cgroup, balance RT bandwidth
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 2:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-03-10 at 11:49 +0000, Rolando Martins wrote:
>> Just to confirm, cpuset.sched_load_balance doesn't work with RT, right?
>
> It should. It should split the RT balance domain just the same.
>
>> You cannot have tasks for sub-domain 2 to utilize bandwidth of
>> sub-domain 3, right?
>
> If you disabled load-balancing on your root domain (1 below) then
> indeed, tasks from 2 will not be able to consume bandwidth from tasks in
> 3.
>
> The available bandwidth is related to the number of cpus in the balance
> domain.

cgroup
echo 1 > cpuset.sched_load_balance

cgroup/2
echo 0 > cpuset.mems
echo 0-2 > cpuset.cpus
echo 450000 > cpu.rt_runtime_us

cgroup/3
echo 0 > cpuset.mems
echo 3 > cpuset.cpus
echo 450000 > cpu.rt_runtime_us


I have a small test that uses a loop to utilize 100% cpu (SCHED_FIFO).
When I run 2 tests on cgroup/3, it only uses bandwidth from cpu 3
(100%), the balancing isn't happening.
As I use the SCHED_FIFO, the 2 processes run sequentially.

Can you check this? Maybe I am doing something wrong...



>
>>
>>                               __1__
>>                              /        \
>>                             2         3
>>                       (50% rt)  (50% rt )
>>
>> For my application domain it would be interesting to have
>> rt_runtime_ns as a min. of allocated rt and not a max.
>
>> Ex. If an application of domain 2 needs to go up to 100% and domain 3
>> is idle, then it would be cool to let it utilize the full bandwidth.
>
>> (we also could have a hard upper limit in each sub-domain, like
>> hard_up=0.8, i.e. even if we could get 100%, we will only utilize
>> 80%); in other words, rt having the same cpu bandwidth management behavior
>> as the "best-effort" tasks.
>>
>> Could this be done?
>
> Possibly, but since RT scheduling is all about determinism, I see no use
> in adding something best-effort -- that simply defeats the purpose.
>
>
