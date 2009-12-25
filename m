Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZLYSIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZLYSIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 13:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZLYSIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 13:08:14 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55363 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbZLYSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 13:08:13 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Oops in clockevents_notify()'s BUG_ON
Date: Sat, 26 Dec 2009 03:08:09 +0900
Message-ID: <87y6krkjue.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In poweroff process, I've got Oops in clockevents_notify()'s
BUG_ON. After some investigation, "hpet" clockevent hits BUG_ON().

On x86_64, hpet_legacy_clockevent_register() registers clockevent as


hpet_legacy_clockevent_register()
[...]
	/*
	 * Start hpet with the boot cpu mask and make it
	 * global after the IO_APIC has been initialized.
	 */
	hpet_clockevent.cpumask = cpumask_of(smp_processor_id());
	clockevents_register_device(&hpet_clockevent);


The comment says "boot cpu". But it's not true on x86_64, and one of my
machine is "second cpu" actually. [This might be one of problems]

And on that machine, hpet is used as oneshot_broadcast.

Then, in poweroff process, it calls cpu_down() for the nonboot cpus if
CONFIG_HOTPLUG_CPU is y.  And clockevents_notify() checks clockevent
in clockevent_devices

So, the following code see hpet for broadcast on clockevent_devices. And
like mentioned above, hpet has cpumask like percpu clockevent, but it
is using as broadcast. So, this hits BUG_ON().


clockevents_notify()
[...]
		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
			if (cpumask_test_cpu(cpu, dev->cpumask) &&
			    cpumask_weight(dev->cpumask) == 1) {
				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
				list_del(&dev->list);
			}
		}


Well, so, attached patch fixes the problem on my machine. But I'm not
sure if it's right thing. Can you check it?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 kernel/time/clockevents.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/time/clockevents.c~hpet-shutdown-fix kernel/time/clockevents.c
--- linux-2.6/kernel/time/clockevents.c~hpet-shutdown-fix	2009-12-26 02:47:07.000000000 +0900
+++ linux-2.6-hirofumi/kernel/time/clockevents.c	2009-12-26 02:47:07.000000000 +0900
@@ -258,6 +258,9 @@ void clockevents_notify(unsigned long re
 		 */
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
+			if (tick_is_broadcast_device(dev))
+				continue;
+
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
 			    cpumask_weight(dev->cpumask) == 1) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
_
