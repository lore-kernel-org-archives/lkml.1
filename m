Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZEVJmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZEVJmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbZEVJmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:42:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58934 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbZEVJme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:42:34 -0400
Message-ID: <4A1673AF.30508@cn.fujitsu.com>
Date: Fri, 22 May 2009 17:43:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: [PATCH 0/3] ftrace: add tracepoint for timer event
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We can know timer's whole lifecycle as init/start/expire/cancel by
these tracepoints. 

Following tracepoints are introduced as ingo's suggestion in
	http://marc.info/?l=linux-kernel&m=123791899529128&w=2

for timer:
trace_timer_init()
trace_timer_start()
trace_timer_expire()
trace_timer_cancel()

for hrtimer:
trace_hrtimer_init()
trace_hrtimer_start()
trace_hrtimer_expire()
trace_hrtimer_cancel()

for itimer:
itimer_start()
itimer_expire()
itimer_cancel()

Example ftrace output:
for timer:
           <...>-2998  [000] 63501.542376: timer_init: timer=e0b374e0
           <...>-2998  [000] 63501.542424: timer_start: timer=e0b374e0 func=test_timerfuc expires=4294941565 cpu=0
	  <idle>-0     [000] 63514.508219: timer_expire: timer=e0b374e0 func=test_timerfuc
          <idle>-0     [000] 63514.508222: timer_cancel: timer=e0b374e0 func=test_timerfuc

for hrtimer:
           <...>-3628  [001] 64228.304772: hrtimer_init: timer=e0b404cc clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
           <...>-3628  [001] 64228.304793: hrtimer_start: timer=e0b404cc func=test_hrtime expires=1242920654000000000 ns softexpires=1242920654000000000 ns
     ksoftirqd/1-7     [001] 64228.304858: hrtimer_expire: timer=e0b404cc func=test_hrtime
     ksoftirqd/1-7     [001] 64228.304860: hrtimer_cancel: timer=e0b404cc func=test_hrtime

for itimer:
           <...>-4183  [001] 66533.730163: itimer_start: task=main which=0 it_value=13000000000 it_interval=0
          <idle>-0     [001] 66546.698154: itimer_expire: task=main which=0
           <...>-4183  [000] 66546.698533: itimer_cancel: task=main which=0

We already have debugobject in timer to init/activate/deactivate/free,
but it can't be covered function of there tracepoints, because:
1: We can't get timer's lifecycle information in userspace by debugobject,
   it is necessary for system engineer to investigate system trouble caused
   by using timer.
2: We can't get information of whole lifecycle of timer by debugobject, 
   for example, deactivation of a timer.
3: There are many different tracing code in many kernel subsystem as blktrace,
   debugobject, and tracepoint is designed as generic way to unify these
   tracing way.

include/trace/events/timer.h |  249 +++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |    5
 kernel/itimer.c              |   17 ++
 kernel/posix-cpu-timers.c    |    3
 kernel/timer.c               |    9 +
 5 files changed, 279 insertions(+), 4 deletions(-)

