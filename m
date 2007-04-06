Return-Path: <linux-kernel-owner+w=401wt.eu-S2992894AbXDFRrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992894AbXDFRrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992908AbXDFRrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:47:18 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:59439 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992894AbXDFRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:47:17 -0400
Date: Fri, 6 Apr 2007 12:47:04 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070406174704.GC6131@localdomain>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com> <20070406172714.GA6131@localdomain> <20070406173407.GB2517@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406173407.GB2517@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Nathan Lynch <ntl@pobox.com> wrote:
> 
> > > -	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
> > > +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> > > +		thaw_processes(FE_HOTPLUG_CPU);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > 
> > If I'm understanding correctly, this will cause
> > 
> > # echo 0 > /sys/devices/system/cpu/cpuX/online
> > 
> > to sometimes fail, and userspace is expected to try again?  This will 
> > break existing applications.
> > 
> > Perhaps drivers/base/cpu.c:store_online should retry as long as 
> > cpu_up/down return -EBUSY.  That would avoid a userspace-visible 
> > interface change.
> 
> yeah. I'd even suggest a freeze_processes_nofail() API instead, that 
> does this internally, without burdening the callsites. (and once the 
> freezer becomes complete then freeze_processes_nofail() == 
> freeze_processes())

Yeah, I just realized that an implementation of my proposal would busy
loop in the kernel forever if a silly admin tried to offline the last
cpu (we're already using -EBUSY for that case), so
freeze_processes_nofail is a better idea :-)

