Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbZEATVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbZEATVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZEATVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:21:46 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:35750 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbZEATVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:21:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEABjj+klMQW1W/2dsb2JhbACBUM44g30F
Date: Fri, 1 May 2009 15:21:42 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090501192142.GA18339@Krystal>
References: <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905010939090.18324@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:13:15 up 62 days, 15:39,  2 users,  load average: 0.43, 0.63,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:
> 
> > By ZVC update, you mean Zone ... Counter update ? (which code exactly ?)
> 
> The code that you were modifying in vmstat.c.
> 
> > Hrm, I must admit I'm not sure I follow how your reasoning applies to my
> > code. I am using a percpu_add_return_irq() exactly for this reason : it
> > only ever touches the percpu variable once and atomically. The test for
> > overflow is done on the value returned by percpu_add_return_irq().
> 
> If the percpu differential goes over a certain boundary then the
> differential would be updated twice.
> 

Not with my approach which tests for == 0, as you point out below,

> > Therefore, an interrupt scenario that would be close to what I
> > understand from your concerns would be :
> >
> > * Thread A
> >
> > inc_zone_page_state()
> >   p_ret = percpu_add_return(p, 1); (let's suppose this increment
> >                                     overflows the threshold, therefore
> >                                     (p_ret & mask) == 0)
> >
> > ----> interrupt comes in, preempts the current thread, execution in a
> >       different thread context (* Thread B) :
> >
> >      inc_zone_page_state()
> >        p_ret = percpu_add_return(p, 1);  ((p_ret & mask) == 1)
> >        if (!(p_ret & mask))
> >          increment global zone count. (not executed)
> >
> > ----> interrupt comes in, preempts the current thread, execution back to
> >       the original thread context (Thread A), on the same or on a
> >       different CPU :
> >
> >   if (!(p_ret & mask))
> >     increment global zone count.   -----> will therefore increment the
> >                                           global zone count only after
> >                                           scheduling back the original
> >                                           thread.
> >
> > So I guess what you say here is that if Thread B is preempted for too
> > long, we will have to wait until it gets scheduled back before the
> > global count is incremented. Do we really need such degree of precision
> > for those counters ?
> >
> > (I fear I'm not understanding your concern fully though)
> 
> Inc_zone_page_state modifies the differential which is u8 and can easily
> overflow.
> 
> Hmmm. But if you check for overflow to zero this way it may work without
> the need for cmpxchg. But if you rely on overflow then we only update the
> global count after 256 counts on the percpu differential. The tuning of
> the accuracy of the counter wont work anymore. The global counter could
> become wildly inaccurate with a lot of processors.
> 

I see that we are getting on the same page here. Good :) About the
overflow :

What I do here is to let those u8 counters increment as free-running
counters. Yes, they will periodically overflow the 8 bits. But I don't
rely on this for counting the number of increments we need between
global counter updates : I use the bitmask taken from the threshold
value (which is now required to be a power of two) to detect 0, 1, 2, 3,
4, 5, 6 or 7-bit counter overflow. Therefore we can still have the kind
of granularity currently provided. The only limitation is that we have
to use powers of two for the threshold, so we end up counting in power
of two modulo, which will be unaffected by the u8 overflow.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
