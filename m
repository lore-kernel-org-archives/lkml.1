Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZLOLSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZLOLSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZLOLSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:18:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbZLOLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:18:51 -0500
Message-ID: <4B27702F.1080507@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 19:17:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf_event: introduce 'perf timer' to analyze timer's
 behavior
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We introduce 'perf timer' in this patchset, it can analyze timer
latency and timer function handle time, the usage and result is
like below:

# perf timer record
# perf timer lat --print-lat --print-handle
-------------------------------------------------------------------------------------------------------
|   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
|0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
|0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
|0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
|main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
|main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |

......

-------------------------------------------------------------------------------------------------------
|   Timer            |   TYPE   | Avg-handle (ms)|Max-handle(ms)| Max-handle-at-TS(s)|Max-lat-at-func |
|0xf7ad1f5c          |hrtimer   |0.025           |0.025         |10270.129           |0xc016b5b0      |
|0xf7903f04          |timer     |0.009           |0.011         |10260.342           |0xc0159240      |
|0xf787a05c          |hrtimer   |0.031           |0.062         |10267.018           |0xc014cc40      |

And, in current code, it'll complain with below message when we use
'perf timer lat':
 
  # ./perf timer lat
  Warning: unknown op '{'
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for hrtimer_start
  Warning: unknown op '{'
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for hrtimer_expire_entry
 
 It's because perf parse "hrtimer_start" and "hrtimer_expire_entry" fail,
 but it not hurt using.
 
 See: http://lkml.org/lkml/2009/10/12/726
 
 include/trace/events/timer.h            |    8 
 tools/perf/Documentation/perf-timer.txt |   40 +
 tools/perf/Makefile                     |    1 
 tools/perf/builtin-sched.c              |    3 
 tools/perf/builtin-timer.c              |  954 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                    |    1 
 tools/perf/command-list.txt             |    1 
 tools/perf/perf.c                       |    1 
 tools/perf/util/trace-event-parse.c     |   25 
 tools/perf/util/trace-event.h           |    4 
 10 files changed, 1030 insertions(+), 8 deletions(-)
