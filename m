Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXJDXNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXJDXNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXJDXM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:12:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46990 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbXJDXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:12:56 -0400
Message-ID: <4705735F.7000209@us.ibm.com>
Date: Thu, 04 Oct 2007 16:12:31 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 1/3]  Trace code and documentation
References: <1191342800.31351.9.camel@lc4eb748232119.ibm.com> <p73odff5j1x.fsf@bingen.suse.de> <47053CC7.7090206@us.ibm.com> <20071004211905.GA14399@one.firstfloor.org>
In-Reply-To: <20071004211905.GA14399@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Oct 04, 2007 at 12:19:35PM -0700, David Wilder wrote:
>> Andi Kleen wrote:
>>> "David J. Wilder" <dwilder@us.ibm.com> writes:
>>>> @@ -0,0 +1,160 @@
>>>> +Trace Setup and Control
>>>> +=======================
>>>> +In the kernel, the trace interface provides a simple mechanism for
>>>> +starting and managing data channels (traces) to user space.
>>> Wasn't relayfs supposed to do that already? Why do you need another
>>> wrapper around it? 
>> The code in trace is exactly what all the current users of relay do. 
>> Therefor trace reduces the duplication of code.
> 
> If everybody does this then the code should be just put into
> relayfs?

I disagree, I keeping the code separate (layering if you will) makes it 
easer to use and maintain.

> 
>>
>>> Is this also really still faster than a printk below log level
>>> (without console driver overhead). If not then why not just
>>> use printk?
>> Are you arguing against relayfs or trace?  Trace just makes relayfs 
>> easer to use.  I think relayfs can stand up for it's self.
> 
> I'm arguing against complicated trace mechanisms that are not fast.

What makes trace complicated?  It is just, open ,start/stop, close.  I 
can't see how an trace API could be any simpler.

> 
> At some point when I looked at relayfs it seemed to be reasonably
> fast (per cpu buffers; not much locking,
  over head per call roughtly like putchar()),
> but that might have regressed. 

No regression has occurred.  According the relay documentation if you 
use global bufferers you must use locking.  If you don't want to use 
locking use per-cpu bufferers.

> 
> Your example module with its lock definitely looks very slow and I don't approve
> of it.
> 

If you don't approve of the locking then use per-cpu bufferers.  The 
example will do ether.

>>
>> The example shows a way to create an ASCII data layer.
> 
> ASCII layers don't make much sense imho -- these should just use printk.
> 

So the only way I should pass ASCII to user space is using printk?  I 
don't understand that.  Again nothing in trace limits you to ASCII data.

> Fast dedicated binary log channels make sense though; but you don't
> seem really to be very concentrated on that.

I impose no restriction on what type of data you can pass over trace's 
fast dedicated channels.

> 
>> True, to make trace "fast" you need a data layer that can handle the 
>> requirements of per-cpu buffers.  However there are still advantages of 
>> trace over printk even when using global bufferers: selectable bufferer 
>> sizes,
> 
> printk has selectable buffer sizes too.
> 
>>    "Long term we probably want more complex tracing based on lttng,
>>     but I'm a big fan of starting out simple and doing incremental
>>     changes."
> 
> It's just that relayfs + another not simple layer are definitely not simple.
> 
> For a simple logger I'm thinking more like something like SGI's old
> ktrace module (which undoubtedly many other people have recreated many
> times for specific debugging scenarios)
> 
> But that all only makes sense if the overhead is really kept low
> and i don't see that in your approach.

Is your complaint with the overhead of setting up a trace channel or the 
overhead of writing to a trace channel?   For the later, trace adds 
almost no overhead on top of relay.

> 
> 
>> One advantage of the trace approach is separating control and data 
>> layers, therefor trace can support multiple data layers to fit multiple 
>> requirements.
>>
>> I have my ideas on how to develop data layer, others may have their own 
>> ideas and I welcome the input.
> 
> relayfs was supposed to be that data layer.

I am using the layer definitions described in trace.txt.  In this 
definition relay is a buffering layer.

> 
>> PS: Systemtap has been criticized for introducing out-of-tree kernel 
>> code.  A clear direction from the community is to move re-usable code 
>> in-tree where it can be maintained.  Trace is a move in that direction.
> 
> I'm all for that. I believe a simple fast efficient no frills logger
> would serve systemtap just fine too. But the approach here seems
> to be more to add all kinds of knobs and whizzles until you end
> up with something as slow with printk. And since we already have
> printk another one just doesn't seem to make much sense.

If by knobs you mean the trace controls.  The only one that has any 
effect on the "speed" of tracing is the control to start and stop 
tracing.  And that had been designed to impose the minimal impact 
possible (one "if" in the tracing path).

> 
> -Andi
> 

