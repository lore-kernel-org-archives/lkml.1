Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZCDORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZCDORT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCDORK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:17:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59059 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZCDORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:17:08 -0500
Message-ID: <763f59fb21ff480d0fc69487f8858fdc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <344eb09a0903040411n12379babjb62d31d28b77d1e6@mail.gmail.com>
References: <49A65455.4030204@cn.fujitsu.com>
    <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
    <1236066689.18955.27.camel@twins>
    <d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
    <1236073236.18955.46.camel@twins>
    <2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
    <1236081288.5330.4105.camel@laptop>
    <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0903032354r38d74c48p217d338cba7159e8@mail.gmail.com>
    <20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0903040411n12379babjb62d31d28b77d1e6@mail.gmail.com>
Date: Wed, 4 Mar 2009 23:17:02 +0900 (JST)
Subject: Re: [PATCH] remove rq->lock from cpuacct cgroup v2
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Bharata B Rao" <bharata.rao@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>, kenchen@google.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao さんは書きました：
> On Wed, Mar 4, 2009 at 1:50 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Wed, 4 Mar 2009 13:24:43 +0530
>> Bharata B Rao <bharata.rao@gmail.com> wrote:
>>
>>> Instead of subsystems handling all these percpu counter problems
>>> themselves, shouldn't we be using percpu_counter subsytem and let it
>>> handle all the issues transparently for us ? I am not sure if all
>>> these problems have been addressed in percpu_counter, but would like
>>> to know why we are not using percpu_counter for these kinds of things
>>> and enhance percpu_counter if it can't handle some of the issues which
>>> we are solving here specifically for cpuacct subsystem ?
>>>
>> At first, generic per-cpu counter sounds interesting but to be honest,
>> some special handling is used for cpuacct based on its characteristic.
>>
>
> Just trying to understand this clearly ...
>
>> &#160;- Writer works under non-preemptable context.
>
> Which means the writer is running with preemption disabled.
> percpu_counter writes (via percpu_counter_add) don't assume anything
> and disable preemption themselves. Is this the problem or is there a
> bigger issue here why percpu_counter can't be used ?
>
Ah, just means it doesn't call disable_preempt() explicitly and
use __get_per_cpu() (not get_cpu_var) and smp_processor_id (not get_cpu).


>> &#160;- There is only one writer.
>
> Not sure how you have optimized for this case in cpuacct.
Because there is only one writer, I used seq_counter not seq_lock.
(there are no atomic ops by this.)

> percpu_counters use spinlocks to serialize writers. Are you saying
> using spinlocks for this 1 writer case is too much ?
I'm sorry I noticed there is lib/percpu_counter now.......
I think lib/percpu_counter does proper jobs.

> Also note that they update 32 bit percpu counters without any lock
> and take spinlocks only when they do a batch update to the 64bit counter.
>
Hmm, cpuacct's one uses hierachical update of several counters at once.
So, some private code like mine is not so bad, I think.

What I think now is it's ok to see your patch first and later do
this kind of update to avoid locks if necessary. This patch is micro
optimization and not in hurry.

Thanks,
-Kame

