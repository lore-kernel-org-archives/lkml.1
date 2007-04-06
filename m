Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXDFWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXDFWWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXDFWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:22:37 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41163 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXDFWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:22:36 -0400
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Nathan Lynch <ntl@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20070406174704.GC6131@localdomain>
References: <20070402053457.GA9076@in.ibm.com>
	 <20070402053824.GC12962@in.ibm.com> <20070406172714.GA6131@localdomain>
	 <20070406173407.GB2517@elte.hu>  <20070406174704.GC6131@localdomain>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 08:22:35 +1000
Message-Id: <1175898155.6481.85.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-04-06 at 12:47 -0500, Nathan Lynch wrote:
> Ingo Molnar wrote:
> > 
> > * Nathan Lynch <ntl@pobox.com> wrote:
> > 
> > > > -	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
> > > > +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> > > > +		thaw_processes(FE_HOTPLUG_CPU);
> > > > +		return -EBUSY;
> > > > +	}
> > > > +
> > > 
> > > If I'm understanding correctly, this will cause
> > > 
> > > # echo 0 > /sys/devices/system/cpu/cpuX/online
> > > 
> > > to sometimes fail, and userspace is expected to try again?  This will 
> > > break existing applications.
> > > 
> > > Perhaps drivers/base/cpu.c:store_online should retry as long as 
> > > cpu_up/down return -EBUSY.  That would avoid a userspace-visible 
> > > interface change.
> > 
> > yeah. I'd even suggest a freeze_processes_nofail() API instead, that 
> > does this internally, without burdening the callsites. (and once the 
> > freezer becomes complete then freeze_processes_nofail() == 
> > freeze_processes())
> 
> Yeah, I just realized that an implementation of my proposal would busy
> loop in the kernel forever if a silly admin tried to offline the last
> cpu (we're already using -EBUSY for that case), so
> freeze_processes_nofail is a better idea :-)

If there's only one online cpu, shouldn't it return -EINVAL?

Regards,

Nigel

