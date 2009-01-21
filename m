Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZAUOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZAUOfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZAUOfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:35:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38722 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZAUOf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:35:29 -0500
Message-ID: <49773275.3020203@redhat.com>
Date: Wed, 21 Jan 2009 16:34:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kevin Shanahan <kmshanah@ucwb.org.au>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>	 <1232410363.4768.21.camel@kulgan.wumi.org.au>	 <20090120113546.GA26571@elte.hu>	 <1232455343.4895.4.camel@kulgan.wumi.org.au>	 <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu>	 <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>	 <49760E2D.2060109@redhat.com> <1232547932.4895.119.camel@kulgan.wumi.org.au>
In-Reply-To: <1232547932.4895.119.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
> On Tue, 2009-01-20 at 19:47 +0200, Avi Kivity wrote:
>   
>> Steven Rostedt wrote:
>>     
>>> Note, the wakeup latency only tests realtime threads, since other threads
>>> can have other issues for wakeup. I could change the wakeup tracer as
>>> wakeup_rt, and make a new "wakeup" that tests all threads, but it may
>>> be difficult to get something accurate.
>>>       
>> Kevin, can you retest with kvm at realtime priority?
>>     
>
> Running vanilla Linux 2.6.28, kvm-82. First a control test to check that
> the problem is still there when running at normal priority:
>
> --- hermes-old.wumi.org.au ping statistics ---
> 900 packets transmitted, 900 received, 0% packet loss, time 899283ms
> rtt min/avg/max/mdev = 0.119/269.773/13739.426/1230.836 ms, pipe 14
>
> Yeah, sure is.
>
> Okay, so now I set the realtime attributes of the processes for the VM
> instance being pinged:
>
> flexo:~# ps ax | grep 6284
>  6284 ?        Sl     6:11 /usr/local/kvm/bin/qemu-system-x86_64 -smp 2
> -m 2048 -hda kvm-17-1.img -hdb kvm-17-tmp.img -net
> nic,vlan=0,macaddr=52:54:00:12:34:67,model=rtl8139 -net
> tap,vlan=0,ifname=tap17,script=no -vnc 127.0.0.1:17 -usbdevice tablet
> -daemonize
> flexo:~# pstree -p 6284
> qemu-system-x86(6284)─┬─{qemu-system-x86}(6285)
>                       ├─{qemu-system-x86}(6286)
>                       └─{qemu-system-x86}(6540)
>
> (info cpus on the QEMU console shows 6285 and 6286 being the VCPU
> processes. Not sure what the third child is for, maybe vnc?.)
>
> flexo:~# chrt -r -p 3 6284
> flexo:~# chrt -r -p 3 6285
> flexo:~# chrt -r -p 3 6286
> flexo:~# chrt -p 6284
> pid 6284's current scheduling policy: SCHED_RR
> pid 6284's current scheduling priority: 3
> flexo:~# chrt -p 6285
> pid 6285's current scheduling policy: SCHED_RR
> pid 6285's current scheduling priority: 3
> flexo:~# chrt -p 6286
> pid 6286's current scheduling policy: SCHED_RR
> pid 6286's current scheduling priority: 3
>
> And the result of the ping test now:
>
> --- hermes-old.wumi.org.au ping statistics ---
> 900 packets transmitted, 900 received, 0% packet loss, time 899326ms
> rtt min/avg/max/mdev = 0.093/0.157/3.611/0.117 ms
>
> So, a _huge_ difference. But what does it mean?

It means, a scheduling problem.  Can you run the latency tracer (which 
only works with realtime priority), so we can tell if it is (a) kvm 
failing to wake up the vcpu properly or (b) the scheduler delaying the 
vcpu from running.

> P.S. Can someone tell me if I'm doing the CC: to bugme-daemon wrong? I
>      thought that was supposed to add the emails as comments to the
>      bugzilla report?
>   

So long as it isn't complaining, you can continue.

-- 
error compiling committee.c: too many arguments to function

