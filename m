Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0BDHEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:04:16 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51359 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0BDHEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:04:13 -0500
Message-ID: <4B6A716D.90802@dcl.info.waseda.ac.jp>
Date: Thu, 04 Feb 2010 16:04:13 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/12 v2] perf lock: New subcommand "perf lock", for analyzing
 lock statistics
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100131082953.GA12715@elte.hu>
In-Reply-To: <20100131082953.GA12715@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年01月31日 17:29, Ingo Molnar wrote:
>
> FYI, i've applied a file/line-less version of 'perf lock' to perf/core today.
>
> The basic workflow is the usual:
>
>    perf lock record sleep 1     # or some other command
>    perf lock report             # or 'perf lock trace'
>
> [ I think we can do all the things that file/line can do with a less intrusive
>    (and more standard) call-site-IP based approach. For now we can key off the
>    names of the locks, that's coarser but also informative and allows us to
>    progress.
>
>    I've renamed 'perf lock prof' to 'perf lock report' - which is more in line
>    with other perf tools. ]
>
> The tool clearly needs more work at the moment: i have tried perf lock on a 16
> cpus box, and it was very slow, while it didnt really record all that many
> events to justify the slowdown. A simple:
>
>    perf lock record sleep 1
>
> makes the system very slow and requires a Ctrl-C to stop:
>
>   # time perf lock record sleep 1
>   ^C[ perf record: Woken up 0 times to write data ]
>   [ perf record: Captured and wrote 5.204 MB perf.data (~227374 samples) ]
>
>    real	0m11.941s
>    user	0m0.020s
>    sys	0m11.661s
>
> (The kernel config i used witht that is attached.)
>
> My suspicion is that the overhead of CONFIG_LOCK_STAT based tracing is way too
> high at the moment, and needs to be reduced. I have removed the '-R' option
> from perf lock record (which it got from perf sched where it makes sense but
> here it's not really needed and -R further increases overhead), but that has
> not solved the slowdown.
>
> 'top' shows this kind of messy picture of a high-overhead system:
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 15003 root      20   0 28900 1116  784 R 102.2  0.0   0:14.23 perf
> 14981 mingo     20   0 15068 1396  880 R 85.7  0.0   0:11.67 top
> 15036 nobody    30  10  120m  22m 3224 R 74.4  0.1   0:04.47 cc1
> 15030 nobody    30  10  125m  27m 2744 R 64.6  0.1   0:03.88 cc1
>     20 root      20   0     0    0    0 R 53.4  0.0   0:15.04 ksoftirqd/8
>   7646 nobody    30  10 23488  720  264 S 51.9  0.0   0:04.96 distccd
>     43 root      20   0     0    0    0 R 50.2  0.0   0:06.26 events/8
> 15037 nobody    30  10 15696 4248  876 S 39.3  0.0   0:02.36 as
>   2891 nobody    30  10 23488  764  264 R 24.8  0.0   0:03.26 distccd

Yeah, overhead is main problem of perf lock now,
I'll work on it with Frederic's new patches, these are awesome.

>
> A couple of other details i noticed:
>
>   - 'perf lock' does not show up in the list of commands if one types 'perf'.
>     You can fix this by adding it to command-list.txt.
>
>   - i think we should add a reference to 'perf lock' in the config
>     LOCK_STAT entry's help text in lib/Kconfig.debug - so that people can see
>     what tool to use with lock statistics.

Thanks, I've fixed these two points and prepared patch.
I'll send it later.

>
>   - perf report should be used to further reduce the overhead of
>     CONFIG_LOCK_STAT. If we want people to use this to tune for performance, we
>     want it to be exceptionally fast. Both the perf-lock-running and
>     perf-lock-not-running cases should be optimized. (Perhaps dynamic patching
>     techniques should be considered as well.)
>
>   - we waste 30 characters for the 'ID' column in perf lock report, which is in
>     all hexa, while no human would ever really read it, and would rarely rely
>     on it as well. Should be removed and only added back on option request or
>     so.

Yes, address of lockdep is optional thing. This should be removed.

Thanks,
	Hitoshi
