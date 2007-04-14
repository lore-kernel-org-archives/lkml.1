Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXDOJhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXDOJhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXDOJhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:37:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1077 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752801AbXDOJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:37:15 -0400
Date: Sat, 14 Apr 2007 18:48:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nathan Lynch <ntl@pobox.com>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070414184830.GA10097@ucw.cz>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com> <20070406172714.GA6131@localdomain> <20070406173407.GB2517@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406173407.GB2517@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
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

Not sure if we _can_ do freeze_processes_nofail(). If something is
wrong (process in D state forever because of driver bug?), it looks
better to return error to userspace than looping forever.

You may want to pass higher timeout than 20sec. But if you can't
freeze everything in 1hour, it is unlikely to ever succeed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
