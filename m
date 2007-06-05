Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbXFEHT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbXFEHT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbXFEHTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:19:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXFEHTT (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:19:19 -0400
Date: Tue, 5 Jun 2007 09:19:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605071904.GB25163@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604184106.GG11115@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> sleep_max                :         57476665627
> block_max                :   18014060106626075

hm, this block_max looks a bit suspect, it's 003fffb1359e341b. Does your 
box make any use of cpufreq? (what CPU is it?)

> strace -f doesn't kill the latency, here's an strace:
> 
> 24936 13:39:44.469329 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
> 24936 13:39:44.469572 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
> 24936 13:39:44.469677 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
> 24936 13:39:44.469765 read(7, 0xbfe6c010, 8) = -1 EINTR (Interrupted system call)
> 24936 13:39:48.699490 --- SIGUSR1 (User defined signal 1) @ 0 (0) ---

hm, this indeed implicates some wakeup problem. lguest task 24936's 
relevant stats are:

 block_start              :                   0
 sleep_max                :            21492554
 block_max                :            27044576
 exec_max                 :             4008057
 wait_max                 :          1253670288

the wait_max means it was delayed on the runqueue for 1.2 seconds. Could 
you try to get a /proc/sched_debug snapshot done exactly during the 
'delay' window - it's 4 seconds so you should in theory be able to 
trigger it by doing something like:

  sleep 3; cat /proc/sched_debug > sched_debug.txt

Click into the lguest window and trigger the delay.

	Ingo
