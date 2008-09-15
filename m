Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYIORCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYIORCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYIORCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:02:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58217 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbYIORCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:02:36 -0400
Message-ID: <48CE94F9.6080104@redhat.com>
Date: Mon, 15 Sep 2008 13:01:45 -0400
From: Christopher Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Cornelius, Martin (DWBI)" <Martin.Cornelius@smiths-heimann.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Server process stalled during massive thread creation : scheduler
 problem ?
References: <531F9EE7AD1E874595D59997FD3EAEED043D7666@COSSMGMBX05.EMAIL.CORP.TLD>
In-Reply-To: <531F9EE7AD1E874595D59997FD3EAEED043D7666@COSSMGMBX05.EMAIL.CORP.TLD>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelius, Martin (DWBI) wrote:
> Hello scheduler hackers,
> 
> i just realized a behaviour of the scheduler that gets me thinking...
> 
> This is my test scenario:
> On an otherwise unloaded machine, i run a server process that accepts
> TCP connections, and after a client has connected, just echoes all the
> packets that the client sends. A single client (sitting on another
> machine) connects to the server, and then continuously sends packets (of
> about 1000 bytes), and reads the echo. For each packet, the client
> measures the round-trip-time time it takes to send the packet and
> receive the echo. If nothing else happens on the server, this times are
> always very short, a few millseconds or less.
> 
> While this echoing test is running, i set the server machine under
> massive CPU load by starting a load-generating process that starts a
> couple of threads. All threads run an endless loop without any I/O or
> other blocking.
> 
> Behavior with 2.6.27rc6: If the number of threads started in the
> load-generating process is sufficiently large (> 100), the server
> process seems to be stalled during the startup of the load-generator.
> With 100 threads in the load generator, the client observes one or two
> round-trip-times of more than 1 second during load-generator startup.
> When the load generator starts 1000 threads simultanously, the client is
> stalled several times, one of them lasting more than 30 seconds. 
> However, this stalling only appears during the startup of the
> load-generator. After some time, the round trip times observed by the
> client settle down, and from that point on are all reasonably short
> again.

This is expected behavior.

> I also conducted this test with older kernels:
> 
> 2.4.36: With this kernel, behaviour was really weird: When the server
> was loaded with >100 threads, the client was stalled again and again for
> several seconds, than ran smoothly for some time, until another period
> of stalling began. It looked like the scheduler screwed up periodically,
> until the bubble birsted and the stalling disappeared for a few seconds.
> 
> 2.6.25.16: The client is only stalled during the startup of the load
> generating process. However, for really long times. With 200 threads in
> the load generator, i observered stalling for more than a minute.
> 
> Thus, the current kernel seems to pass this test best, but not
> perfectly. Of course one might argue (like my colleagues do) that this
> test presents a completely unrealistic scenario: hundreds of threads
> started at the sime time, all not blocking. However, if i think of a
> 'BIG' java application server, i can imagine that a similar situation
> could arise. From this perspective, one might say the behaviour of the
> scheduler is not optimal and should be improved. If a server does not
> respond for one minute, it's clients might (reasonably but erronously in
> this case) conclude that the server is severely broken.

I would conclude that the application is severely broken, not the server itself. 
  The scheduler is trying to be fair.  Unless you're assigning priorities, it 
has no way of knowing that those 1000 CPU hog processes are less important than 
your netcat process.  Once those processes have shown to be much longer-running 
than netcat, the kernel realizes that giving netcat priority is the the best 
approximation to ideal shortest-time-to-completion-first scheduling, so netcat 
gets to run whenever it's able.

Even big java application servers don't just spin on the CPU forever.  They do 
some amount of setup, and then block until they receive requests.  They 
certainly have a load spike at startup, but not this severe, unless they're 
badly misconfigured.

> What do you think ?

I think the scheduler is working correctly.  If you still see this behavior when 
you give your netcat process higher scheduler priority, then we can talk about bugs.

> BTW, the server was equipped with a dual-core Pentium CPU 3.40GHz.

Now I'm even more surprised it held up so well.

-- Chris
