Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXGKE50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXGKE50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXGKE5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:57:19 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:42574 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbXGKE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:57:18 -0400
Date: Wed, 11 Jul 2007 00:57:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070711045715.GB4025@Krystal>
References: <20070705215152.GA4865@Krystal> <p73myy9215m.fsf@bingen.suse.de> <20070706144144.GC32754@Krystal> <20070706171159.GB8174@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070706171159.GB8174@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:51:18 up 3 days, 18:56,  3 users,  load average: 0.20, 0.30, 0.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, Jul 06, 2007 at 10:41:44AM -0400, Mathieu Desnoyers wrote:
> > I haven't thought about making it the default for kernel space
> > preemption, but yes, it would make sense.
> 
> Now it's too late -- getcpu() has infected the kernel everywhere.
> It would have made sense a few years ago.
> 
> 
> > ... getcpu()...
> 
> Hmm ok, although i suspect it's rare to assume that. But understood
> you don't want to audit all getcpu users because of this.
> 
> > using a short instead of an int on modern x86 will cause pipeline stalls
> > due to partial register use.
> 
> Sorry, that's totally bogus. Primarily because the access would be directly
> on memory and there is no partial register tracking there.
> 
> Besides pipeline stall is not the correct description on what would
> happen if you used a register, the worst you get is a single false dependency
> but no pipeline flush.
> 
> Besides the latest x86 cpus (C2, K8) don't have much trouble with these
> false dependencies in general.
> 

Yes, false dependency is what I meant. And hrm, yeah I guess that mostly
movzbl would be used to get the byte from memory and zero-extend, making
sure there is no false dependency.

> > usage, since it is followed by an unsigned long; gcc structure alignment
> 
> 
> > will put padding instead of the integer, which does not buy us anything
> 
> on i386 unsigned long is 4 bytes.
> 

Since we have, on i386:

        int                     preempt_count;  /* 0 => preemptable, <0 => BUG */
        int                     migrate_count;/* 0: can migrate, <0: BUG */
        mm_segment_t            addr_limit;     /* thread address space:

and:

typedef struct {
        unsigned long seg;
} mm_segment_t;

Turning migrate_count into a char would only put padding between
migrate_count and addr_limit. So I still do not see a clear improvement
in memory usage there... but I don't specially care about it being an
integer or a byte though :)

Mathieu


> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
