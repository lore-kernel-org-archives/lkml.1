Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698Ab0A0TvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0A0TvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556Ab0A0TvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:51:05 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54085 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab0A0TvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:51:04 -0500
Message-ID: <4B60990C.1030804@linux.vnet.ibm.com>
Date: Wed, 27 Jan 2010 11:50:36 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
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
References: <4B560ACD.4040206@linux.vnet.ibm.com> <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop> <4B57907E.5000207@linux.vnet.ibm.com> <20100121072118.GA10585@elte.hu> <4B58A750.2060607@linux.vnet.ibm.com> <4B58AAF7.60507@linux.vnet.ibm.com> <20100127102834.GA27357@elte.hu>
In-Reply-To: <20100127102834.GA27357@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/2010 2:28 AM, Ingo Molnar wrote:
>
> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>
>> On 1/21/2010 11:13 AM, Corey Ashford wrote:
>>>
>>>
>>> On 1/20/2010 11:21 PM, Ingo Molnar wrote:
>>>>
>>>> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>>>>
>>>>> I really think we need some sort of data structure which is passed
>>>> >from the
>>>>> kernel to user space to represent the topology of the system, and give
>>>>> useful information to be able to identify each PMU node. Whether this is
>>>>> done with a sysfs-style tree, a table in a file, XML, etc... it doesn't
>>>>> really matter much, but it needs to be something that can be parsed
>>>>> relatively easily and *contains just enough information* for the user
>>>>> to be
>>>>> able to correctly choose PMUs, and for the kernel to be able to
>>>>> relate that
>>>>> back to actual PMU hardware.
>>>>
>>>> The right way would be to extend the current event description under
>>>> /debug/tracing/events with hardware descriptors and (maybe) to
>>>> formalise this
>>>> into a separate /proc/events/ or into a separate filesystem.
>>>>
>>>> The advantage of this is that in the grand scheme of things we
>>>> _really_ dont
>>>> want to limit performance events to 'hardware' hierarchies, or to
>>>> devices/sysfs, some existing /proc scheme, or any other arbitrary (and
>>>> fundamentally limiting) object enumeration.
>>>>
>>>> We want a unified, logical enumeration of all events and objects that
>>>> we care
>>>> about from a performance monitoring and analysis point of view, shaped
>>>> for the
>>>> purpose of and parsed by perf user-space. And since the current event
>>>> descriptors are already rather rich as they enumerate all sorts of
>>>> things:
>>>>
>>>> - tracepoints
>>>> - hw-breakpoints
>>>> - dynamic probes
>>>>
>>>> etc., and are well used by tooling we should expand those with real
>>>> hardware
>>>> structure.
>>>
>>> This is an intriguing idea; I like the idea of generalizing all of this
>>> info into one structure.
>>>
>>> So you think that this structure should contain event info as well? If
>>> these structures are created by the kernel, I think that would
>>> necessitate placing large event tables into the kernel, which is
>>> something I think we'd prefer to avoid because of the amount of memory
>>> it would take. Keep in mind that we need not only event names, but event
>>> descriptions, encodings, attributes (e.g. unit masks), attribute
>>> descriptions, etc. I suppose the kernel could read a file from the file
>>> system, and then add this info to the tree, but that just seems bad. Are
>>> there existing places in the kernel where it reads a user space file to
>>> create a user space pseudo filesystem?
>>>
>>> I think keeping event naming in user space, and PMU naming in kernel
>>> space might be a better idea: the kernel exposes the available PMUs to
>>> user space via some structure, and a user space library tries to
>>> recognize the exposed PMUs and provide event lists and other needed
>>> info. The perf tool would use this library to be able to list available
>>> events to users.
>>>
>>
>> Perhaps another way of handing this would be to have the kernel dynamically
>> load a specific "PMU kernel module" once it has detected that it has a
>> particular PMU in the hardware.  The module would consist only of a data
>> structure, and a simple API to access the event data.  This way, only only
>> the PMUs that actually exist in the hardware would need to be loaded into
>> memory, and perhaps then only temporarily (just long enough to create the
>> pseudo fs nodes).
>>
>> Still, though, since it's a pseudo fs, all of that event data would be
>> taking up kernel memory.
>>
>> Another model, perhaps, would be to actually write this data out to a real
>> file system upon every boot up, so that it wouldn't need to be held in
>> memory.  That seems rather ugly and time consuming, though.
>
> I dont think memory consumption is a problem at all. The structure of the
> monitored hardware/software state is information we _want_ the kernel to
> provide, mainly because there's no unified repository for user-space to get
> this info from.
>
> If someone doesnt want it on some ultra-embedded box then sure a .config
> switch can be provided to allow it to be turned off.
>
> 	Ingo

Ok, just so that we quantify things a bit, let's say I have 20 different types 
of PMUs totalling 2000 different events, each of which has a name and text 
description, averaging 300 characters.  Along with that, there's let's say 4 
64-bit words of metadata per event describing encoding, which attributes apply 
to the event, and any other needed info. I don't know how much memory each 
pseudo fs node takes up.  Let me guess and say 128 bytes for each event node 
(the amount taken for the PMU nodes would be negligible compared with the event 
nodes).

So thats 2000 * (300 + 32 + 128) bytes ~= 920KB of memory.

Let's assume that the correct event module can be loaded dynamically, so that we 
don't need to have all of the possible event sets for a particular arch kernel 
build.

Any opinions on whether allocating this amount of kernel memory would be 
acceptable?  It seems like a lot of kernel memory to me, but I come from an 
embedded systems background.  Granted, most systems are going to use a fraction 
of that amount of memory (<100KB) due to having far fewer PMUs and therefore 
fewer distinct event types.

There's at least one more dimension to this.  Let's say I have 16 uncore PMUs 
all of the same type, each of which has, for example 8 events.  As a very crude 
pseudo fs, let's say we have a structure like this:


/sys/devices/pmus/
     uncore_pmu0/
         event0/ (path name to here is the name of the pmu and event)
             description (file)
             applicable_attributes (file)
         event1/
             description
             applicable_attributes
         event2/
             ...
         event7/
             ...
     uncore_pmu1/
         event0/
             description
             applicable_attributes
         ...
     ...
     uncore_pmu15/
         ...

Now, you can see that there's a lot of replication here, because the event 
descriptions and attributes are the same for each uncore pmu.  We can use 
symlinks to link them to the same descriptions and attribute data, but these 
symlinks take up space too, which can add up if there are a lot of identical 
PMUs.  So for complex and large systems, we might consume several meg of memory 
for the pseudo fs.

Note that I'm taking some liberty with the applicable_attributes file.  I know 
some attribute info has to be in there, but I don't have any sort of concrete 
idea as to how to encode it at this point.  The point of this email is to get an 
idea as to how much memory the pseudo fs would consume.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

