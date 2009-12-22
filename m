Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZLVNBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZLVNBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZLVNBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:01:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZLVNBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:01:50 -0500
Message-ID: <4B30C2D1.4030006@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 21:00:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] perf_event: introduce 'perf timer' to analyze timer's
 behavior
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere>
In-Reply-To: <20091215142325.GC5833@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We introduce 'perf timer' in this patchset, it can report
number of activated/expired/canceled timers, timer latency
and timer function runtime.

Changlog v1->v2:
- export HZ in timer's tracepoint, we can use it to get
  TIMER/ITIMER_VIRTUAL/ITIMER_PROF exact latency as Ingo's
  suggestion

- rename 'perf timer latency' to 'perf timer report',
  because it not only show timer latency but also show timer
  function runtime, timer activated/canceled/expired statistics
  and canceled timer list(TODO)

Below changes are all from Thomas's suggestion:
- fix a lot of typos and bad ideas

- use hash table instead of RB tree to record timer

- let output information more readable

- report number of activated/canceled/expired timers

- support to filter timer types:
  '--type' can do it

TODO:
- Show canceled timer list that is suggested by Thomas

- Any suggestion are welcome.

===============================================
Usage:
- record timer events:
  #perf timer record
  #^C

- show timer statistics:
  #perf timer report
 
Statistics
==========
Activated timers number:
	HRTIMER: 37199 TIMER: 828 ITIMER_PROF: 2 ITIMER_VIRTUAL: 2 ITIMER_REAL: 18 

Expired timers number:
 	HRTIMER: 34912 TIMER: 617 ITIMER_PROF: 1 ITIMER_VIRTUAL: 1 ITIMER_REAL: 1 

Canceled timers number:
  	HRTIMER: 37200 TIMER: 829 ITIMER_PROF: 1 ITIMER_VIRTUAL: 1 ITIMER_REAL: 17
 
- show timer latency:
  #perf timer report --print-lat
                            Timer Latency List
[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]
-------------------------------------------------------------------------
     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s
-------------------------------------------------------------------------
smbd           |HRTIMER        |1.563        |1.563        |40666.379    
irqbalance     |HRTIMER        |0.842        |2.484        |40670.231    
	...... 
vi             |HRTIMER        |0.123        |0.123        |40637.065    
events/1       |TIMER          |168.420      |1008.000     |40677.006    
events/0       |TIMER          |87.759       |1008.000     |40618.009    
	......
main           |ITIMER_PROF    |0.000        |0.000        |40661.023    
main           |ITIMER_VIRTUAL |0.000        |0.000        |40642.829    
main           |ITIMER_REAL    |0.133        |0.133        |40622.731 


- show timer function runtime:
 #perf timer report --print-runtime
                            Timer Function Runtime List
[ Abbreviations: Avg = average; func = function; rt = runtime; ts = timestamp ]
-------------------------------------------------------------------------------
     Timer     | Type  |Avg-rt ms|Max-rt ms|      Max-rt-func      | Max-rt-ts s
-------------------------------------------------------------------------------
smbd           |HRTIMER|0.020    |0.020    |hrtimer_wakeup         |40666.379
irqbalance     |HRTIMER|0.012    |0.020    |hrtimer_wakeup         |40670.231
	......
events/1       |TIMER  |0.009    |0.017    |delayed_work_timer_fn  |40646.090
events/0       |TIMER  |0.009    |0.091    |delayed_work_timer_fn  |40651.105

- you can use '--print-lat' and '--print-runtime' at the same time:
 #perf timer report --print-runtime --print-lat

                          Timer Latency List
[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]
-------------------------------------------------------------------------
     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s
-------------------------------------------------------------------------
smbd           |HRTIMER        |1.563        |1.563        |40666.379    
irqbalance     |HRTIMER        |0.842        |2.484        |40670.231    
	......
	                       Timer Function Runtime List
[ Abbreviations: Avg = average; func = function; rt = runtime; ts = timestamp ]
-------------------------------------------------------------------------------
     Timer     | Type  |Avg-rt ms|Max-rt ms|      Max-rt-func      | Max-rt-ts s
-------------------------------------------------------------------------------
smbd           |HRTIMER|0.020    |0.020    |hrtimer_wakeup         |40666.379
irqbalance     |HRTIMER|0.012    |0.020    |hrtimer_wakeup         |40670.231

- Select timer type which you are interesting:
  #perf timer report --print-lat --type timer
                          Timer Latency List
[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]
-------------------------------------------------------------------------
     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s
-------------------------------------------------------------------------
events/1       |TIMER          |168.420      |1008.000     |40677.006    
events/0       |TIMER          |87.759       |1008.000     |40618.009    
events/1       |TIMER          |57.000       |153.000      |40634.571   

You can specify more types, such as: '--type timer,hrtimer'

