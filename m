Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZIJXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZIJXOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZIJXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:32854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZIJXON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:14:13 -0400
Date: Fri, 11 Sep 2009 01:14:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] x86: increase MIN_GAP to include randomized stack
In-Reply-To: <alpine.LNX.2.00.0909081107580.23856@wotan.suse.de>
Message-ID: <alpine.LNX.2.00.0909110112470.23856@wotan.suse.de>
References: <20090908085328.GD22397@tiehlicka.suse.cz> <1252400515-6866-1-git-send-email-mhocko@suse.cz> <alpine.LNX.2.00.0909081107580.23856@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Jiri Kosina wrote:

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
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Ingo, could you please consider applying this?

Any comments about this patch please? (aka. "ping") :)

> > ---
> >  arch/x86/include/asm/elf.h |    2 ++
> >  arch/x86/mm/mmap.c         |   17 +++++++++++++++--
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> > index 83c1bc8..456a304 100644
> > --- a/arch/x86/include/asm/elf.h
> > +++ b/arch/x86/include/asm/elf.h
> > @@ -299,6 +299,8 @@ do {									\
> >  
> >  #ifdef CONFIG_X86_32
> >  
> > +#define STACK_RND_MASK (0x7ff)
> > +
> >  #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
> >  
> >  #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 1658296..c8191de 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -29,13 +29,26 @@
> >  #include <linux/random.h>
> >  #include <linux/limits.h>
> >  #include <linux/sched.h>
> > +#include <asm/elf.h>
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
> >  
> >  /*
> >   * Top of mmap area (just below the process stack).
> >   *
> > - * Leave an at least ~128 MB hole.
> > + * Leave an at least ~128 MB hole with possible stack randomization.
> >   */
> > -#define MIN_GAP (128*1024*1024)
> > +#define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
> >  #define MAX_GAP (TASK_SIZE/6*5)
> >  
> >  /*
> > -- 
> > 1.6.3.3
> > 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
