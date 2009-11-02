Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZKBTVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZKBTVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZKBTVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:21:47 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58796 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755607AbZKBTVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:21:46 -0500
Message-ID: <4AEF3143.2030701@sgi.com>
Date: Mon, 02 Nov 2009 11:21:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com>
In-Reply-To: <4AEEBE65.3070202@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> Mike Travis wrote:
>>
>> This set of patches limits the number of repetitious messages which 
>> contain
>> no additional information.  Much of this information is obtainable 
>> from the
>> /proc and /sysfs.   Most of the messages are also sent to the kernel log
>> buffer as KERN_DEBUG messages so it can be used to examine more 
>> closely any
>> details specific to a processor.
> 
> What would be good is to put the information from the booting CPUs
> into some buffer and print it visibly if there's a timeout detected on 
> the BP.

What do you think of this idea....  Add a "mark kernel log buffer" function,
and then if any KERN_NOTE or above happens, it sends the marked info from
the kernel log buffer to the console before the current message.  Set the
marker to '0' to clear.

And I was thinking that you might want to print the history of the previous
cpu that booted ok, before printing the info for the cpu that didn't.  That
way you'd have some data to compare it with?

> 
> Also power of two summaries at a bit odd, but ok.
> 
>> For Processor Information printout:
>>
>>     [   90.968381] Summary Processor Information for CPUS: 0-639
>>     [   90.972033] Genuine Intel(R) CPU    0000 @ 2.13GHz stepping 04
> 
> It would be good to print family/model in this line

There is more info that should be printed?  I'm just calling the current
print_cpu_info using the cpuinfo_x86 for the first cpu in the list.  And
it appears that it is printing the x86_model_id.  Is there some other info
in that struct that should be printed?

> 
>>     [   90.981402] CPU: L1 I cache: 32K, L1 D cache: 32K
>>     [   90.985888] CPU: L2 cache: 256K
>>     [   90.988032] CPU: L3 cache: 24576K
> 
> I would recommend to drop the cache information; this can be easily
> gotten at runtime and is often implied in the CPU name anyways
> (and especially L1 and increasingly L2 too change only very rarely)

Ok, though because of future system upgrades to a UV system, you can
end up with slightly different processors (of the same family).  The
only differences I've detected so far in testing is the stepping has
changed.

> 
>>     [   90.992032] MIN 4266.68 BogoMIPS (lpj=8533371)
>>     [   91.000033] MAX 4267.89 BogoMIPS (lpj=8535789)
> 
> Perhaps an average too? You could put all that on one line.

Sure thing.
> 
> 
>> These lines have been moved to loglevel KERN_DEBUG:
>>
>>     CPU: Physical Processor ID:
>>     CPU: Processor Core ID:
>>     CPU %d/0x%x -> Node %d
>>     <cache line sizes per cpu>
> 
> I think you can just remove them.

I left them in in case we get to the point of printing KERN_DEBUG
messages in case of a failure.  But you think they will not be
necessary in that case?  (I also left them KERN_DEBUG instead of
pr_debug as the latter optimizes out the print if kernel DEBUG
is not defined... which it won't be in 99% of the kernels our
customers run with.  And generally, it's better it get as much
good information as early as possible after a failure, instead
of attempting to recreate the failure with a "debug" kernel
[scheduling time on the system can sometimes be a real pain.]

> 
>>     CPUx is down
> 
> This should be still printed if there's a timeout, or rather print
> a "CPUx is not down" message. Right now there's no timeout detection on 
> shutdown, but
> I guess that wouldn't be too hard to add.

That seems a bit outside the scope of this patch...?

> 
> -Andi

Thanks!
Mike
