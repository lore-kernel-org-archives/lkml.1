Return-Path: <linux-kernel-owner+w=401wt.eu-S936575AbYBVBea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936575AbYBVBea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYBVBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:34:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7240 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYBVBeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:34:12 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5235"; a="757492"
Message-ID: <47BE245F.3030809@qualcomm.com>
Date: Thu, 21 Feb 2008 17:24:47 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com>
In-Reply-To: <47B3BD51.1080706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

> Max Krasnyansky wrote:
>> I was hopping you could answer a couple of questions about module loading/unloading
>> and the stop machine.
>> There was a recent discussion on LKML about CPU isolation patches I'm working on.
>> One of the patches makes stop machine ignore the isolated CPUs. People of course had
>> questions about that. So I started looking into more details and got this silly, crazy 
>> idea that maybe we do not need the stop machine any more :)
>>
>> As far as I can tell the stop machine is basically a safety net in case some locking
>> and recounting mechanisms aren't bullet proof. In other words if a subsystem can actually
>> handle registration/unregistration in a robust way, module loader/unloader does not 
>> necessarily have to halt entire machine in order to load/unload a module that belongs
>> to that subsystem. I may of course be completely wrong on that.
> 
> Nope, it's integral part of module reference counting.  When using
> refcnt for object lifetime management, the last put should be atomic
> against initial get of the object.  This is usually achieved by
> acquiring the lock used for object lookup before putting or using
> atomic_dec_and_lock().
> 
> For module reference counts, this means that try_module_get() and
> try_stop_module() should be atomic.  Note that modules don't use simple
> refcnt so the latter part isn't module_put() but the analogy still
> works.  There are two ways to synchronize try_module_get() against
> try_stop_module() - the traditional is to grab lock in try_module_get()
> and use atomic_dec_and_lock() in try_stop_module(), which works but
> performance-wise bad because try_module_get() is used way much more than
> try_stop_module() is.  For example, an IO command can go through several
> try_module_get()'s.
> 
> So, all the burden of synchronization is put onto try_stop_module().
> Because all of the cpus on the machine are stopped and none of them has
> been stopped in the middle of non-preemptible code, __try_stop_module()
> is synchronized from try_module_get() even though all the
> synchronization try_module_get() does is get_cpu().
Thanks for the info. I guess I missed that from the code. In any case that seems like a 
pretty heavy refcounting mechanism. In a sense that every time something is loaded or 
unloaded entire machine freezes, potentially for several milliseconds. Normally it's not a 
big deal. But once you get more and more CPUs and/or start using realtime apps this becomes
a big deal. And it's plain broken for the use case that I mentioned during CPU isolation 
discussions. ie When user-space thread(s) prevent stopmachine kthread from running, in which
case machine simply hangs until those user-space threads exit.

Initially I assumed that it had to do with subsystems registration/unregistration being
potentially unsafe if it's only for module ref counting there is gotta be a less expensive way.
I'll think some more about it.
 
>> The problem with the stop machine is that it's a very very big gun :). In a sense that 
>> it totally kills all the latencies and stuff since the entire machine gets halted while
>> module is being (un)loaded. Which is a major issue for any realtime apps. Specifically 
>> for CPU isolation the issue is that high-priority rt user-space thread prevents stop 
>> machine threads from running and entire box just hangs waiting for it. 
>> I'm kind of surprised that folks who use monster boxes with over 100 CPUs have not 
>> complained. It's must be a huge hit for those machines to halt the entire thing. 
>>
>> It seems that over the last few years most subsystems got much better at locking and 
>> refcounting. And I'm hopping that we can avoid halting the entire machine these days.
>> For CPU isolation in particular the solution is simple. We can just ignore isolated CPUs. 
>> What I'm trying to figure out is how safe it is and whether we can avoid full halt 
>> altogether.
> 
> Without the stop_machine call, there's no synchronization between
> initial get and final put.  Things will break.
Got it.
Thanks again for the explanation. I'll stare at the module code some more with what you said
in mind.

Max
