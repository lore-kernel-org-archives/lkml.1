Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZKMK6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZKMK6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZKMK6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:58:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZKMK63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:58:29 -0500
Date: Fri, 13 Nov 2009 11:57:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091113105736.GA21904@elte.hu>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
 <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com>
 <20091113095350.GC1364@elte.hu>
 <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com>
 <20091113101326.GA17451@elte.hu>
 <alpine.DEB.2.00.0911130222080.21963@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911130222080.21963@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Fri, 13 Nov 2009, Ingo Molnar wrote:
> 
> > There's two problems outlined in this discussion:
> > 
> >  A) too verbose bootup that is annoying with 64 CPUs and a show-stopper
> >     with 4096 CPUs.
> > 
> >  B) the ad-hoc nature of our topology enumeration. Some of it is in
> >     /sys, some of it is in printk logs. None really works well and 
> >     there's no structure in it.
> > 
> > The simplest solution for (A) is what i suggested a few mails ago: dont 
> > print the information by default, but allow (for trouble-shooting) 
> > purposes for it to be printed when a boot option is passed.
> > 
> 
> Sigh, and even if that were done with a subsequent patch, you would 
> still want to reduce the debugging output from 1272 lines to 40, just 
> like my patch does without losing any information.  It's insane to 
> emit 1272 lines even if they are emitted only for a certain kernel 
> parameter.  I'm sure we agree on that.

For _debug_ output, we want it pretty simple. 1272 lines is nothing if 
it's only done for debugging/trouble-shooting.

Furthermore, if this _only_ gets used in the debug case, we want it 
simple for the pure reason that it's uncommon code. It might work now, 
but it might regress later without anyone noticing it - up to the point 
when someone might need it when it breaks in the worst possible moment.

We've been through this many times before and that's the core principle 
of all debug printout code: keep it simple.

> > Problem (B), topology info enumeration of a successful bootup is a 
> > different matter. It should be exposed to user-space via proper /sys 
> > abstractions, not via ad-hoc printks. There's ongoing work in that 
> > area, from Andreas Hermann, with patches posted. hpa expressed the 
> > view there that topology structure should be expressed via a nice 
> > vfs abstraction - i share that opinion.
> 
> Ingo, what do you want?

My goal is to accept good patches and to reject patches that are bad or 
not good enough.

> Your first criticism was that it should be limited only to a kernel 
> parameter but now it seems like you're insisting that the printk's get 
> removed completely and its exported via userspace.  Then what is the 
> kernel parameter that you suggested for?

Please read my mail. There's three usecases:

  - default bootup. We want no messages in the log.

  - troubleshooting bootup with a boot flag specified. (an existing
    example is apic=verbose) We want simple messages in that case and 
    obvious logic. (verbosity is not an overriding issue - we are 
    troubleshooting)

  - Successful bootup and we want to retrieve topology information for 
    the system. Using the boot logs for it is not the right channel - 
    /sys is.

Your patch is not a 'good enough' solution to either of these usecases, 
because:

  - In the default case it prints 40 lines more than it should.

  - In the troubleshooting case it provides the information but it is
    not a simple mechanism. (anything with state and a bitmap in it is 
    out pretty much - stick to simple printks, those are in the least 
    danger of regressing down the road. It's also less bloated in terms 
    of code. )

  - For extracing topology information kernel log messages is not 
    something that tools can rely on very well.

Thanks,

	Ingo
