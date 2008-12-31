Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYLaWI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYLaWI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYLaWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:08:47 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38301 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752326AbYLaWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:08:47 -0500
Message-ID: <495BED6D.8040307@sgi.com>
Date: Wed, 31 Dec 2008 14:08:45 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: tip/master merge problem?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

I found this code snippet in kernel/sched.c in the tip/master tree.  It
appears to be a merge mistake:  (cut and pasted - no tabs)

292                 /*
293                  * If this cpu is the one which updates jiffies, then
294                  * give up the assignment and let it be taken by the
295                  * cpu which runs the tick timer next, which might be
296                  * this cpu as well. If we don't drop this here the
297                  * jiffies might be stale and do_timer() never
298                  * invoked.
299                  */
300                 if (cpu == tick_do_timer_cpu)
301                         tick_do_timer_cpu = TICK_DO_TIMER_NONE;
302
303                 if (delta_jiffies > 1)
304
305                 /* Skip reprogram of event if its not changed */
306                 if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
307                         goto out;
308
309                         cpumask_set_cpu(cpu, nohz_cpu_mask);

I think the "Skip reprogram" was inserted into the middle of a previous
if-then statement.

git blames it on:
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 292)              /*
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 293)               * If this cpu is the one which updates jiffies, then
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 294)               * give up the assignment and let it be taken by the
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 295)               * cpu which runs the tick timer next, which might be
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 296)               * this cpu as well. If we don't drop this here the
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 297)               * jiffies might be stale and do_timer() never
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 298)               * invoked.
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 299)               */
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 300)              if (cpu == tick_do_timer_cpu)
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 301)                      tick_do_timer_cpu = TICK_DO_TIMER_NONE;
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 302)
6ba9b346 (Ingo Molnar       2007-02-19 18:11:56 +0000 303)              if (delta_jiffies > 1)
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 304)
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 305)              /* Skip reprogram of event if its not changed */
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 306)              if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 307)                      goto out;
00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 308)
6a7b3dc3 (Rusty Russell     2008-11-25 02:35:04 +1030 309)                      cpumask_set_cpu(cpu, nohz_cpu_mask);

I've Cc'd both interested parties.

Thanks,
Mike
