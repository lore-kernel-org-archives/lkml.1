Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987Ab0ATXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0ATXXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318Ab0ATXXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:23:49 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45379 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0ATXXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:23:49 -0500
Message-ID: <4B57907E.5000207@linux.vnet.ibm.com>
Date: Wed, 20 Jan 2010 15:23:42 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop>
In-Reply-To: <1264023204.4283.1124.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/20/2010 1:33 PM, Peter Zijlstra wrote:
> On Wed, 2010-01-20 at 14:34 +0100, Peter Zijlstra wrote:
>
>> So how about PERF_TYPE_{CORE,NODE,SOCKET} like things?
>
> OK, so I read most of the intel uncore stuff, and it seems to suggest
> you need a regular pmu event to receive uncore events (chained setup),
> this seems rather retarded since it wastes a perfectly good pmu event
> and makes configuring all this more intricate...
>
> A well, nothing to be done about that I guess..

Yes, we have a similar situation where in addition to events that are counted on 
core PMU counters, we also have counters that are off-core; in some cases the 
counters are in off-core units which take their actual events from other 
off-core units, in addition to their own events.  So you can see that this can 
be almost arbitrarily complex.

As for the PERF_TYPE_(CORE,NODE,SOCKET) idea, that could still work, even 
though, for example, a socket event may be counted on a core PMU.  Using more 
encodings for the type field, as you've suggested, would allow us to reuse the 
64-bit config space multiple times.  Were you thinking that with the type field 
we'd still re-use the "cpu" argument for the actual pmu address within the 
PERF_TYPE_* space?  If so, that's an interesting idea, but I think it still 
leaves open the problem of how to actually relate those address to the real 
hardware, especially in the case of using a hypervisor which has provided you a 
small subset of the physical hardware in the system.

I really think we need some sort of data structure which is passed from the 
kernel to user space to represent the topology of the system, and give useful 
information to be able to identify each PMU node.  Whether this is done with a 
sysfs-style tree, a table in a file, XML, etc... it doesn't really matter much, 
but it needs to be something that can be parsed relatively easily and *contains 
just enough information* for the user to be able to correctly choose PMUs, and 
for the kernel to be able to relate that back to actual PMU hardware.

In our case, we are looking at /proc/device-tree, and it actually does appear to 
contain enough information for us.  However, since /proc/device-tree is not 
available anywhere but Power arch (/proc/device-tree originates from a data 
structure passed into the OS from the Open Firmware) we'd like to have a more 
general approach that can be used on x86 and other arches.

- Corey

