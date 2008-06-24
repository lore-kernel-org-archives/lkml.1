Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYFXJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYFXJRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYFXJRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:17:07 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39492 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFXJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:17:05 -0400
Message-ID: <4860BB8E.2070505@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2008 14:47:02 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan>
In-Reply-To: <87y74w41fp.fsf@skyscraper.fehenstaub.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> 
> From: Johannes Weiner <hannes@saeurebad.de>
> Subject: cpufreq: Fix race in enabling ondemand/conservative governors
> 
> Prevent double activation of the governor if two processes race on the
> check for whether the governor is already active.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 5d3a04b..a4902e4 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -486,10 +486,11 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		if ((!cpu_online(cpu)) || (!policy->cur))
>  			return -EINVAL;
> 
> -		if (this_dbs_info->enable) /* Already enabled */
> -			break;
> -
>  		mutex_lock(&dbs_mutex);
> +		if (this_dbs_info->enable) {
> +			mutex_unlock(&dbs_mutex);
> +			break;
> +		}
> 
>  		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
>  		if (rc) {
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index d2af20d..61705e1 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -508,10 +508,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		if ((!cpu_online(cpu)) || (!policy->cur))
>  			return -EINVAL;
> 
> -		if (this_dbs_info->enable) /* Already enabled */
> +		mutex_lock(&dbs_mutex);
> +		if (this_dbs_info->enable) {
> +			mutex_unlock(&dbs_mutex);
>  			break;
> +		}
> 
> -		mutex_lock(&dbs_mutex);
>  		dbs_enable++;
> 
>  		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);

Applied the above patch against 2.6.25.7 kernel and tested the same, But 
unluckily the above patch didn't stop hitting kernel bug at 
kernel/workqueue.c:223
Hitting bug time got delayed near to 2hrs with the above patch.

 >> Kernel stack trace:
------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:223!
invalid opcode: 0000 [#2] SMP
Modules linked in: cpufreq_powersave cpufreq_conservative 
cpufreq_userspace usbhid usb_storage ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 232, comm: kondemand/1 Tainted: G      D  (2.6.25.7.cpufreqpatch #2)
EIP: 0060:[<c012f61a>] EFLAGS: 00010286 CPU: 1
EIP is at queue_delayed_work_on+0x20/0x97
EAX: 00000000 EBX: c483ba94 ECX: c483ba94 EDX: 00000000
ESI: c483bab0 EDI: f7a39708 EBP: 00000001 ESP: f7a69f40
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kondemand/1 (pid: 232, ti=f7a68000 task=f79b4120 task.ti=f7a68000)
Stack: 00000000 f7a377b0 c483ba80 f78bed80 c041e54d 00000040 00000000 
00000001
        00000040 00000246 00000000 00000002 00000000 c012ee7f c483ba98 
f7a377b0
        c483ba94 f7a69f9c c012eeba 00000000 00000002 c012ee7f c041e31e 
c099e2a8
Call Trace:
  [<c041e54d>] do_dbs_timer+0x22f/0x24f
  [<c012ee7f>] run_workqueue+0x81/0x187
  [<c012eeba>] run_workqueue+0xbc/0x187
  [<c012ee7f>] run_workqueue+0x81/0x187
  [<c041e31e>] do_dbs_timer+0x0/0x24f
  [<c012f6fa>] worker_thread+0x0/0xbd
  [<c012f7ad>] worker_thread+0xb3/0xbd
  [<c0131acc>] autoremove_wake_function+0x0/0x2d
  [<c0131a1b>] kthread+0x38/0x5d
  [<c01319e3>] kthread+0x0/0x5d
  [<c0105527>] kernel_thread_helper+0x7/0x10
  =======================
Code: c3 a1 dc da 6a c0 e9 78 ff ff ff 55 89 c5 57 89 d7 56 53 89 cb 8d 
71 1c f0 0f ba 29 00 19 c0 31 d2 85 c0 75 76 83 79 1c 00 74 04 <0f> 0b 
eb fe 8d 41 04 39 41 04 74 04 0f 0b eb fe 89 f8 64 8b 15
EIP: [<c012f61a>] queue_delayed_work_on+0x20/0x97 SS:ESP 0068:f7a69f40
---[ end trace 1f82bd8b1ee896cc ]---

And when the script is running opened one more terminal and issued the 
following command to observe the state of governors.

# watch -n 1 "cat /proc/cpuinfo | grep 'cpu MHz' ; cat 
/proc/acpi/processor/CPU*/performance;  cat 
/sys/devices/system/cpu/*/cpufreq/scaling_governor; cat 
/sys/devices/system/cpu/*/cpufreq/scaling_cur_freq"

The above command hit with an another kernel BUG at 
kernel/workqueue.c:272 the kernel stack trace is,

------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:272!
invalid opcode: 0000 [#1] SMP
Modules linked in: cpufreq_powersave cpufreq_conservative 
cpufreq_userspace usbhid usb_storage ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 233, comm: kondemand/2 Not tainted (2.6.25.7.cpufreqpatch #2)
EIP: 0060:[<c012ee7b>] EFLAGS: 00010212 CPU: 2
EIP is at run_workqueue+0x7d/0x187
EAX: f7a377b0 EBX: c4844a98 ECX: 00000000 EDX: 00000000
ESI: f7a37718 EDI: c4844a94 EBP: f79f9f9c ESP: f79f9f98
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kondemand/2 (pid: 233, ti=f79f8000 task=f79b5020 task.ti=f79f8000)
Stack: c041e31e c099e2a8 00000000 c061ec35 f7a37718 c012f6fa f7a3773c 
00000000
        c012f7ad 00000000 f79b5020 c0131acc f79f9fc8 f79f9fc8 f7a37718 
00000000
        c0131a1b c01319e3 00000000 c0105527 f784bef0 00000000 00000000 
00000000
Call Trace:
  [<c041e31e>] do_dbs_timer+0x0/0x24f
  [<c012f6fa>] worker_thread+0x0/0xbd
  [<c012f7ad>] worker_thread+0xb3/0xbd
  [<c0131acc>] autoremove_wake_function+0x0/0x2d
  [<c0131a1b>] kthread+0x38/0x5d
  [<c01319e3>] kthread+0x0/0x5d
  [<c0105527>] kernel_thread_helper+0x7/0x10
  =======================
Code: e8 d3 2f 16 00 8b 46 1c 89 7e 48 8b 08 8b 50 04 89 51 04 89 0a 89 
40 04 89 00 89 f0 e8 59 ff 39 00 8b 43 fc 83 e0 fc 39 f0 74 04 <0f> 0b 
eb fe f0 0f ba 73 fc 00 8b 46 4c 31 c9 31 d2 68 7f ee 12
EIP: [<c012ee7b>] run_workqueue+0x7d/0x187 SS:ESP 0068:f79f9f98
---[ end trace 1f82bd8b1ee896cc ]---

Regards
R.Nageswara Sastry, CSTE, CEH, CSTM
Linux Technology Center
IBM India System & Technology Lab
