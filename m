Return-Path: <linux-kernel-owner+w=401wt.eu-S1945951AbXDLJgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951AbXDLJgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945953AbXDLJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:36:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:56380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945951AbXDLJgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:36:09 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 11:36:02 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <20070411143357.e866b366.akpm@linux-foundation.org> <20070411173902.b2a9ab9d.akpm@linux-foundation.org>
In-Reply-To: <20070411173902.b2a9ab9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121136.03098.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, so I resurrected x86_64-mm-sched-clock-share.patch and
> x86_64-mm-sched-clock64.patch.  The x86_64 box hangs on boot when using
> netconsole and printk timestamps too.  Removing "time" from the kernel boot
> command line prevents that.

Ah. But ktime_get shouldn't printk. Or did you change that?

> 
> This explains why the hang only happens with
> x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch applied, too: that
> patch must be triggering a printk inside xtime_lock.
> 
> Does someone want to cook up a lockless printk_clock() for i386 and x86_64?

Just use jiffies directly in printk. That's only HZ accurate, but should
be good enough for printk.  

One could use pure monotonic xtime as fallback instead of ktime_get in sched_clock. 
The trouble is  just that they might cause sched_clock to go backwards during 
a temporary instability period (cpufreq change) because the xtime will be 
always a bit behind the TSC and a TSC->xtime conversion will lose time.
At least the scheduler doesn't handle backwards time warp on a CPU gratefully.
Ok I guess it could  return max(last_value_before_instability, xtime) 

-Andi


