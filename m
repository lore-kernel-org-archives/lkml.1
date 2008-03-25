Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYCYQOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYCYQOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYCYQOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:14:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39862 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYCYQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:14:03 -0400
Subject: Re: Scalability requirements for sysv ipc
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1206460206.4414.21.camel@marge.simson.net>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>
	 <1206460206.4414.21.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 17:13:50 +0100
Message-Id: <1206461630.8514.441.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 16:50 +0100, Mike Galbraith wrote:
> On Sat, 2008-03-22 at 20:08 +0100, Manfred Spraul wrote:
> 
> > just the normal performance of 2.6.25-rc3 is abyssimal, 55 to 60% slower 
> > than 2.6.18.8:
> 
> After manually reverting 3e148c79938aa39035669c1cfa3ff60722134535,
> 2.6.25.git scaled linearly, but as you noted, markedly down from earlier
> kernels with this benchmark.  2.6.24.4 with same revert, but all
> 2.6.25.git ipc changes piled on top still performed close to 2.6.22, so
> I went looking.  Bisection led me to..
> 
> 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
> 
>     sched: high-res preemption tick
> 
>     Use HR-timers (when available) to deliver an accurate preemption tick.
> 
>     The regular scheduler tick that runs at 1/HZ can be too coarse when nice
>     level are used. The fairness system will still keep the cpu utilisation 'fair'
>     by then delaying the task that got an excessive amount of CPU time but try to
>     minimize this by delivering preemption points spot-on.
> 
>     The average frequency of this extra interrupt is sched_latency / nr_latency.
>     Which need not be higher than 1/HZ, its just that the distribution within the
>     sched_latency period is important.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1 f1742e1d225a72aecea9d6961ed989b5943d31d8 M     arch
> :040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe ae61510186b4fad708ef0211ac169decba16d4e5 M     include
> :040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26 950832cc1dc4d30923f593ecec883a06b45d62e9 M     kernel
> 
> ...and I verified it via :-/ echo 7 > sched_features in latest.  That
> only bought me roughly half though, so there's a part three in there
> somewhere.

Ouch, I guess hrtimers are just way expensive on some hardware... 

