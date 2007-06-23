Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXFWFOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXFWFOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 01:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXFWFOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 01:14:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbXFWFOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 01:14:45 -0400
Date: Fri, 22 Jun 2007 22:14:22 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622221422.7888a382@oldman>
In-Reply-To: <20070622040014.234651401@goodmis.org>
References: <20070622040014.234651401@goodmis.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 00:00:14 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> There's a very nice paper by Matthew Willcox that describes Softirqs,
> Tasklets, Bottom Halves, Task Queues, Work Queues and Timers[1].
> In the paper it describes the history of these items.  Softirqs and
> tasklets were created to replace bottom halves after a company (Mindcraft)
> showed that Microsoft on a 4x SMP box would out do Linux. It was discovered
> that this was due to a bottle neck caused by the design of Bottom Halves.
> So Alexey Kuznetsov and Dave Miller [1] (and I'm sure others) created
> softirqs and tasklets to multithread the bottom halves.
> 
> This worked well, and for the time it shut-up Microsoft^WMindcraft from
> saying Linux was slow at networking.
> 
> Time passed, and Linux developed other nifty tools, like kthreads and
> work queues. These run in a process context and are not as menacing to
> latencies as softirqs and tasklets are.  Specifically, a tasklet,
> acts as a task by only being able to run the function on one CPU
> at a time. The same tasklet can not run on multiple CPUS.  So in that
> aspect it is like a task (a task can only exist on one CPU at a time).
> But a tasklet is much harder on the rest of the system because it
> runs in interrupt context.  This means that if a higher priority process
> wants to run, it must wait for the tasklet to finish before doing so.
> 
> The most part, tasklets today are not used for time critical functions.
> Running tasklets in thread context is not harmful to performance of
> the overall system. But running them in interrupt context is, since
> they increase the overall latency for high priority tasks.
>

You will need to search and convert all network drivers that are using
tasklets. Drivers like the ipw2200, will need to be converted to NAPI,
and you probably have to fix a couple of places in the ieee80211 stack as well.

