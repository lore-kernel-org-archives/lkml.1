Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYJFXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYJFXZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbYJFXWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:40890 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbYJFXWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:05 -0400
Date: Mon, 6 Oct 2008 16:17:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 11/28] clockevents: prevent clockevent event_handler ending
	up handler_noop
Message-ID: <20081006231721.GL20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-01.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 7c1e76897492d92b6a1c2d6892494d39ded9680c upstream

There is a ordering related problem with clockevents code, due to which
clockevents_register_device() called after tickless/highres switch
will not work. The new clockevent ends up with clockevents_handle_noop as
event handler, resulting in no timer activity.

The problematic path seems to be

* old device already has hrtimer_interrupt as the event_handler
* new clockevent device registers with a higher rating
* tick_check_new_device() is called
  * clockevents_exchange_device() gets called
    * old->event_handler is set to clockevents_handle_noop
  * tick_setup_device() is called for the new device
    * which sets new->event_handler using the old->event_handler which is noop.

Change the ordering so that new device inherits the proper handler.

This does not have any issue in normal case as most likely all the clockevent
devices are setup before the highres switch. But, can potentially be affecting
some corner case where HPET force detect happens after the highres switch.
This was a problem with HPET in MSI mode code that we have been experimenting
with.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |    3 +--
 kernel/time/tick-common.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -127,6 +127,8 @@ extern int clockevents_register_notifier
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+extern void clockevents_handle_noop(struct clock_event_device *dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -177,7 +177,7 @@ void clockevents_register_device(struct 
 /*
  * Noop handler when we shut down an event device
  */
-static void clockevents_handle_noop(struct clock_event_device *dev)
+void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
@@ -199,7 +199,6 @@ void clockevents_exchange_device(struct 
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -159,6 +159,7 @@ static void tick_setup_device(struct tic
 	} else {
 		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
+		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;

-- 
