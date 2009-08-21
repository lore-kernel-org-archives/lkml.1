Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZHUGXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZHUGXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZHUGXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:23:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41178 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZHUGXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:23:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Aug 2009 15:21:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
 batch values for stats counters
Message-Id: <20090821152159.12c8529d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090820062451.GH21100@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	<20090512102939.GB11714@elte.hu>
	<20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20090820052605.GC26265@balbir.in.ibm.com>
	<1250747579.8282.110.camel@twins>
	<20090820060528.GG21100@kryten>
	<20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090820062451.GH21100@kryten>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 16:24:51 +1000
Anton Blanchard <anton@samba.org> wrote:

>  
> Hi,
> 
> > Could you share contex-switch-test program ?
> > I'd like to play with it to find out what I can do against percpu counter.
> 
> Sure:
> 
> http://ozlabs.org/~anton/junkcode/context_switch.c
> 
> Very simple, just run it once per core:
> 
> for i in `seq 0 31`
> do
> 	taskset -c $i ./context_switch &
> done
> 
> Then look at the context switch rates in vmstat.
> 

Ok, I reproduced it on ia64 box (ia64 supports VIRT_CPU_ACCOUNTING)

On 8cpu
-- config=on--
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
11  0      0 7185152  66048 284416    0    0     0     0 5918 12354  0 100  0  0  0
--config=off--
11  0      0 7194496  66304 283392    0    0     0    20 8023 1424022 32 68  0  0  0

Wow, yes. 100x regression.

I'll dig this more. 

IIUC, If CONFIG_VIRT_CPU_ACCOUNTING=on, process's stime/utime records "nanosecond".
Then, batch=32 is too small. How about once per msec ?

Thanks,
-Kame

