Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbZLJNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbZLJNIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbZLJNIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbZLJNID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:08:03 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, damm@igel.co.jp, hsweeten@visionengravers.com,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] clockevents: fix clockevent_devices list corruption after cpu hotplug
Date: Thu, 10 Dec 2009 21:07:35 +0800
Message-Id: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've met a list_del corruption, which was reported in
http://lkml.org/lkml/2009/11/27/45. But no response, so I try to debug it
by myself.

After I added some printks to show all elements in clockevent_devices, I
found kernel hangs when I tried to resume from s2ram.

In clockevents_register_device, clockevents_do_notify ADD is always followed
by clockevents_notify_released. Although clockevents_do_notify ADD will use
tick_check_new_device to add new devices and replace old devices to the
clockevents_released list, clockevents_notify_released add them back to
clockevent_devices list.

My system is Quad-Core x86_64, with apic and hpet enables, after boot up,
the elements in clockevent_devices list is :
clockevent_device->lapic(3)->hpet5(3)->lapic(2)->hpet4(2)->lapic(1)->hpet3(1)-
  ->lapic(0)->hpet2(0)->hpet(0)
* () means cpu id

But active clock_event_device is hpet2,hpet3,hpet4,hpet5. Then at s2ram stage,
cpu 1,2,3 is down, then notify CLOCK_EVT_NOTIFY_CPU_DEAD will calls tick_shutdown,
then hpet2,hpet3,hpet4,hpet5 was deleted from clockevent_device list.
So after s2ram, elements in clockevent_device list is:
clockevent_device->lapic(3)->lapic(2)->lapic(1)->lapic(0)->hpet2(0)->hpet(0)

Then at resume stage, cpu 1,2,3 is up, it will register lapic again, and then
perform list_add lapic on clockevent_device list, e.g. list_add lapic(1) on
above list, lapic will move to the clockevent_device->next, but lapic(2)->next
is still point to lapic(1), the list is circular and corrupted then. 

This patchset aims to fixes above behaviour by:
       - on clockevents_register_device, if notify ADD success, move new devices
         to the clockevent_devices list, otherwise move to clockevents_released
         list.
       - on clockevents_notify_released, same behaviour as above.
       - on clockevents_notify CPU_DEAD, remove related devices on dead cpu from
         clockevents_released list.

It makes sure that only active devices on each cpu is on clockevent_devices list.
With this patchset, the list_del corruption disappeared, and suspend/resume, cpu
hotplug works fine on my system. 
