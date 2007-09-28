Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXI1NWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXI1NWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXI1NWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:22:37 -0400
Received: from rtr.ca ([76.10.145.34]:1656 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXI1NWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:22:36 -0400
Message-ID: <46FD001A.3070309@rtr.ca>
Date: Fri, 28 Sep 2007 09:22:34 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
Subject: Re: Problems with SMP & ACPI powering off
References: <46FC20B7.4000606@rtr.ca> <200709280000.53001.rjw@sisk.pl> <200709280057.44789.lenb@kernel.org> <200709281455.29069.rjw@sisk.pl>
In-Reply-To: <200709281455.29069.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 28 September 2007 06:57, Len Brown wrote:
>> On Thursday 27 September 2007 18:00, Rafael J. Wysocki wrote:
>>> On Thursday, 27 September 2007 23:29, Mark Lord wrote:
>>>> Question:  do we disable all CPUs except 0 when doing ACPI power off?
>>> No, but we should.
>> We used to.
>> It is absolutely mandatory -- else it confuses the BIOS on some boards
>> b/c it isn't expecting SMM to get entered from other than cpu0.
> 
> Can we use the CPU hotplug for that, like in the suspend/hibernation case?

Well, so far it's working:  about ten poweroffs since I patched it,
and no issues with any of them.  Prior to that, it seemed like about
one in five poweroffs wouldn't (power off).

It'll take a lot more testing to confirm, though.

What can I call to determine if more than one CPU is enabled, anyway?

Here's the hack I'm using here, very situation (2 cores) specific,
and it still has some printk's leftover with a sleep so I have time
to read them before the lights go out.  :)

--- old/arch/i386/kernel/reboot.c	2007-09-27 17:17:00.000000000 -0400
+++ linux/arch/i386/kernel/reboot.c	2007-09-27 17:15:35.000000000 -0400
@@ -393,8 +393,22 @@
 	.halt = native_machine_halt,
 };
 
+static void kill_cpu1(void)
+{
+	extern int cpu_down(unsigned int cpu);
+
+	printk(KERN_EMERG "kill_cpu1: was running on CPU%d\n", smp_processor_id());
+	/* Some bioses don't like being called from CPU != 0 */
+	set_cpus_allowed(current, cpumask_of_cpu(0));
+	printk(KERN_EMERG "kill_cpu1: now running on CPU%d\n", smp_processor_id());
+	cpu_down(1);
+	printk(KERN_EMERG "kill_cpu1: done\n");
+	msleep(1000);
+}
+
 void machine_power_off(void)
 {
+	(void)kill_cpu1();
 	machine_ops.power_off();
 }
 
