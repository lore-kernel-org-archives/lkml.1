Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942Ab0AZXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0AZXm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871Ab0AZXmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:42:55 -0500
Received: from kroah.org ([198.145.64.141]:35052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab0AZXmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233920.962442035@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiaotian Feng <dfeng@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [01/98] clockevent: Dont remove broadcast device when cpu is dead
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiaotian Feng <dfeng@redhat.com>

commit ea9d8e3f45404d411c00ae67b45cc35c58265bb7 upstream.

Marc reported that the BUG_ON in clockevents_notify() triggers on his
system. This happens because the kernel tries to remove an active
clock event device (used for broadcasting) from the device list.

The handling of devices which can be used as per cpu device and as a
global broadcast device is suboptimal.

The simplest solution for now (and for stable) is to check whether the
device is used as global broadcast device, but this needs to be
revisited.

[ tglx: restored the cpuweight check and massaged the changelog ]

Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
LKML-Reference: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clockevents.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -258,7 +258,8 @@ void clockevents_notify(unsigned long re
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    cpumask_weight(dev->cpumask) == 1 &&
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}


