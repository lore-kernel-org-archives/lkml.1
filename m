Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZCHXTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZCHXTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZCHXS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:18:56 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57302 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZCHXSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:18:55 -0400
Date: Sun, 8 Mar 2009 23:18:50 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [TIP,BISECTED] Negative nice values have become big positive numbers
Message-ID: <20090308231850.GB24445@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgot to cc lkml. Resending...)

Formally negative nice values have started become very big in positive
integers in -tip kernels:

    2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    

I've just finished bisecting down to this commit:

commit 1427cdf0592368bdec57276edaf714040ee8744f
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri Mar 6 17:21:47 2009 +0100

    tracing: infrastructure for supporting binary record

    Impact: save on memory for tracing
    
    Current tracers are typically using a struct(like struct ftrace_entry,
    struct ctx_switch_entry, struct special_entr etc...)to record a binary
    event. These structs can only record a their own kind of events.
    A new kind of tracer need a new struct and a lot of code too handle it.
    
    So we need a generic binary record for events. This infrastructure
    is for this purpose.
    
    [fweisbec@gmail.com: rebase against latest -tip, make it safe while sched
    tracing as reported by Steven Rostedt]

    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>
    LKML-Reference: <1236356510-8381-3-git-send-email-fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

I haven't had a chance to try reverting it but here's the bisect log:

git bisect start
# bad: [8a2b9322fa3f95ab51a863d5095543a32dd9ea8f] Merge branch 'x86/mm-v2'
git bisect bad 8a2b9322fa3f95ab51a863d5095543a32dd9ea8f
# good: [3a450de1365d20afde406f0d9b2931a5e4a4fd6a] x86: UV: remove uv_flush_tlb_others() WARN_ON
git bisect good 3a450de1365d20afde406f0d9b2931a5e4a4fd6a
# good: [e13d8d0e99b8242db9d415f6548378716773fc79] Merge branch 'auto-kmemcheck-next' into auto-latest
git bisect good e13d8d0e99b8242db9d415f6548378716773fc79
# good: [bbfc9e1a1b3d32170cefc3cff3adf0cffe00e48b] manual merge of auto-perfcounters-next
git bisect good bbfc9e1a1b3d32170cefc3cff3adf0cffe00e48b
# good: [6fb755b0f709921e98e50ddf3c7537129e0b11f7] Merge branch 'tracing/core'
git bisect good 6fb755b0f709921e98e50ddf3c7537129e0b11f7
# good: [cd3c1cde262b0f068d27d980648892b2843966d4] Merge git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog
git bisect good cd3c1cde262b0f068d27d980648892b2843966d4
# bad: [902b3c2ce7bb48418da33880df4596cddb07e4e5] Merge branch 'x86/apic'
git bisect bad 902b3c2ce7bb48418da33880df4596cddb07e4e5
# good: [12c0faeaad9f764d4532500c84074b83540f4012] Merge branch 'sched/cleanups'
git bisect good 12c0faeaad9f764d4532500c84074b83540f4012
# good: [0538dc9a21063dae6e1f1e945dec10f781b3c12e] Merge branch 'tracing/ftrace'
git bisect good 0538dc9a21063dae6e1f1e945dec10f781b3c12e
# good: [78ff7fae04554b49d29226ed12536268c2500d1f] x86: implement atomic text_poke() via fixmap
git bisect good 78ff7fae04554b49d29226ed12536268c2500d1f
# bad: [9de36825b321fe9fe9cf73260554251af579f4ca] tracing: trace_bprintk() cleanups
git bisect bad 9de36825b321fe9fe9cf73260554251af579f4ca
# bad: [1ba28e02a18cbdbea123836f6c98efb09cbf59ec] tracing: add trace_bprintk()
git bisect bad 1ba28e02a18cbdbea123836f6c98efb09cbf59ec
# bad: [1427cdf0592368bdec57276edaf714040ee8744f] tracing: infrastructure for supporting binary record
git bisect bad 1427cdf0592368bdec57276edaf714040ee8744f

-- 
Sitsofe | http://sucs.org/~sits/
