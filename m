Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204Ab0A1Ton@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0A1Ton (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A1Tom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:44:42 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45456 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0A1Tom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:44:42 -0500
Message-ID: <4B61E91B.3070204@linux.vnet.ibm.com>
Date: Thu, 28 Jan 2010 11:44:27 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop> <4B57907E.5000207@linux.vnet.ibm.com> <20100121072118.GA10585@elte.hu> <4B58A750.2060607@linux.vnet.ibm.com> <4B58AAF7.60507@linux.vnet.ibm.com> <20100127102834.GA27357@elte.hu>  <4B60990C.1030804@linux.vnet.ibm.com> <1264676244.4283.2093.camel@laptop>  <4B61D0CB.4090809@linux.vnet.ibm.com> <1264705607.4283.2120.camel@laptop>
In-Reply-To: <1264705607.4283.2120.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2010 11:06 AM, Peter Zijlstra wrote:
> On Thu, 2010-01-28 at 10:00 -0800, Corey Ashford wrote:
>>
>> I don't quite get what you're saying here.  Perhaps you are thinking
>> that all uncore units are associated with a particular cpu node, or a
>> set of cpu nodes?  And that there's only one uncore unit per cpu (or set
>> of cpus) that needs to be addressed, i.e. no ambiguity?
>
> Well, I was initially thinking of the intel uncore thing which is memory
> controller, so node, level.
>
> But all system topology bound pmus can be done that way.
>
>> That is not going to be the case for all systems.  We can have uncore
>> units that are associated with the entire system,
>
> Right, but that's simple too.
>
>> for example PMUs in an I/O device.
>
>> And we can have multiple uncore units of a particular
>> type, for example multiple vector coprocessors, each with its own PMU,
>> and are associated with a single cpu or a set of cpus.
>>
>> perf_events needs an addressing scheme that covers these cases.
>
> You could possible add a u64 pmu_id field to perf_event_attr and use
> that together with things like:
>
>    PERF_TYPE_PCI, attr.pmu_id = domain:bus:device:function encoding
>    PERF_TYPE_SPU, attr.pmu_id = spu-id
>

Thank you for that clarification.

One of Ingo's comments was that he wants perf to be able to expose all of the 
available PMUs via the perf tool.  That perf should be able to parse some data 
structure (somewhere) that would contain all of the info the user would need to 
choose a particular PMU.  Do you have some ideas about how that could be 
accomplished using the above encoding scheme?  I can see how it would be fairly 
easy to come up with a PERF_TYPE_* encoding per-topology, and then interpret all 
of those bits correctly within the kernel (which is saavy to that topology), but 
I don't see how there would be a straight-forward way to expose that structure 
to perf.  How would perf know which of those encodings apply to the current 
system, how many PMUs there are of each type, etc.

That's why I'm leaning toward a /sys/devices-style pseudo fs at the moment.  If 
there's a simpler, better way, I'm open to it.

> But before we go there the perf core needs to be extended to deal with
> multiple hardware pmus, something which isn't too hard but we need to be
> careful not to bloat the normal code paths for these somewhat esoteric
> use cases.

Is this something you are looking into?

- Corey

