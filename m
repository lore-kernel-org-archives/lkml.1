Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZIHHcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZIHHcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZIHHcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:32:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:54536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZIHHca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:32:30 -0400
Date: Tue, 8 Sep 2009 09:32:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] x86: increase MIN_GAP to include randomized stack
Message-ID: <20090908073230.GB22397@tiehlicka.suse.cz>
References: <1252057020-5207-1-git-send-email-mhocko@suse.cz>
 <alpine.LNX.2.00.0909071717130.23856@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909071717130.23856@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-09-09 17:18:44, Jiri Kosina wrote:
> On Fri, 4 Sep 2009, Michal Hocko wrote:
> 
> > Currently we are not including randomized stack size when calculating
> > mmap_base address in arch_pick_mmap_layout for topdown case. This might
> > cause that mmap_base starts in the stack reserved area because stack is
> > randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.
> > 
> > If the stack really grows down to mmap_base then we can get silent mmap
> > region overwrite by the stack values.
> > 
> > Let's include maximum stack randomization size into MIN_GAP which is
> > used as the low bound for the gap in mmap.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  arch/x86/mm/mmap.c |   21 +++++++++++++++++++--
> >  1 files changed, 19 insertions(+), 2 deletions(-)
> > 
> > I wasn't sure about STACK_RND_MASK because it is defined also in 
> > arch/x86/include/asm/elf.h and I couldn't find a common header file for 
> > both of them. If you have any idea I would like to help with that.
> > Or should we just let it for later cleanup?
> 
> What will break if we include <asm/elf.h> from mmap.c?

I have tried that and as far as compilation went it was OK... Except for
one thing which I haven't noticed before as well. STACK_RND_MASK is not
defined outside of CONFIG_X86_64 (in <arch/elf.h>).

One possible way to fix this is to update the original patch with:

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index ac41955..a4566a8 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -32,7 +32,11 @@
 
 /* 1GB for 64bit, 8MB for 32bit definition taken from arch/x86/include/asm/elf.h */
 #ifndef STACK_RND_MASK
+#ifdef CONFIG_X86_64
 #define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
+#else
+#define STACK_RND_MASK (0x7ff)
+#endif
 #endif
 
 static unsigned int stack_maxrandom_size(void)

This, however, doesn't look very nice. If there is no objection I would
define STACK_RND_MASK in <arch/elf.h> also out of CONFIG_X86_64 and
remove this definition from mmap.c completely. What do you think?

> 
> > I think that this is also stable material and I will repost it to 
> > stable@kernel.org once you ack it.
> > 
> > Changes from v1:
> > Fixed unsigned int overflow in MIN_GAP calculation.
> > 
> > 
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 1658296..ac41955 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -30,12 +30,29 @@
> >  #include <linux/limits.h>
> >  #include <linux/sched.h>
> >  
> > +/* 1GB for 64bit, 8MB for 32bit definition taken from arch/x86/include/asm/elf.h */
> > +#ifndef STACK_RND_MASK
> > +#define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
> > +#endif
> > +
> > +static unsigned int stack_maxrandom_size(void)
> > +{
> > +	unsigned int max = 0;
> > +	if ((current->flags & PF_RANDOMIZE) &&
> > +		!(current->personality & ADDR_NO_RANDOMIZE)) {
> > +		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
> > +	}
> > +
> > +	return max;
> > +}
> > +
> > +
> >  /*
> >   * Top of mmap area (just below the process stack).
> >   *
> > - * Leave an at least ~128 MB hole.
> > + * Leave an at least ~128 MB hole with possible stack randomization.
> >   */
> > -#define MIN_GAP (128*1024*1024)
> > +#define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
> >  #define MAX_GAP (TASK_SIZE/6*5)
> 
> Apart from doubling the STACK_RND_MASK definition
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
