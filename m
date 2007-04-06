Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbXDFRez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbXDFRez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXDFRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:34:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933629AbXDFRey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:34:54 -0400
Date: Fri, 6 Apr 2007 19:34:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nathan Lynch <ntl@pobox.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070406173407.GB2517@elte.hu>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com> <20070406172714.GA6131@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406172714.GA6131@localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Lynch <ntl@pobox.com> wrote:

> > -	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
> > +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> > +		thaw_processes(FE_HOTPLUG_CPU);
> > +		return -EBUSY;
> > +	}
> > +
> 
> If I'm understanding correctly, this will cause
> 
> # echo 0 > /sys/devices/system/cpu/cpuX/online
> 
> to sometimes fail, and userspace is expected to try again?  This will 
> break existing applications.
> 
> Perhaps drivers/base/cpu.c:store_online should retry as long as 
> cpu_up/down return -EBUSY.  That would avoid a userspace-visible 
> interface change.

yeah. I'd even suggest a freeze_processes_nofail() API instead, that 
does this internally, without burdening the callsites. (and once the 
freezer becomes complete then freeze_processes_nofail() == 
freeze_processes())

	Ingo
