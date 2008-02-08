Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYBHXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYBHXMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYBHXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:12:11 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:44621 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbYBHXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:12:08 -0500
Message-ID: <47ACE1BA.3070103@qualcomm.com>
Date: Fri, 08 Feb 2008 15:11:54 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: rusty@rustcorp.com.au
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com>
In-Reply-To: <47ABC08C.8010101@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> Hi Rusty,
> 
> I was hopping you could answer a couple of questions about module loading/unloading
> and the stop machine.
> There was a recent discussion on LKML about CPU isolation patches I'm working on.
> One of the patches makes stop machine ignore the isolated CPUs. People of course had
> questions about that. So I started looking into more details and got this silly, crazy 
> idea that maybe we do not need the stop machine any more :)
> 
> As far as I can tell the stop machine is basically a safety net in case some locking
> and recounting mechanisms aren't bullet proof. In other words if a subsystem can actually
> handle registration/unregistration in a robust way, module loader/unloader does not 
> necessarily have to halt entire machine in order to load/unload a module that belongs
> to that subsystem. I may of course be completely wrong on that.
>  
> The problem with the stop machine is that it's a very very big gun :). In a sense that 
> it totally kills all the latencies and stuff since the entire machine gets halted while
> module is being (un)loaded. Which is a major issue for any realtime apps. Specifically 
> for CPU isolation the issue is that high-priority rt user-space thread prevents stop 
> machine threads from running and entire box just hangs waiting for it. 
> I'm kind of surprised that folks who use monster boxes with over 100 CPUs have not 
> complained. It's must be a huge hit for those machines to halt the entire thing. 
> 
> It seems that over the last few years most subsystems got much better at locking and 
> refcounting. And I'm hopping that we can avoid halting the entire machine these days.
> For CPU isolation in particular the solution is simple. We can just ignore isolated CPUs. 
> What I'm trying to figure out is how safe it is and whether we can avoid full halt 
> altogether.
> 
> So. Here is what I tried today on my Core2 Duo laptop
>> --- a/kernel/stop_machine.c
>> +++ b/kernel/stop_machine.c
>> @@ -204,11 +204,14 @@ int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
>>  
>>         /* No CPUs can come up or down during this. */
>>         lock_cpu_hotplug();
>> +/*
>>         p = __stop_machine_run(fn, data, cpu);
>>         if (!IS_ERR(p))
>>                 ret = kthread_stop(p);
>>         else
>>                 ret = PTR_ERR(p);
>> +*/
>> +       ret = fn(data);
>>         unlock_cpu_hotplug();
>>  
>>         return ret;
> 
> ie Completely disabled stop machine. It just loads/unloads modules without full halt.
> I then ran three scripts:
> 
> while true; do
>         /sbin/modprobe -r uhci_hcd
>         /sbin/modprobe uhci_hcd
>         sleep 10
> done
> 
> while true; do
>         /sbin/modprobe -r tg3
>         /sbin/modprobe tg3
>         sleep 2
> done
> 
> while true; do
>         /usr/sbin/tcpdump -i eth0
> done
> 
> The machine has a bunch of USB devices connected to it. The two most interesting 
> are a Bluetooth dongle and a USB mouse. By loading/unloading UHCI driver we're touching
> Sysfs, USB stack, Bluetooth stack, HID layer, Input layer. The X is running and is using 
> that USB mouse. The Bluetooth services are running too.
> By loading/unloading TG3 driver we're touching sysfs, network stack (a bunch of layers).
> The machine is running NetworkManager and tcpdumping on the eth0 which is registered 
> by TG3.
> This is a pretty good stress test in general let alone the disabled stop machine. 
> 
> I left all that running for the whole day while doing normal day to day things. 
> Compiling a bunch of things, emails, office apps, etc. That's where I'm writing this
> email from :). It's still running all that :) 
> 
> So the question is do we still need stop machine ? I must be missing something obvious.
> But things seem to be working pretty well without it. I certainly feel much better about 
> at least ignoring isolated CPUs during stop machine execution. Which btw I've doing
> for a couple of years now on a wide range of the machines where people are inserting 
> modules left and right. 
> 
> What do you think ?
> 
> Thanx
> Max

Quick update on this.
I've also ran
	while true; do
	        sudo mount -o loop loopfs loopmnt && dd if=/dev/zero of=loopmnt/dummy bs=1M
	        sudo umount loopmnt
	        sleep 2
	done
and
	while true; do
	        /sbin/modprobe -r loop
	        /sbin/modprobe loop
	        sleep 1
	done
in parallel on the Core2 Quad box for about 6 hours now. Same thing. No signs of problems 
whatsoever, with the "stop machine" completely disabled. Everything is working as expected.
Here we're exercising sysfs, block and fs layers.
So I'm now even more eager to see your response :).

btw Does anyone else have a module load/unload scenario that definitely requires stop machine ?

Max












