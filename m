Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYLMGMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYLMGMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 01:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYLMGMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 01:12:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50573 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbYLMGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 01:12:23 -0500
Date: Sat, 13 Dec 2008 15:11:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       damm@igel.co.jp
Subject: Re: mmotm 2008-12-11-19-42 uploaded (watchdog lib?)
Message-Id: <20081213151126.632a18c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <494319FC.1040908@oracle.com>
References: <200812120345.mBC3jSnt017980@imap1.linux-foundation.org>
	<494319FC.1040908@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 18:12:12 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-12-11-19-42 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.28-rc8:
> 
> 
> All of my mmotm-2008-1211-1942 builds end with:
> 
> kernel/time/clocksource.c:108: error: too few arguments to function 'watchdog->read'
> kernel/time/clocksource.c:113: error: too few arguments to function 'cs->read'
> kernel/time/clocksource.c:173: error: too few arguments to function 'watchdog->read'
> kernel/time/clocksource.c:194: error: too few arguments to function 'watchdog->read'
> make[3]: *** [kernel/time/clocksource.o] Error
> 
This seems to be from  clocksource-pass-clocksource-to-read-callback.patch
CCed to Magnus.

This is my temporal patch.
==

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

kernel/time/clocksource.c: In function ‘clocksource_watchdog’:kernel/time/clocksource.c:108: error: too few arguments to function ‘watchdog->read’
kernel/time/clocksource.c:113: error: too few arguments to function ‘cs->read’
kernel/time/clocksource.c: In function ‘clocksource_check_watchdog’:
kernel/time/clocksource.c:173: error: too few arguments to function ‘watchdog->read’
kernel/time/clocksource.c:194: error: too few arguments to function ‘watchdog->read’
make[2]: *** [kernel/time/clocksource.o] Error 1
make[1]: *** [kernel/time] Error 2
make: *** [kernel] Error 2

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 kernel/time/clocksource.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: mmotm-2.6.28-Dec12/kernel/time/clocksource.c
===================================================================
--- mmotm-2.6.28-Dec12.orig/kernel/time/clocksource.c
+++ mmotm-2.6.28-Dec12/kernel/time/clocksource.c
@@ -105,12 +105,12 @@ static void clocksource_watchdog(unsigne
 
 	resumed = test_and_clear_bit(0, &watchdog_resumed);
 
-	wdnow = watchdog->read();
+	wdnow = clocksource_read(watchdog);
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
-		csnow = cs->read();
+		csnow = clocksource_read(cs);
 
 		if (unlikely(resumed)) {
 			cs->wd_last = csnow;
@@ -170,7 +170,7 @@ static void clocksource_check_watchdog(s
 
 		list_add(&cs->wd_list, &watchdog_list);
 		if (!started && watchdog) {
-			watchdog_last = watchdog->read();
+			watchdog_last = clocksource_read(watchdog);
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer_on(&watchdog_timer,
 				     first_cpu(cpu_online_map));
@@ -191,7 +191,7 @@ static void clocksource_check_watchdog(s
 				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
 			/* Start if list is not empty */
 			if (!list_empty(&watchdog_list)) {
-				watchdog_last = watchdog->read();
+				watchdog_last = clocksource_read(watchdog);
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
 				add_timer_on(&watchdog_timer,

