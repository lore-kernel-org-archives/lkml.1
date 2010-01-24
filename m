Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838Ab0AXHYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0AXHYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717Ab0AXHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:24:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab0AXHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:24:22 -0500
Date: Sat, 23 Jan 2010 23:21:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
Message-Id: <20100123232152.4b88d1e3.akpm@linux-foundation.org>
In-Reply-To: <20100123001145.GA7391@kroah.com>
References: <20100123001145.GA7391@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 16:11:45 -0800 Greg KH <gregkh@suse.de> wrote:

> This is the start of the stable review cycle for the 2.6.32.6 release.
> There are 29 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by Monday, January 24, 00:00:00 UTC.
> Anything received after that time might be too late.

2.6.32.6 will still contain the regression described in (for example)

http://bugzilla.kernel.org/show_bug.cgi?id=15117 
http://bugzilla.kernel.org/show_bug.cgi?id=15005

It's fixed with the below revert which has been in -mm (and only in
-mm) for ten days.

I don't what's going on - perhaps we're waiting for Thomas, and he's
otherwise engaged.  There's a fix in the lkml thread "Re: [RFC PATCH
0/4] clockevents: fix clockevent_devices list corruption after cpu
hotplug" to which Thomas replied

    I just applied your patch, but kept the cpuweight check.  This
    is the least intrusive solution for now.  The logic needs an
    overhaul, but thats neither rc4 nor stable material"

but no such patch is present in linux-next.



From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
: Author:     Thomas Gleixner <tglx@linutronix.de>
: AuthorDate: Thu Dec 10 15:35:10 2009 +0100
: Commit:     Thomas Gleixner <tglx@linutronix.de>
: CommitDate: Fri Dec 11 10:28:08 2009 +0100
: 
:     clockevents: Prevent clockevent_devices list corruption on cpu hotplug

due to the regression reported in
http://bugzilla.kernel.org/show_bug.cgi?id=15005

Cc: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Reported-by: Martin Bammer <mrb74@gmx.at>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug
+++ a/kernel/time/clockevents.c
@@ -238,9 +238,8 @@ void clockevents_exchange_device(struct 
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct clock_event_device *dev, *tmp;
+	struct list_head *node, *tmp;
 	unsigned long flags;
-	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -251,19 +250,8 @@ void clockevents_notify(unsigned long re
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
-			list_del(&dev->list);
-		/*
-		 * Now check whether the CPU has left unused per cpu devices
-		 */
-		cpu = *((int *)arg);
-		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
-			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
-				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
-				list_del(&dev->list);
-			}
-		}
+		list_for_each_safe(node, tmp, &clockevents_released)
+			list_del(node);
 		break;
 	default:
 		break;
_

