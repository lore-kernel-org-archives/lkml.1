Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYI2XLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYI2XLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2XLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:11:11 -0400
Received: from fhw-relay07.plus.net ([212.159.14.148]:41987 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYI2XLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:11:10 -0400
Message-ID: <48E16097.8060905@yahoo.com>
Date: Tue, 30 Sep 2008 00:11:19 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu> <48DFEF8A.3000502@yahoo.com> <20080929083709.GD18663@elte.hu>
In-Reply-To: <20080929083709.GD18663@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: afda823169ee1462681c9e79e1d1cd9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>
>> Any ideas why the issue would go away with a debug kernel though?
> 
> hm, that's weird indeed. You could try to trace the full battery readout 
> itself, via a script like this:
> 
>   cat /debug/tracing/trace > /dev/null        # drain trace
>   cat /proc/acpi/whatever  
>   cat /debug/tracing/trace > trace.txt
> 
> You can even turn on stack backtrace tracing feature, via:
> 
>   echo stacktrace > /debug/tracing/iter_ctrl
> 
> this adds extra trace entries that show the call path of every 
> reschedule. [this attribute is default-disabled.]

(Something bad seems to be happening with my kernels as I have been 
finding strange problems like network-manager detecting the wifi as a 
wired interface unless I did a make clean on my kernel sources before 
compiling). The stalling issue seems to keep coming and going and is 
currently showing up in both debug and non debug kernels.

There are traces when looking at battery information on both AC (where 
the problem is never there) and battery (where the problem always is 
there) here:
http://sucs.org/~sits/test/eeepc-debug/20080929/trace-on-ac.txt.bz2
http://sucs.org/~sits/test/eeepc-debug/20080929/trace-on-battery.txt.bz2 
(15Mbytes uncompressed)

I wasn't quite sure how to tell when a reschedule was done. I simply did 
a grep schedule on the file and most of it seemed reasonable. One part 
that caught my eye was the following:

     speaker-test-3891  [000]  1392.751699: __switch_to <-schedule
           <idle>-0     [000]  1392.752070: account_scheduler_latency 
<-enqueue_task_fair
           <idle>-0     [000]  1392.752091: __switch_to <-schedule
              cat-7717  [000]  1392.752092: del_timer <-schedule_timeout
              cat-7717  [000]  1392.772263: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773224: __tasklet_schedule <-kbd_event
              cat-7717  [000]  1392.773225: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773225: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773226: queue_work <-schedule_work
              cat-7717  [000]  1392.773232: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773240: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773251: schedule_delayed_work 
<-put_queue
              cat-7717  [000]  1392.773251: queue_delayed_work 
<-schedule_delayed_work
              cat-7717  [000]  1392.773258: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773258: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773259: queue_work <-schedule_work
              cat-7717  [000]  1392.773267: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773268: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773268: queue_work <-schedule_work
              cat-7717  [000]  1392.807931: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.839464: __tasklet_schedule <-ath5k_intr
              cat-7717  [000]  1392.839506: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.941867: __tasklet_schedule <-ath5k_intr
              cat-7717  [000]  1393.005963: __tasklet_schedule <-ath5k_intr
              cat-7717  [000]  1393.033222: __switch_to <-schedule

Here a schedule seemingly doesn't happen for a few hundredths of a second...

-- 
Sitsofe | http://sucs.org/~sits/
