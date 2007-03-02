Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXCBVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXCBVMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXCBVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:12:29 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:1837 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965639AbXCBVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:12:29 -0500
X-ME-UUID: 20070302211226770.BBF9C5400086@mwinf1901.orange.fr
Message-ID: <45E89339.1050504@free.fr>
Date: Fri, 02 Mar 2007 22:12:25 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.21-rc2-mm1: what about CONFIG_NO_HZ and !CONFIG_SMP ?
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02.03.2007 12:00, Andrew Morton a écrit :
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/

Got this when CONFIG_NO_HZ=y and CONFIG_SMP=n:

  CC      kernel/sched.o
kernel/sched.c: In function 'trigger_load_balance':
kernel/sched.c:3384: error: 'struct rq' has no member named 'in_nohz_recently'
kernel/sched.c:3384: error: 'struct rq' has no member named 'idle_at_tick'
kernel/sched.c:3385: error: 'struct rq' has no member named 'in_nohz_recently'
kernel/sched.c:3387: error: 'nohz' undeclared (first use in this function)
kernel/sched.c:3387: error: (Each undeclared identifier is reported only once
kernel/sched.c:3387: error: for each function it appears in.)
kernel/sched.c:3404: warning: implicit declaration of function 'resched_cpu'
kernel/sched.c:3412: error: 'struct rq' has no member named 'idle_at_tick'
kernel/sched.c:3422: error: 'struct rq' has no member named 'idle_at_tick'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Looking at kernel/sched.c, it seems CONFIG_NO_HZ should depend on CONFIG_SMP...

 238 struct rq {
 239         spinlock_t lock;
 240 
 241         /*
 242          * nr_running and cpu_load should be in the same cacheline because
 243          * remote CPUs use both these fields when doing load calculation.
 244          */
 245         unsigned long nr_running;
 246         unsigned long raw_weighted_load;
 247 #ifdef CONFIG_SMP
 248         unsigned long cpu_load[3];
 249         unsigned char idle_at_tick;
 250 #ifdef CONFIG_NO_HZ
 251         unsigned char in_nohz_recently;
 252 #endif
 253 #endif
 254         unsigned long long nr_switches;

~~
laurent

