Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYJVLsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYJVLsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYJVLsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:48:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYJVLsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:48:24 -0400
Date: Wed, 22 Oct 2008 13:47:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: make dynamic ftrace more robust
Message-ID: <20081022114753.GC8095@elte.hu>
References: <20081021164018.889518687@goodmis.org> <20081021164302.399002797@goodmis.org> <20081022065346.GD17485@elte.hu> <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > i'd suggest to name it FTRACE_CODE_MODIFIED_OK here, to make it 
> > stand out from the failure codes.
> > 
> > > +	FTRACE_CODE_FAILED_READ,
> > > +	FTRACE_CODE_FAILED_CMP,
> > > +	FTRACE_CODE_FAILED_WRITE,
> > 
> > but maybe we should just use the standard kernel return codes. 0 for 
> > success, -EINVAL for the rest. Is there any real value to know 
> > exactly why it failed? We just know the modification was fishy (this 
> > is an exception situation), and want to stop ftrace ASAP and then 
> > print a warning so a kernel developer can debug it.
> 
> Yes it is important to know the reason of failure, since it helps with 
> diagnosing the issue.

we have everything we need: a warning message. We only add "reason 
debugging" _if and only if_ problems are so frequent in an area of code 
that it's absolutely needed. Otherwise we just fix the bugs, whenever 
they happen.

> > Complicating error handling by introducing similar-looking return 
> > code names just makes it easier to mess up accidentally, hence it 
> > _reduces_ robustness.
> 
> I had in mind for 2.6.29 that I would let an arch add another 
> non-error code that says, "FAIL NICELY". [...]

no ... you are really thinking about robustness in the wrong way.

This code runs in the deepest guts of the kernel and hence is playing 
with fire and it must be absolutely robust. Not 'nicely diagnosable', 
not 'fail nicely'. But utterly robust in stopping whatever it does early 
enough to make that problem reportable, should it trigger. (which it 
really should not)

> > >  /* Used for MEMORY_HOTPLUG */
> > > -#define __meminit        __section(.meminit.text) __cold
> > > +#define __meminit        __section(.meminit.text) __cold notrace
> > >  #define __meminitdata    __section(.meminit.data)
> > >  #define __meminitconst   __section(.meminit.rodata)
> > >  #define __memexit        __section(.memexit.text) __exitused __cold
> > 
> > there's no justification given for this in the changelog and the change 
> > looks fishy.
> 
> Sorry, I missed writing this. I had it in other patches, but forgot to 
> add the change log here. These are areas, just like the __init section 
> that I have no way ok finding out in an arch independent way, what to 
> remove from the ftrace records. So by not adding these notraces, we 
> are guaranteed to hit the warnings above!

this is utterly fragile and might miss places that insert symbols into 
some of these sections manually.

the robust approach is to make sure these things are never in an ftrace 
record to begin with. scripts/recordmcount.pl should be taught to only 
record places that it is _100% sure of is traceable_. Not "everything 
and we'll sort out the stuff that we think is not okay".

if that needs arch dependent smarts then so be it - ftrace has to be 
enabled per arch anyway.

	Ingo
