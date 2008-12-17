Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760000AbYLQHpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYLQHpX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYLQHpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:45:06 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45186 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYLQHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=OOrNBHDjtZBf3KQtIIbAP3dc/75LtWNvEANODjTqPnCk+W4xQjI1RUGexmWMS4VbPH
         645QV3fOUTAuCjJffz5AEppMsRNvdXYaWMHO5sVUHMztg+dJMYfeoM+2Zobl++mtwjZY
         /cvAjsq/PplyNs6pX3azBbi70LJGsU61e0N8Q=
Message-ID: <7c86c4470812162345p1b771d49m446de858debfb759@mail.gmail.com>
Date: Wed, 17 Dec 2008 08:45:01 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <dada1@cosmosbay.com>,
        "Robert Richter" <robert.richter@amd.com>,
        "Arjan van de Veen" <arjan@infradead.org>,
        "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4946DAEE.3050402@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	 <4942BF69.4030402@nortel.com>
	 <7c86c4470812150650t3b96d571nba14be2028fa9d0c@mail.gmail.com>
	 <4946DAEE.3050402@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 11:32 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> stephane eranian wrote:
>>
>> On Fri, Dec 12, 2008 at 8:45 PM, Chris Friesen <cfriesen@nortel.com>
>> wrote:
>>
>>> stephane eranian wrote:
>>>
>>>
>>>> What happens in the following test case:
>>>>
>>>>  - 2-way system (cpu0, cpu1)
>>>>
>>>>  - on cpu0, two processes P1, P2, each self-monitoring and counting
>>>> event
>>>> E1.
>>>>   Event E1 can only be measured on counter C1.
>>>>
>>>>  - on cpu1, there is a cpu-wide session, monitoring event E1, thus using
>>>> C1
>>>>
>>>>  - the scheduler decides to migrate P1 onto CPU1. You now have a
>>>> conflict on C1.
>>>>
>>>> How is this managed?
>>>
>>> Prevent the load balancer from moving P1 onto cpu1?
>>>
>>
>> You don't want to do that.
>>
>> There was a reason why the scheduler decided to move the task.
>> Now, because of monitoring you would change the behavior of the task
>> and scheduler.
>> Monitoring should be unintrusive. You want the task/scheduler to
>> behave as if no monitoring
>> was present otherwise what is it you are actually measuring?
>
> In a scenario where the system physically cannot gather the desired data
> without influencing the behaviour of the program, I see two options:
>
> 1) limit the behaviour of the system to ensure that we can gather the
> performance monitoring data as specified
>
> 2) limit the performance monitoring to minimize any influence on the
> program, and report the fact that performance monitoring was limited.
>
> You've indicated that you don't want option 1, so I assume that you prefer
> option 2.  In the above scenario, how would _you_ handle it?
>
That's right, you have to fail monitoring.

In this particular example, it is okay for per-thread sessions to each use C1.
Any cpu-wide session trying to access C1 should fail. Vice versa if a
cpu-wide session is using C1, then no per-thread session can be accessing it.

Things can get even more complicated than that even for per-thread sessions.
Some PMU registers may be shared per core, e.g, Nehalem or Pentium 4. Thus
if HT is enabled, you also have to fail per-thread sessions, as only
one can grab
the resource globally.
