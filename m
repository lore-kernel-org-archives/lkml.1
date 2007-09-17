Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXIQUt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXIQUt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbXIQUtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:49:47 -0400
Received: from mail1.opticatech.com ([63.253.105.122]:6077 "EHLO
	opticatech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758093AbXIQUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:49:46 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 16:49:46 EDT
Message-ID: <46EEE498.1080500@comcast.net>
Date: Mon, 17 Sep 2007 14:33:28 -0600
From: Chris Rigg <cdrigg@comcast.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CFS patch (v6) -- dynamic RT priorities?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2007 20:33:30.0583 (UTC) FILETIME=[026BFE70:01C7F96A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a system with 2.6.20.7 patched with the v6 CFS patch. I am having 
issues (I believe) with fairness in regards to my real-time tasks. 
First, let me describe my setup:

* I use the kernel preemption config option.
* I am using an Intel Xeon with Hyperthreading enabled (and using the 
SMP config option)
* I have 2 kernel modules -- one that is a device driver (receives 
interrupts from a device) but also spawns a thread for processing 
messages from kernel module 2. Kernel module 2 controls the hardware and 
receives messages from the driver via a message ring. It also puts 
messages into a separate ring to control the hardware through the 
hardware. I have 4 different threads spawned when I insmod this module. 
The 4 threads (call them control threads) all do the same thing (i.e. 
there is a thread associated with each port on the device). The threads 
will get messages from the driver on behalf of their port and send 
control messages back to their port through the driver's message ring, 
etc. This may sound complicated but really all I'm doing is abstracting 
out the details of controlling the hardware from the control threads and 
provide a simple interface (the message rings) for controlling the 
hardware and receiving events from it.
* I have given the 4 control threads and the 1 device driver "receive 
message" thread MAX_RT_PRIO - 1 priority (with a call to 
sched_setscheduler(...).
* As I stated earlier, I use a set of kfifo message rings to communicate 
between a control thread and the driver. When the control thread puts a 
message into the ring for the driver thread, he calls "up()" on a 
semaphore that the driver exported. When the driver puts a message into 
the ring for the control thread, he too calls "up()" on a different 
semaphore exported by the control thread.
* I expect all 5 threads to be the highest priority tasks in the system 
and ALWAYS be scheduled if they are ready (provided that another one of 
my 5 RT prio threads isn't already running or is further ahead in the 
queue).

Ok, so far, I have described my basic setup. Hopefully I'm not doing 
anything out of the ordinary here.

Now, for the problem....

When I have 3 of the 4 control threads running at a very high frequency 
of interrupts (and hence a high volume/high frequency of "up()"s on the 
sync semaphore when the driver puts a message into the control thread's 
ring), it appears that the priority of the 3 are somehow getting 
"elevated" by the scheduler? (Even though I set them to all have equal 
priority of MAX_RT_PRIO.) Is there a dynamic priority factoring in that 
I'm not aware of? Is the scheduler looking at the frequency of 'up()'s 
for that task and sees that they have been scheduled a lot and somehow 
gives them a higher priority over my 4th control thread that isn't 
getting as high a frequency of 'up()'s or something?? My notion of a 
real-time, fair, scheduler would be to have a queue for highest priority 
threads and when a thread is ready to run, it is put into the queue and 
serviced when its at the front of the queue. What it seems like I'm 
seeing is the 3 control threads that get a high frequency of 'ups()' on 
their semaphore get moved to the FRONT of the ready queue? The bottom 
line for me is that I end up missing protocol deadlines for my 4th 
control thread even though the driver is servicing interrupts and 
subsequently putting 'event' message into the ring for the control 
thread in plenty of time. But for some reason, the scheduler doesn't get 
around to scheduling it until its scheduled the other 3 MANY, MANY times.

Does this seem right? Is there away I can disable dynamic priority 
calculation (if that is what's going on here) for my RT threads so they 
are all treated equally at ALL times?

Or is there a "problem" with using semaphores for signaling between 
kernel threads like I'm doing? This technique is preferred in VXWorks 
but maybe I shouldn't be using it in Linux?

Anyway, any help you could provide would be MUCH appreciated.

Thanks in advance
Chris


