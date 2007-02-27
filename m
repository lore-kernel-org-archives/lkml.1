Return-Path: <linux-kernel-owner+w=401wt.eu-S1751377AbXB0Ewi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbXB0Ewi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXB0Ewi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:52:38 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:39061 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXB0Ewh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:52:37 -0500
Date: Mon, 26 Feb 2007 23:47:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       mingo@elte.hu
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227044724.GB17546@Krystal>
References: <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com> <20070227035456.GA15444@Krystal> <1172550161.5517.210.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1172550161.5517.210.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 23:40:19 up 24 days, 18:48,  3 users,  load average: 1.18, 1.11, 1.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Mon, 2007-02-26 at 22:54 -0500, Mathieu Desnoyers wrote:
> > If an NMI nests over the spinlock, we have a deadlock.
> 
> Maybe not completely safe ...
> 
> > In addition, clock->cycle_last is a cycle_t, defined as a 64 bits on
> > x86. If is therefore not updated atomically by change_clocksource,
> > timekeeping_init, timekeeping_resume and update_wall_time. If an NMI
> > fires right on top of the update, especially around the 32 bits wrap
> > around, the time will be really fuzzy.
> 
> I'm not sure that is particularly significant considering that it's just
> a possible bad timestamp, and the probability of that happening seems
> rather low .. You could also modify NMI calls so they use a different
> time stamping method, like reading the clocksource directly .
> 

Since you do not disable interrupts around the clocksource read, the
same problem applies to interrupt handlers of higher priority than the
cycle_last updating code.

A bad timestamp can make a trace quite hard to follow and more
error-prone. When someone is looking for _the_ failing case in a system,
the infrastructure used to debug must be reliable. Sometimes error cases
takes days before showing up : we can't afford to be unsure about the
precision of the tracer.

Also, the goal is to have a generic monotonic timestamp readable from
everywhere. Excluding execution contexts doesn't seem like such a great
idea (it just replicates the same problem somewhere else).

> The pit clocksource could be dropped pretty easy with my clocksource
> update patches, which I'm still working on but you could easily drop
> clock sources that aren't atomic like the pit .. Also the pit is
> generally undesirable, so it's not going to be missed.
> 

Still important for old architectures where PIT is the only available
clock source I guess. However, the clocksource struct should at least 
tell if the time can be read atomically and offer a different API for
atomic vs non atomic read of time source, returning an error if no
atomic time source is available.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
