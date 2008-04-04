Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYDDO1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYDDO1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYDDO1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:27:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47730 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYDDO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:27:00 -0400
Date: Fri, 4 Apr 2008 20:07:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, skumar@linux.vnet.ibm.com
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080404143701.GA13042@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080403191916.GA30864@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403191916.GA30864@deepthought>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 08:19:16PM +0100, Ken Moffat wrote:
>  Next I went forward to 2.6.25-rc8.  Here, I found that 'patch'
> would not revert the first hunk of that attachment because of a
> context change.  So, I tried reverting only the second hunk (I didn't
> know why it had been changed, so maybe they were to fix different
> problems) - interestingly, that passed all 5 attempts to restart,
> and failed all 5 attempts to shutdown.  I then tried the second
> attachment (which reverts both hunks from rc8) and all of my tests
> passed.

Just to confirm, are you saying you applied patch below on top of
2.6.25-rc8 and it solved your shutdown issues?


---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -510,7 +510,7 @@
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se)) {
 			vruntime -= calc_delta_fair(sysctl_sched_latency,
 						    &cfs_rq->load);
 		}
@@ -1145,7 +1145,7 @@
 	 * More easily preempt - nice tasks, while not making
 	 * it harder for + nice tasks.
 	 */
-	if (unlikely(se->load.weight > NICE_0_LOAD))
+	if (unlikely(se->load.weight != NICE_0_LOAD))
 		gran = calc_delta_fair(gran, &se->load);
 
 	if (pse->vruntime + gran < se->vruntime)


The (reverse of above) patch was required to solve latency issues reported by
several folks (ex: http://ozlabs.org/pipermail/linuxppc-dev/2008-January/050355.html ).

I don't see any obvious reason why this patch affects shutdown. Is there
any way you can get more debug data? Basically when the machine enters
into problem state, I want to see dmesg, /proc/sched_debug output and Sysrq-T
o/p. You could get this by logging into the system over network or (if n/w
is not working in that state) by running this script:

[First ensure that syslogd is capturing kernel messages in
/var/log/messages:

Edit /etc/syslog.conf to ensure it has this line uncommented:

kern.*          /var/log/messages

Restart syslog after any changes
]

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#!/bin/bash

/etc/init.d syslog stop
mv /var/log/messages /var/log/messages.old.$$
touch /var/log/messages
/etc/init.d syslog start

<Initiate Gnome shutdown thr' command line interface> &

sleep 10
echo "Process List" 	> /tmp/sched-log
ps -elf 		>> /tmp/sched-log
echo 			>> /tmp/sched-log
echo "Sched debug"	>> /tmp/sched-log
cat /proc/sched_debug 	>> /tmp/sched-log
echo "Process stack trace" >> /tmp/sched-log
echo 1 > /proc/sys/kernel/sysrq
echo t > /proc/sysrq-trigger 

echo "dmesg output"	>> /tmp/sched-log
cat /var/log/messages 	>> /tmp/sched-log


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

sched-log file size would be large. You could send it to me privately or
host it on a website and send a pointer to it.

- vatsa
