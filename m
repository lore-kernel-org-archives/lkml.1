Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZGRWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZGRWUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGRWU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 18:20:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43309 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbZGRWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 18:20:28 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Andi Kleen <ak@suse.de>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20090718120939.GC31007@elte.hu>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <20090718120939.GC31007@elte.hu>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 15:20:22 -0700
Message-Id: <1247955622.14494.28.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 14:09 +0200, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > Hey all,
> > 
> > 	After talking with some application writers who want very 
> > fast, but not fine-grained timestamps, I decided to try to 
> > implement a new clock_ids to clock_gettime(): 
> > CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE which returns the 
> > time at the last tick. This is very fast as we don't have to 
> > access any hardware (which can be very painful if you're using 
> > something like the acpi_pm clocksource), and we can even use the 
> > vdso clock_gettime() method to avoid the syscall. The only trade 
> > off is you only get low-res tick grained time resolution.
> > 
> > This isn't a new idea, I know Ingo pushed a patch (see commit 
> > 5899a0f044f3c80e9f7262ec5bc7164773a4c28e) a little while ago that 
> > made the vsyscall gettimeofday() return coarse grained time when 
> > the vsyscall64 sysctrl was set to 2. However this affects all 
> > applications on a system.
> 
> Note, that patch is an -rt commit, right? I.e. not yet upstream.

Oh yikes.. Somehow I cloned off of the wrong tree. Yes, you're right, I
was looking at the -rt git tree, your patch has not gone upstream yet.

My patch does still apply to mainline with offsets.


> > With this method, applications can choose the proper 
> > speed/granularity trade-off for themselves.
> > 
> > This is a first pass on this implementation, and while I did test 
> > it, the box I tested it with did not have a glibc new enough to 
> > utilize the vdso clock_gettime(), so there may still be issues 
> > there. I'll find a newer box for testing shortly.
> > 
> > Any thoughts or feedback will be appreciated!
> 
> Looks good. I think we should offer both methods: your patch as an 
> unconditional 'coarse time' approximator always available 
> everywhere, plus the vsyscall redirector as well from -rt, to allow 
> admins/users to tweak in a global way on apps that cannot be 
> changed.

I was thinking for users of apps that cannot be changed, an LD_PRELOAD
redirector that changed the clock_id to a _COARSE might be a little
cleaner then whole-sale forcing all of user-land to be low-res. But I'm
not terribly opinionated on it.

-john

