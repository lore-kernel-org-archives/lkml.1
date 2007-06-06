Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXFFK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXFFK0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbXFFK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:26:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:35787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302AbXFFK0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:26:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
Date: Wed, 6 Jun 2007 12:26:10 +0200
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       virtualization@lists.osdl.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, lkml <linux-kernel@vger.kernel.org>,
       Jiri Bohac <jbohac@suse.cz>
References: <20070522140941.802382212@goop.org> <46668EC6.76E4.0078.0@novell.com> <466686E2.4040004@goop.org>
In-Reply-To: <466686E2.4040004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061226.11326.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 12:05:22 Jeremy Fitzhardinge wrote:
> Jan Beulich wrote:
> > Xen itself knows to deal with this (by using an error correction factor to
> > slow down the local [TSC-based] clock), but for the kernel such a situation
> > may be fatal: If clocksource->cycle_last was most recently set on a CPU
> > with shadow->tsc_to_nsec_mul sufficiently different from that where
> > getnstimeofday() is being used, timekeeping.c's __get_nsec_offset() will
> > calculate a huge nanosecond value (due to cyc2ns() doing unsigned
> > operations), worth abut 4000s. This value may then be used to set a
> > timeout that was intended to be a few milliseconds, effectively yielding
> > a hung app (and perhaps system).
> >   
> 
> Hm.  I had a similar situation in the stolen time code, and I ended up
> using signed values so I could clamp at zero.  Though that might have
> been another bug; either way, the clamp is still there.
> 
> I wonder if cyc2ns might not be better using signed operations?  Or
> perhaps better, the time code should endevour to do things on a
> completely per-cpu basis (haven't really given this any thought).

This is being worked on.


> > Unfortunately so far I haven't been able to think of a reasonable solution
> > to this - a simplistic approach like making xen_clocksource_read() check
> > the value it is about to return against the last value it returned doesn't
> > seem to be a good idea (time might appear to have stopped over some
> > period of time otherwise), nor does attempting to adjust the shadowed
> > tsc_to_nsec_mul values (because the kernel can't know whether it should
> > boost the lagging CPU or throttle the rushing one).
> 
> I once had some code in there to do that, implemented in very boneheaded
> way with a spinlock to protect the "last time returned" variable.  I
> expect there's a better way to implement it.

But any per CPU setup likely needs this to avoid non monotonicity 

-Andi
 
