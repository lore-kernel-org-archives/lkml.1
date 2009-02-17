Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZBQTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZBQTai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZBQTaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:30:23 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:44729 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752025AbZBQTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:30:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAGWemklMQWt2/2dsb2JhbACBbtIbhBMG
Date: Tue, 17 Feb 2009 14:30:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Viktor Rosendahl <Viktor.Rosendahl@nokia.com>
Cc: Russell King <rmk@arm.linux.org.uk>, ext Tony Lindgren <tony@atomide.com>,
       "Moiseichuk Leonid (Nokia-D/Helsinki)" <leonid.moiseichuk@nokia.com>,
       "Kallioinen Juha (Nokia-D/Helsinki)" <juha.kallioinen@nokia.com>,
       "Siamashka Siarhei (Nokia-D/Helsinki)" <siarhei.siamashka@nokia.com>,
       "Tamminen Eero (Nokia-D/Helsinki)" <eero.tamminen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] ARM fix syscall trace return value
Message-ID: <20090217193015.GB18353@Krystal>
References: <20090217181805.GA15788@Krystal> <1234898523.14675.18.camel@viktor.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1234898523.14675.18.camel@viktor.research.nokia.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:27:09 up 47 days, 19:25,  4 users,  load average: 0.82, 0.54,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Viktor Rosendahl (Viktor.Rosendahl@nokia.com) wrote:
> On Tue, 2009-02-17 at 19:18 +0100, ext Mathieu Desnoyers wrote: 
> > Hi Russell,
> > 
> > I am currently finding core bugs in the Linux kernel implementation of
> > the ARM architecture. :-( e.g. return value not being sent to the
> > syscall_trace function upon exit (upon which LTTng depends). (patch
> > below)
> > 
> > This is _very_ silly because there is no dependency on the syscall being
> > executed, and the syscall_entry/syscall_exit events are recorded at the
> > _exact_ same time. Yes, I mean the _exact_ same time : using a clock
> > which consists of atomic_add_return monotonic increments, it seems like
> > ARM is able to return the _same_ value of an atomic increment return
> > *twice* !! I think the atomic.h primitives are broken and that they
> > allow concurrent modification of a given atomic variable by the pipeline.
> > It sounds weird, and I hope I am not crazy (just getting into the ARM
> > world..). ;) Any thoughts ? I'll try adding some barriers to see if it
> > helps.
> 
> Hi Mathieu,
> 
> I am currently investigating a very similar behavior,
> (syscall_entry/syscall_exit events having the exact same time in lttng).
> 
> However, I am using the CCNT (together with trace-clock-32-to-64.c) for
> timestamping. This is, if I understand you correctly, a different clock
> than the one you are using, not using atomic_add_return(). Thus, I
> suspect that the reason for getting the exact same time for entry/exit
> events might be something else than the clocks being broken. 
> 
> I have to admit that I cannot explain how it can happen though. Could it
> be some weird problem in the lttng trace recording ?
> 

I had the same result as you with the ccnt-based clock I am currently
developing, so I went back to a more "solid" and atomic
atomic_add_return clock. But I noticed that we still had entry/exit with
the same timestamps, so I was really unsure about what was happening,
because there is no trace corruption and because I have never, ever,
seen that kind of problem on any other architecture (x86, powerpc,
mips...). So I fixed the syscall_trace exit parameter, which now makes
sure there is a dependency on the return value. But I want to find out
why the atomic add return failed to be atomic in that particular
condition. I suspect there is a missing memory barrier in atomic.h.

Mathieu

> best regards,
> 
> Viktor
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
