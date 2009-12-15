Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbZLOOXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbZLOOXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbZLOOXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:23:33 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51874 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZLOOXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UdPOPEk2LjfVoby5ZnpfAk035fJlplXznbEj1Uw07GObXSj0giqi9L69GcsqhO3ZWL
         m+yQla8t1HXd2AN3ocVU734VgqcPPg3/+peNSgGCC+VIYADaYycDqez/xmFrkBE6Wz9Z
         GIYe7QQOJDo9bcoybrDfghX1cpZTICi2RwsvM=
Date: Tue, 15 Dec 2009 15:23:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze
	timer's behavior
Message-ID: <20091215142325.GC5833@nowhere>
References: <4B27702F.1080507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27702F.1080507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 07:17:03PM +0800, Xiao Guangrong wrote:
> Hi,
> 
> We introduce 'perf timer' in this patchset, it can analyze timer
> latency and timer function handle time, the usage and result is
> like below:
> 
> # perf timer record
> # perf timer lat --print-lat --print-handle
> -------------------------------------------------------------------------------------------------------
> |   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
> |0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
> |0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
> |0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
> |main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
> |main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |
> 
> ......
> 
> -------------------------------------------------------------------------------------------------------
> |   Timer            |   TYPE   | Avg-handle (ms)|Max-handle(ms)| Max-handle-at-TS(s)|Max-lat-at-func |
> |0xf7ad1f5c          |hrtimer   |0.025           |0.025         |10270.129           |0xc016b5b0      |
> |0xf7903f04          |timer     |0.009           |0.011         |10260.342           |0xc0159240      |
> |0xf787a05c          |hrtimer   |0.031           |0.062         |10267.018           |0xc014cc40      |
> 
> And, in current code, it'll complain with below message when we use
> 'perf timer lat':
>  
>   # ./perf timer lat
>   Warning: unknown op '{'
>   Warning: Error: expected type 5 but read 1
>   Warning: failed to read event print fmt for hrtimer_start
>   Warning: unknown op '{'
>   Warning: Error: expected type 5 but read 1
>   Warning: failed to read event print fmt for hrtimer_expire_entry


Oh and indeed we have some event format complexities to solve
there.

cat /debug/tracing/events/timer/hrtimer_start/format

print fmt: "hrtimer=%p function=%pf expires=%llu softexpires=%llu", REC->hrtimer, REC->function, (unsigned long 
long)(((ktime_t) { .tv64 = REC->expires }).tv64), (unsigned long long)(((ktime_t) { .tv64 = REC->softexpires 
}).tv64)

We should try to simplify this, may be we should just expose
__entry->expires as is.

