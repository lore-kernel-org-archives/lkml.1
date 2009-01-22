Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZAVT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZAVT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZAVT5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:57:35 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:37779 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZAVT5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:57:34 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20090121151820.GA23813@elte.hu>
References: <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu>
	 <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
	 <49760E2D.2060109@redhat.com>
	 <1232547932.4895.119.camel@kulgan.wumi.org.au>
	 <49773275.3020203@redhat.com>  <20090121151820.GA23813@elte.hu>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Fri, 23 Jan 2009 06:27:17 +1030
Message-Id: <1232654237.4885.8.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 16:18 +0100, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> > It means, a scheduling problem.  Can you run the latency tracer (which 
> > only works with realtime priority), so we can tell if it is (a) kvm 
> > failing to wake up the vcpu properly or (b) the scheduler delaying the 
> > vcpu from running.
> 
> Could we please get an ftrace capture of the incident?
> 
> Firstly, it makes sense to simplify the tracing environment as much as 
> possible: for example single-CPU traces are much easier to interpret.
> 
> Can you reproduce it with just one CPU online? I.e. if you offline all the 
> other cores via:
> 
>   echo 0 > /sys/devices/system/cpu/cpu1/online
> 
>   [etc.]
> 
> and keep CPU#0 only, do the latencies still occur?
> 
> If they do still occur, then please do the traces that way.
> 
> [ If they do not occur then switch back on all CPUs - we'll sort out the
>   traces ;-) ]
> 
> Then please build a function tracer kernel, by enabling:
> 
>   CONFIG_FUNCTION_TRACER=y
>   CONFIG_FUNCTION_GRAPH_TRACER=y
>   CONFIG_DYNAMIC_FTRACE=y

Looks like the function graph tracer is only in 2.6.29, so I've updated
now to 2.6.29-rc2-00013-gf3b8436.

Again, a control test to make sure the problem still occurs:

--- hermes-old.wumi.org.au ping statistics ---
64 packets transmitted, 64 received, 0% packet loss, time 63080ms
rtt min/avg/max/mdev = 0.168/479.893/4015.950/894.721 ms, pipe 5

Yes, plenty of delays there. Next, checking if I can reproduce with only
one core online:

echo 0 > /sys/devices/system/cpu/cpu1/online
echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online
...

--- hermes-old.wumi.org.au ping statistics ---
900 packets transmitted, 900 received, 0% packet loss, time 900253ms
rtt min/avg/max/mdev = 0.127/38.937/2082.347/170.348 ms, pipe 3

--- hermes-old.wumi.org.au ping statistics ---
900 packets transmitted, 900 received, 0% packet loss, time 900995ms
rtt min/avg/max/mdev = 0.127/428.398/17126.227/1634.980 ms, pipe 18

So it looks like I can do the simplified trace. I've run out of time for
that this morning, but I'll spend some time on it over the weekend.
Thanks for the detailed instructions - it doesn't look like it will be
too hard.

Cheers,
Kevin.


