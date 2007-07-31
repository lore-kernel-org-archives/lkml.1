Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbXGaQp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbXGaQp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbXGaQpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:45:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630AbXGaQpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:45:46 -0400
Date: Tue, 31 Jul 2007 18:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Kenneth Prugh <ken69267@gmail.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070731164538.GB13373@elte.hu>
References: <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com> <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com> <20070731094526.GA16300@elte.hu> <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com> <20070731141857.GA22209@elte.hu> <b21f8390707310914p435c8b06r878db20f6803cdc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b21f8390707310914p435c8b06r878db20f6803cdc6@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Hawkins <darthmdh@gmail.com> wrote:

> For the newly-tested kernel (-ck+sched_yield_hack) it was 4-5 seconds 
> for initial load, same as CFS normally does for me.  I think the 8 
> second one was because I got in quick and the system was still running 
> some startup crap (so I blame disk i/o not the scheduler).  I'll keep 
> an eye on it just in case, but hardly consider it a regression at this 
> stage.

okay. If you suspect some regression then there are various ways to get 
less subjective metrics of delays.

Firstly, you might want to look into desktop-action recorders to measure 
precise latencies of on-desktop sequences that are important to you.

To get a 'cache cold' system you can do:

 echo 1 > /proc/sys/vm/drop_caches

this zaps all the VM/vfs caches in the system, so you can do an 
arbitrary number of cache-cold and cache-hot measurements as well.

Another source of information about desktop latencies is in the 
/proc/<PID>/sched files if CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS is 
enabled. For example here's the delays of all my firefox threads:

$ grep max /proc/`pidof firefox-bin`/task/*/sched | sort -t: -k 3 -n | tail -10
/proc/3016/task/3041/sched:se.exec_max              :               15865
/proc/3016/task/3031/sched:se.exec_max              :               31604
/proc/3016/task/3032/sched:se.exec_max              :               46892
/proc/3016/task/3032/sched:se.wait_max              :              511850
/proc/3016/task/3016/sched:se.exec_max              :             1013570
/proc/3016/task/3016/sched:se.block_max             :            14870850
/proc/3016/task/3016/sched:se.wait_max              :            32558799
/proc/3016/task/3016/sched:se.sleep_max             :            87667199
/proc/3016/task/3032/sched:se.sleep_max             :           430423009
/proc/3016/task/3031/sched:se.sleep_max             :          1206545563

'sleep_max' values mean voluntary (interruptible) sleeps - those are 
usually harmless and dont cause human-visible latencies. The 'dangerous' 
ones are the block_max (maximum uninterruptible sleep - such as disk IO, 
lock contention or swap activities) and wait_max (maximum time a task 
got on the CPU) values.

In the above list the largest wait_max was 32.5 msecs (all CFS units are 
in nanosecs), the largest block_max was 14.8 msecs - both are pretty OK.

(you can clear the stats and start the measurement anew by echo-ing 0 to 
the /proc 'sched' files - without having to exit the app.)

	Ingo
