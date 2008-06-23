Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYFWP1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYFWP1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYFWP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:27:08 -0400
Received: from saeurebad.de ([85.214.36.134]:41059 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbYFWP1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:27:06 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com>
Date: Mon, 23 Jun 2008 17:26:50 +0200
In-Reply-To: <485F8028.1070302@linux.vnet.ibm.com> (Nageswara R. Sastry's
	message of "Mon, 23 Jun 2008 16:21:20 +0530")
Message-ID: <87y74w41fp.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> writes:

> Hi,
>
> While changing the cpufreq governor with the following script for
> about 30 minutes, the kernel hits a BUG in workqueue.c.  Detailed
> trace attached.
>
> Script:
> #!/bin/bash
>
> while [ 1 ]
> do
> 	for govnrs in ondemand conservative
> 	do
> 		for cpu in 0 1 2 3
> 		do
> 		echo $govnrs > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor
> 		if ! [ -d /sys/devices/system/cpu/cpu${cpu}/cpufreq/${govnrs} ] ; then
> 			echo "Error: Enable to create dir $govnrs"
> 		fi
> 		done
> 	done
> done
>
> Kernel stack trace:
> ------------[ cut here ]------------
> kernel BUG at kernel/workqueue.c:223!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: cpufreq_powersave cpufreq_conservative
> cpufreq_userspace usb_storage usbhid ehci_hcd ohci_hcd uhci_hcd
> usbcore
>
> Pid: 232, comm: kondemand/1 Not tainted (2.6.25.7 #1)
> EIP: 0060:[<c012f61a>] EFLAGS: 00010286 CPU: 1
> EIP is at queue_delayed_work_on+0x20/0x97
> EAX: 00000000 EBX: c483ba94 ECX: c483ba94 EDX: 00000000
> ESI: c483bab0 EDI: f7a3f708 EBP: 00000001 ESP: f7a69f40
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kondemand/1 (pid: 232, ti=f7a68000 task=f794d020 task.ti=f7a68000)
> Stack: 00000000 f7a3e7b0 c483ba80 f7ab5e98 c041e54d 00000040 00000000
> 00000001
>        00000040 00000246 00000000 00000002 00000000 c012ee7f c483ba98
> f7a3e7b0
>        c483ba94 f7a69f9c c012eeba 00000000 00000002 c012ee7f c041e31e
> c099e2a8
> Call Trace:
>  [<c041e54d>] do_dbs_timer+0x22f/0x24f
>  [<c012ee7f>] run_workqueue+0x81/0x187
>  [<c012eeba>] run_workqueue+0xbc/0x187
>  [<c012ee7f>] run_workqueue+0x81/0x187
>  [<c041e31e>] do_dbs_timer+0x0/0x24f
>  [<c012f6fa>] worker_thread+0x0/0xbd
>  [<c012f7ad>] worker_thread+0xb3/0xbd
>  [<c0131acc>] autoremove_wake_function+0x0/0x2d
>  [<c0131a1b>] kthread+0x38/0x5d
>  [<c01319e3>] kthread+0x0/0x5d
>  [<c0105527>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: c3 a1 dc da 6a c0 e9 78 ff ff ff 55 89 c5 57 89 d7 56 53 89 cb
> 8d 71 1c f0 0f ba 29 00 19 c0 31 d2 85 c0 75 76 83 79 1c 00 74 04 <0f>
> 0b eb fe 8d 41 04 39 41 04 74 04 0f 0b eb fe 89 f8 64 8b 15
> EIP: [<c012f61a>] queue_delayed_work_on+0x20/0x97 SS:ESP 0068:f7a69f40
> ---[ end trace 40ca209e9f1ab79d ]---

Added Dave Jones to CC.

The work seems to be queued twice.  Might there be a race in the
activation of the governor?

proc #0					proc #1

				    	if (this_dbs_info->enable == 0)
					<PREEMPTED>
if (this_dbs_info->enable == 0)
  mutex_lock()		        	
  dbs_timer_init()	        	
    queue_delayed_work_on() 
  mutex_unlock()
...
					  mutex_lock()
					  dbs_timer_init()
					    queue_delayed_work_on()

If that might happen, would it be feasible to put the check for ->enable
within the mutex-protection?

	Hannes

---
From: Johannes Weiner <hannes@saeurebad.de>
Subject: cpufreq: Fix race in enabling ondemand/conservative governors

Prevent double activation of the governor if two processes race on the
check for whether the governor is already active.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 5d3a04b..a4902e4 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -486,10 +486,11 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if ((!cpu_online(cpu)) || (!policy->cur))
 			return -EINVAL;
 
-		if (this_dbs_info->enable) /* Already enabled */
-			break;
-
 		mutex_lock(&dbs_mutex);
+		if (this_dbs_info->enable) {
+			mutex_unlock(&dbs_mutex);
+			break;
+		}
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index d2af20d..61705e1 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -508,10 +508,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if ((!cpu_online(cpu)) || (!policy->cur))
 			return -EINVAL;
 
-		if (this_dbs_info->enable) /* Already enabled */
+		mutex_lock(&dbs_mutex);
+		if (this_dbs_info->enable) {
+			mutex_unlock(&dbs_mutex);
 			break;
+		}
 
-		mutex_lock(&dbs_mutex);
 		dbs_enable++;
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
