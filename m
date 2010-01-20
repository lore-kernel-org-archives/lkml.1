Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030Ab0ATBtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0ATBtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 20:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965Ab0ATBtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 20:49:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51260 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab0ATBto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 20:49:44 -0500
Message-ID: <4B566131.6020300@linux.vnet.ibm.com>
Date: Tue, 19 Jan 2010 17:49:37 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <20100120004430.GA23484@basil.fritz.box>
In-Reply-To: <20100120004430.GA23484@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2010 4:44 PM, Andi Kleen wrote:
> On Tue, Jan 19, 2010 at 11:41:01AM -0800, Corey Ashford wrote:
>> 4. How do you encode uncore events?
>> ----
>> Uncore events will need to be encoded in the config field of the
>> perf_event_attr struct using the existing PERF_TYPE_RAW encoding.  64 bits
>> are available in the config field, and that may be sufficient to support
>> events on most systems. However, due to  the proliferation and added
>> complexity of PMUs we envision, we might want to add another 64-bit config
>> (perhaps call it config_extra or config2) field to encode any extra
>> attributes that might be needed.  The exact encoding used, just as for the
>> current encoding for core events, will be on a per-arch and possibly
>> per-system basis.
>
> I don't think a raw hex number will scale anywhere. You'll need a human
> readable event list / sub event masks with help texts.
>
> Often uncore events have specific restrictions, and that needs
> to be enforced somewhere too.
>
> Doing that all in a clean way that is also usable
> by programs likely needs a lot more thinking.

I left out one critical detail here: I had in mind that we'd be using a library 
like libpfm for handling the issue of event names + attributes to raw code 
translation.  In fact, we are using libpfm today for this purpose in the 
PAPI/perf_events substrate implementation.

>
>
>> bits   field
>> ------ -----
>> 3..0   PMU number 0-15  /* specifies which of several identical PMUs being
>> addressed */
>> 7..4   core id 0-15
>> 8..8   node id 0-1
>> 11..9  chip id 0-7
>> 16..12 blade id 0-31
>> 23..17 rack id 0-128
>
> Such a compressed addressing scheme doesn't seem very future proof.
> e.g. core 4 bits for the core is already obsolete (see the "80 core chip" that
> was recently announced)

Agreed.  If the designer is very generous with the size of each field, it could 
hold up for quite awhile, but still there's a problem with relating these 
addresses to actual hardware.

>
>
>> probably put something together for a particular system.
>>
>> Addressing Option 2)
>>
>> Have the kernel create nodes for each uncore PMU in /sys/devices/system or
>> other pseudo file system, such as the existing  /proc/device-tree on Power
>> systems. /sys/devices/system or /proc/device-tree could be explored by the
>> user tool, and the user could then specify the path of the requested PMU
>> via a string which the kernel could interpret.  To be overly simplistic,
>> something like "/sys/devices/system/pmus/blade4/cpu0/vectorcopro1".  If we
>> settled on a common tree root to use, we could specify only the relative
>> path name, "blade4/cpu0/vectorcopro1".
>
> That's a more workable scheme, but you still need to find a clean
> way to describe topology (see above). The existing examples in sysfs
> are unfortuately all clumpsy imho.
>

Yes, I agree.  Also it's easy to construct a system design that doesn't have a 
hierarchical topology.  A simple example would be a cluster of 32 nodes, each of 
which is connected to its 31 neighbors.  Perhaps for the purposes of just 
enumerating PMUs, a tree might be sufficient, but it's not clear to me that it 
is mathematically sufficient for all topologies, not to mention if it's 
intuitive enough to use.  For example, highly-interconnected components might 
require that PMU leaf nodes be duplicated in multiple branches, i.e. PMU paths 
might not be unique in some topologies.

I'm certainly open to better alternatives!


Thanks for your thoughts,

- Corey

