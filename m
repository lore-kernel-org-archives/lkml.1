Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZCUOIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZCUOIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbZCUOIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:08:35 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51835 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbZCUOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ez073YZF9mXPwyVW0+rTddohuRb5xKS8vqRSlJC9P1BBRFpWaCiZkFkgwp0kG3PppL
         UVU9W5a/x8do1KkvaGtVoLi0wr3lRri9yRiElfQPbGbQ1mCnMAZxQS1rsiZcECSEggQs
         p1yCwZQWWRFKt7tfBWknfhj/lCf+QFpzgRIqw=
Date: Sat, 21 Mar 2009 15:08:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090321140823.GA5956@nowhere>
References: <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au> <20090316200736.GD8393@nowhere> <1237244137.4964.54.camel@kulgan.wumi.org.au> <20090318001955.GB5143@nowhere> <1237338986.4801.11.camel@kulgan.wumi.org.au> <1237411441.5211.5.camel@kulgan.wumi.org.au> <1237611639.4933.4.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237611639.4933.4.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 03:30:39PM +1030, Kevin Shanahan wrote:
> On Thu, 2009-03-19 at 07:54 +1030, Kevin Shanahan wrote:
> > On Wed, 2009-03-18 at 11:46 +1030, Kevin Shanahan wrote:
> > > On Wed, 2009-03-18 at 01:20 +0100, Frederic Weisbecker wrote:
> > > > Ok, I've made a small script based on yours which could do this job.
> > > > You will just have to set yourself a threshold of latency
> > > > that you consider as buggy. I don't remember the latency you observed.
> > > > About 5 secs right?
> > > > 
> > > > It's the "thres" variable in the script.
> > > > 
> > > > The resulting trace should be a mixup of the function graph traces
> > > > and scheduler events which look like this:
> > > > 
> > > >  gnome-screensav-4691  [000]  6716.774277:   4691:120:S ==> [000]     0:140:R <idle>
> > > >   xfce4-terminal-4723  [001]  6716.774303:   4723:120:R   + [001]  4289:120:S Xorg
> > > >   xfce4-terminal-4723  [001]  6716.774417:   4723:120:S ==> [001]  4289:120:R Xorg
> > > >             Xorg-4289  [001]  6716.774427:   4289:120:S ==> [001]     0:140:R <idle>
> > > > 
> > > > + is a wakeup and ==> is a context switch.
> > > > 
> > > > The script will loop trying some pings and will only keep the trace that matches
> > > > the latency threshold you defined.
> > > > 
> > > > Tell if the following script work for you.
> > 
> > ...
> > 
> > > Either way, I'll try to get some results in my maintenance window
> > > tonight.
> > 
> > Testing did not go so well. I compiled and booted
> > 2.6.29-rc8-tip-02630-g93c4989, but had some problems with the system
> > load when I tried to start tracing - it shot up to around 16-20 or so. I
> > started shutting down VMs to try and get it under control, but before I
> > got back to tracing again the machine disappeared off the network -
> > unresponsive to ping.
> > 
> > When I got in this morning, there was nothing on the console, nothing in
> > the logs to show what went wrong. I will try again, but my next chance
> > will probably be Saturday. Stay tuned.
> 
> Okay, new set of traces have been uploaded to:
> 
>   http://disenchant.net/tmp/bug-12465/trace-3/
> 
> These were done on the latest tip, which I pulled down this morning:
> 2.6.29-rc8-tip-02744-gd9937cb.
> 
> The system load was very high again when I first tried to trace with
> sevarl guests running, so I ended up only having the one guest running
> and thankfully the bug was still reproducable that way.
> 
> Fingers crossed this set of traces is able to tell us something.


Thanks a lot Kevin!

The traces seem indeed much more clearer now.
Looking at the first trace, we begin with qemu which answers to the ping.
By roughly simplying the trace, we have that:


