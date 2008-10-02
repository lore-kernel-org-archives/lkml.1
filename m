Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYJBX5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYJBX5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYJBX5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:57:31 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:49587 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYJBX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:57:30 -0400
Message-ID: <48E55FE5.40108@nortel.com>
Date: Thu, 02 Oct 2008 17:57:25 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [bug report] sched: stop_machine() usage causes load balancer to
 misbehave
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 23:57:26.0540 (UTC) FILETIME=[9F019CC0:01C924EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mentioned before that ftrace (specifically the ftraced daemon) seems 
to be interfering with the load balancer.  After some experimenting, it 
appears that any regular calls to stop_machine() will end up confusing 
the load balancer.

As an experiment, I disabled ftraced (which would normally result in 
correct load balancing) but added a single kernel thread which simply 
runs the following loop, where "chrisd2" is a dummy function.

while(1) {
	set_current_state(TASK_INTERRUPTIBLE);
	schedule_timeout(HZ);
	stop_machine(chrisd2, NULL, NULL);
}

With the modified kernel, my testcase shows that the load balancer 
doesn't balance--all tasks remain on one cpu while the other one stays idle.

Most of the users of stop_machine() (kprobes on s390, cpu hotplug, 
module load/unload, numa_zonelist_order, etc.) don't seem to be called 
on a regular basis.  Only ftrace behaves this way, which is why it 
appeared to be the source of the problem.

I haven't tracked down the specific reasons for the misbehaviour, but it 
seems undesirable.

Anyone have any ideas what might be causing this?  Is it a problem with 
the load balancer, or an unavoidable consequence of what stop_machine() 
is doing?

Thanks,

Chris
