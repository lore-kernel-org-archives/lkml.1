Return-Path: <linux-kernel-owner+w=401wt.eu-S933363AbZDJJV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbZDJJV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZDJJVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:21:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbZDJJVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:21:15 -0400
Date: Fri, 10 Apr 2009 11:19:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       hch@infradead.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 09/30] x86_64: ifdef out struct thread_struct::ip
Message-ID: <20090410091931.GF17962@elte.hu>
References: <20090410023522.GJ27788@x200.localdomain> <20090410035328.GB29496@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410035328.GB29496@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Helsley <matthltc@us.ibm.com> wrote:

> On Fri, Apr 10, 2009 at 06:35:22AM +0400, Alexey Dobriyan wrote:
> > struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
> > instead. 
> > 
> > kgdb should be reading 0, but I can't check it.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  arch/x86/include/asm/processor.h |    2 ++
> >  arch/x86/kernel/kgdb.c           |    2 +-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -421,7 +421,9 @@ struct thread_struct {
> >  	unsigned short		fsindex;
> >  	unsigned short		gsindex;
> >  #endif
> > +#ifdef CONFIG_X86_32
> >  	unsigned long		ip;
> > +#endif
> >  #ifdef CONFIG_X86_64
> >  	unsigned long		fs;
> >  #endif
> 
> Do these make struct thread_struct behave better in cachelines 
> (smaller, less aliasing)? Can we really fit more in the slab du 
> jour?
> 
> Otherwise it seems like we're littering these structs with #ifdefs 
> and not really saving anything. [...]

Removing fields always saves memory (even if it does not show up 
currently due to allocators cache-aligning sizes).

But the #ifdef ugliness is a real worry.

> [...] If these #ifdefs don't save any 
> space why not just put in a comment:
> 
> >  	unsigned long		ip; /* Used only on i386 */

Yes.

> Or maybe even:
> 
> 	union {
> 	  	unsigned long		ip; /* Used only on i386 */
> 	  	unsigned long		fs; /* Used only on x86_64 */
> 	};

Maybe. If this ever gets misunderstood somewhere in platform code we 
will get ugly failure modes and zero compiler help.

	Ingo