Found buggy latency:  9297.585
Please send the trace you will find on /sys/kernel/debug/tracing/trace
# tracer: function_graph
#
#      TIME       CPU  TASK/PID        DURATION                  FUNCTION CALLS
#       |         |    |    |           |   |                     |   |   |   |

							/* answer the ping (socket write) */
 2668.130735 |   0)  qemu-sy-4048  |               |  sys_writev() {
 2668.130735 |   0)  qemu-sy-4048  |   0.361 us    |    fget_light();
 2668.130744 |   0)  qemu-sy-4048  |               |       netif_rx_ni() {
 2668.130744 |   0)  qemu-sy-4048  |               |         netif_rx() {
 2668.130763 |   0)  qemu-sy-4048  |               |           ipv4_conntrack_in() {
 2668.130764 |   0)  qemu-sy-4048  |               |             nf_conntrack_in() {
 2668.130764 |   0)  qemu-sy-4048  |   0.328 us    |               ipv4_get_l4proto();
 2668.130765 |   0)  qemu-sy-4048  |   0.310 us    |               __nf_ct_l4proto_find();
 2668.130776 |   0)  qemu-sy-4048  |               |                 icmp_packet() {
 2668.130804 |   0)  qemu-sy-4048  |               |                   netif_receive_skb() {
 2668.130804 |   0)  qemu-sy-4048  |               |                     ip_rcv() {
 2668.130824 |   0)  qemu-sy-4048  |               |                       raw_rcv() {
 2668.130824 |   0)  qemu-sy-4048  |   0.307 us    |                         skb_push();
 2668.130825 |   0)  qemu-sy-4048  |               |                           raw_rcv_skb() {
 2668.130832 |   0)  qemu-sy-4048  |               |                             __wake_up_common() {
 2668.130838 |   0)  qemu-sy-4048  |               |                               /* sched_wakeup: task ping:7420 [120] success=1 */
 2668.130839 |   0)  qemu-sy-4048  |   0.312 us    |                           }
                                                                              }
                                                                             }
                                                      [...]

							/* ping was waaiting for this response and is now awaken */
 2668.130876 |   0)  qemu-sy-4048  |               |  schedule() {
 2668.130885 |   0)  qemu-sy-4048  |               |  /* sched_switch: task qemu-system-x86:4048 [120] ==> ping:7420 [120] */
 2668.130885 |   0)  qemu-sy-4048  |               |    runqueue_is_locked() {
 2668.130886 |   0)  qemu-sy-4048  |   0.399 us    |    __phys_addr();
 ------------------------------------------
 0)  qemu-sy-4048  =>   ping-7420   
 ------------------------------------------

 2668.130887 |   0)   ping-7420    |               |                  finish_task_switch() {
 2668.130887 |   0)   ping-7420    |               |                    perf_counter_task_sched_in() {
 2668.130888 |   0)   ping-7420    |   0.319 us    |                      _spin_lock();
 2668.130888 |   0)   ping-7420    |   0.959 us    |                    }
 2668.130889 |   0)   ping-7420    |   1.644 us    |                  }
 2668.130889 |   0)   ping-7420    | ! 298102.3 us |                }
 2668.130890 |   0)   ping-7420    |               |                del_timer_sync() {
 2668.130890 |   0)   ping-7420    |               |                  try_to_del_timer_sync() {
 2668.130890 |   0)   ping-7420    |               |                    lock_timer_base() {
 2668.130890 |   0)   ping-7420    |   0.328 us    |                      _spin_lock_irqsave();
 2668.130891 |   0)   ping-7420    |   0.946 us    |                    }
 2668.130891 |   0)   ping-7420    |   0.328 us    |                    _spin_unlock_irqrestore();
 2668.130892 |   0)   ping-7420    |   2.218 us    |                  }
 2668.130892 |   0)   ping-7420    |   2.847 us    |                }
 2668.130893 |   0)   ping-7420    | ! 298108.7 us |              }
 2668.130893 |   0)   ping-7420    |   0.340 us    |              finish_wait();
 2668.130894 |   0)   ping-7420    |   0.328 us    |              _spin_lock_irqsave();
 2668.130894 |   0)   ping-7420    |   0.324 us    |              _spin_unlock_irqrestore();



As you can see we are in the middle of the dialog between ping and the kvm.
It means that we have lost many traces. I thing that the ring buffer does not have
enough space allocated for these 9 seconds of processing.

Just wait a bit while I'm cooking a better script, or at least trying to get a
better number of entries to allocate to the ring buffer and I come back to you.

But anyway, the scheduler switch and wake up events help a lot.

 
> Regards,
> Kevin.
> 
> 

