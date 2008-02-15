Return-Path: <linux-kernel-owner+w=401wt.eu-S934676AbYBOAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbYBOAGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760547AbYBOAGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:06:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:33890 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbYBOAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pkUvBvPk4Zvm8djto4T9cTCxtQH6FEX4oc1TZsEH6Ot4Tk7NXKbfZF4Uqdi/glHGw4ZdXxN2r44U27dfYXXvtufm8AtNYCrLinEtG0oBE8uhU5xuU7h/6IJfeyfnBDumi1xKu8fb9y0dRsLxRtYXv4weMk8KKGXp+/Rfp5cucLs=
Message-ID: <86802c440802141606m3f44c786tb9ec4e684c71550a@mail.gmail.com>
Date: Thu, 14 Feb 2008 16:06:19 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Greg KH" <gregkh@suse.de>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080214234832.GA14363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802122139.14840.elendil@planet.nl>
	 <20080212205622.GA21986@suse.de>
	 <200802131239.14305.elendil@planet.nl>
	 <20080213165837.GA10129@suse.de>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080214234832.GA14363@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 3:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > after disable cpufreq, i got
>  >
>  > ACPI: Preparing to enter system sleep state S5
>  > Disabling non-boot CPUs ...
>  > kvm: disabling virtualization on CPU1
>  > CPU 1 is now offline
>  > CPU1 is down
>  > kvm: disabling virtualization on CPU2
>  > CPU 2 is now offline
>  > ================> hang here.
>  >
>  > but x86.git/mm could go through down all the cpus....
>  >
>  > interesting...
>
>  i suspect some kobject related race, and i have the feeling this all is
>  timing dependent.
>
>  Andrew started seeing reboot hangs roughly around the time when the
>  kobject changes went upstream. Given that x86.git had flux in that
>  timeframe too i couldnt be sure what caused them.
>
>  i have the fixlet below in x86.git but it didnt solve Andrew's problem
>  so it's parking now at the end of the queue, with no clear purpose in
>  life :-) If it would solve someone's problem it might be revitalized.
>
>  Note: this does not fix any particular bug i know about, it's just a
>  hack.
>
>         Ingo
>
>  ------------------------------>
>  Subject: x86: highprio shutdown hack
>  From: Ingo Molnar <mingo@elte.hu>
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>  ---
>   arch/x86/kernel/reboot.c |   16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
>  Index: linux-x86.q/arch/x86/kernel/reboot.c
>  ===================================================================
>  --- linux-x86.q.orig/arch/x86/kernel/reboot.c
>  +++ linux-x86.q/arch/x86/kernel/reboot.c
>  @@ -396,8 +396,20 @@ static void native_machine_shutdown(void
>         if (!cpu_isset(reboot_cpu_id, cpu_online_map))
>                 reboot_cpu_id = smp_processor_id();
>
>  -       /* Make certain I only run on the appropriate processor */
>  -       set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
>  +       /*
>  +        * Make certain we only run on the appropriate processor,
>  +        * and with sufficient priority:
>  +        */
>  +       {
>  +               struct sched_param schedparm;
>  +               int ret;
>  +
>  +               schedparm.sched_priority = 99;
>  +               ret = sched_setscheduler(current, SCHED_RR, &schedparm);
>  +               WARN_ON_ONCE(1);

so I got

------------[ cut here ]------------
WARNING: at arch/x86/kernel/reboot.c:409 native_machine_shutdown+0x5f/0xb4()
Modules linked in:
Pid: 7173, comm: reboot Not tainted 2.6.25-rc1-smp-00168-g458504f-dirty #33

Call Trace:
 [<ffffffff802521d8>] warn_on_slowpath+0x64/0x8e
 [<ffffffff802464c8>] enqueue_task+0x5c/0x7e
 [<ffffffff8027765c>] rt_mutex_adjust_pi+0x28/0x94
 [<ffffffff8024c075>] sched_setscheduler+0x304/0x33c
 [<ffffffff80237feb>] native_machine_shutdown+0x5f/0xb4
 [<ffffffff80237f6e>] native_machine_restart+0x2e/0x4c
 [<ffffffff8026234b>] sys_reboot+0x140/0x1b2
 [<ffffffff8029bbd2>] handle_mm_fault+0x380/0x705
 [<ffffffff802cc311>] d_kill+0x50/0x7c
 [<ffffffff8097d000>] do_page_fault+0x3bd/0x7c9
 [<ffffffff804d58ae>] __up_read+0x27/0xb5
 [<ffffffff8022432b>] system_call_after_swapgs+0x7b/0x80

---[ end trace eb0e49090acb42b5 ]---
