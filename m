Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647Ab0ARNtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0ARNtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296Ab0ARNtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:49:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:43347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0ARNtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:49:07 -0500
Date: Mon, 18 Jan 2010 13:48:39 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       marc.c.dionne@gmail.com, tglx@linutronix.de, dfeng@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       marc.c.dionne@gmail.com, tglx@linutronix.de, dfeng@redhat.com
In-Reply-To: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
References: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clockevent: Don't remove broadcast device when cpu is dead
Message-ID: <tip-ea9d8e3f45404d411c00ae67b45cc35c58265bb7@git.kernel.org>
Git-Commit-ID: ea9d8e3f45404d411c00ae67b45cc35c58265bb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 13:48:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea9d8e3f45404d411c00ae67b45cc35c58265bb7
Gitweb:     http://git.kernel.org/tip/ea9d8e3f45404d411c00ae67b45cc35c58265bb7
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Thu, 7 Jan 2010 11:22:44 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 18 Jan 2010 14:44:50 +0100

clockevent: Don't remove broadcast device when cpu is dead

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
Cc: stable@kernel.org
---
 kernel/time/clockevents.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..d7395fd 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -259,7 +259,8 @@ void clockevents_notify(unsigned long reason, void *arg)
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    cpumask_weight(dev->cpumask) == 1 &&
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}
