Return-Path: <linux-kernel-owner+w=401wt.eu-S935418AbZLGQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbZLGQim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZLGQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZLGQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:38:39 -0500
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
 analyzing lock statistics
From: Steven Rostedt <srostedt@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4B1CBEEB.3090800@cn.fujitsu.com>
References: <20091115022135.GA5427@nowhere>
	 <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20091207044125.GB5262@nowhere> <20091207072752.GG10868@elte.hu>
	 <4B1CBEEB.3090800@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 07 Dec 2009 11:38:05 -0500
Message-Id: <1260203885.31359.177.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 16:38 +0800, Xiao Guangrong wrote:
> 
> Ingo Molnar wrote:
> 
> > Also, i agree that the performance aspect is probably the most pressing 
> > issue. Note that 'perf bench sched messaging' is very locking intense so 
> > a 10x slowdown is not entirely unexpected - we still ought to optimize 
> > it all some more. 'perf lock' is an excellent testcase for this in any 
> > case.
> > 
> 
> Here are some test results to show the overhead of lockdep trace events:
> 
>                    select    pagefault   mmap    Memory par   Cont_SW
>                    latency    latency   latency   R/W BD      latency
> 
> disable ftrace        0         0         0         0          0
> 
> enable all ftrace  -16.65%    -109.80%   -93.62%   0.14%      -6.94%
> 
> enable all ftrace  -2.67%      1.08%     -3.65%   -0.52%      -0.68%
> except lockdep
> 
> 
> We also found big overhead when using kernbench and fio, but we haven't
> verified whether it's caused by lockdep events.

Well, it is expected that recording all locking is going to have a
substantial overhead. In my measurements, a typical event takes around
250ns per event (note, I've gotten this down to 140ns in recent updates,
and even 90ns by disabling integrity checks, but I don't want to disable
those checks in production).

Anyway, if you add just 100ns to every lock taken in the kernel, that
will definitely increase the overhead. Just enable spin_lock() in the
function tracer and watch the performance go down.  This is why, when
using the function tracer I usually add all locking to the notrace
filter. This alone helps tremendously in tracing functions.

-- Steve


