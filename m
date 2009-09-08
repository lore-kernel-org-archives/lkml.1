Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZIHIx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZIHIx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZIHIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:53:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:56895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZIHIx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:53:28 -0400
Date: Tue, 8 Sep 2009 10:53:28 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] x86: increase MIN_GAP to include randomized stack
Message-ID: <20090908085328.GD22397@tiehlicka.suse.cz>
References: <20090908073230.GB22397@tiehlicka.suse.cz>
 <1252399437-1852-1-git-send-email-mhocko@suse.cz>
 <alpine.LNX.2.00.0909081046130.23856@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909081046130.23856@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 08-09-09 10:47:46, Jiri Kosina wrote:
> On Tue, 8 Sep 2009, Michal Hocko wrote:
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
> >  arch/x86/mm/mmap.c |   25 +++++++++++++++++++++++--
> >  1 files changed, 23 insertions(+), 2 deletions(-)
> > 
> > I think that this is also stable material and I will repost it to 
> > stable@kernel.org once you ack it.
> > 
> > Changes from v2:
> > STACK_RND_MASK has to be defined for CONFIG_X86_32 as well.
> > 
> > Changes from v1:
> > Fixed unsigned int overflow in MIN_GAP calculation.
> > 
> > 
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 1658296..a4566a8 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -30,12 +30,33 @@
> >  #include <linux/limits.h>
> >  #include <linux/sched.h>
> >  
> > +/* 1GB for 64bit, 8MB for 32bit definition taken from arch/x86/include/asm/elf.h */
> > +#ifndef STACK_RND_MASK
> > +#ifdef CONFIG_X86_64
> > +#define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
> > +#else
> > +#define STACK_RND_MASK (0x7ff)
> > +#endif
> > +#endif
> 
> I'd still prefer all this macro-magic happening in <asm/elf.h> and 
> including this file from arch/x86/mm/mmap.c, otherwise we are duplicating 
> the STACK_RND_MASK definition, which is messy.

I definitely agree. I just wanted to post the complete patch for
reference. The elf variant will follow.

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
