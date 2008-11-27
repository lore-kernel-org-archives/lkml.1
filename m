Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYK0K7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYK0K7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYK0K55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:57:57 -0500
Received: from www.tglx.de ([62.245.132.106]:60143 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624AbYK0K5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:57:55 -0500
Date: Thu, 27 Nov 2008 11:56:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <7c86c4470811270151i33ffaa44mb5d9bd79f9d73968@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811271132290.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>  <20081126113309.GS6703@one.firstfloor.org>  <20081126230529.ab37fb32.sfr@canb.auug.org.au>  <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>  <7c86c4470811260556l3b161f1fx639d7ee02285a93@mail.gmail.com>
  <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain> <7c86c4470811270151i33ffaa44mb5d9bd79f9d73968@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Thu, 27 Nov 2008, stephane eranian wrote:
> > Why do you want to do u64 -> u32 BE32 magic on every interrupt,
> > context switch etc., if you can do it once in the userspace interface ?
> >
> I think we agree as to why the user visible structures have to have fixed size.
> 
> Some structures have bitfields in them (no in the current patchset yet).
> Here is an example:
> 
> #define PFM_PMD_BV   (256/sizeof(__u64))
> 
> struct pfarg_pmd_attr {
>         __u16 reg_num;          /* which register */
>         __u16 reg_set;          /* which event set */
>         __u32 reg_flags;        /* REGFL flags */
>         __u64 reg_value;        /* 64-bit value */
>         __u64 reg_long_reset;   /* write: value to reload after notification */
>         __u64 reg_short_reset;  /* write: reset after counter overflow */
>         __u64 reg_random_mask;  /* write: bitmask used to limit random value */
>         __u64 reg_smpl_pmds[PFM_PMD_BV];  /* write: record in sample */
>         __u64 reg_reset_pmds[PFM_PMD_BV]; /* write: reset on overflow */
>         __u64 reg_ovfl_swcnt;   /* write: # of overflows before switch */
>         __u64 reg_smpl_eventid; /* write: opaque event identifier */
>         __u64 reg_last_value;   /* read : return: PMD last reset value */
>         __u64 reg_reserved[8];  /* for future use */
> };

  __attribute__ ((packed)); ???
 
> So you are advocating keeping that layout for the user level code,
> i.e., the user level perfmon.h.
> But then, in the kernel, you'd have a different version of the same
> structure with the same name
> and the size but with the bitmask defined as unsigned long instead.
> All internal only bitmask
> would also be unsigned long. So the structure would like as follows:
> 
> #define PFM_PMD_BV  (256/sizeof(unsigned long))
> struct pfarg_pmd_attr {
>         __u16 reg_num;          /* which register */
>         __u16 reg_set;          /* which event set */
>         __u32 reg_flags;        /* REGFL flags */
>         __u64 reg_value;        /* 64-bit value */
>         __u64 reg_long_reset;   /* write: value to reload after notification */
>         __u64 reg_short_reset;  /* write: reset after counter overflow */
>         __u64 reg_random_mask;  /* write: bitmask used to limit random value */
>         unsigned long reg_smpl_pmds[PFM_PMD_BV];  /* write: record in sample */
>         unsigned long reg_reset_pmds[PFM_PMD_BV]; /* write: reset on overflow */
>         __u64 reg_ovfl_swcnt;   /* write: # of overflows before switch */
>         __u64 reg_smpl_eventid; /* write: opaque event identifier */
>         __u64 reg_last_value;   /* read : return: PMD last reset value */
>         __u64 reg_reserved[8];  /* for future use */
> };
> 
> Then we could not directly export include/linux/perfmon.h to user
> via Kbuild.

I really can not see the problem.

1) perfmon.h can have a section for kernel and user space. We have
tons of examples of this in the kernel already.

The user space data structures are separate, simply because they are
an user space ABI and can not be changed.

Kernel data structures can be completely different from the user ABI
and can be changed at any given time as the code evolves. The design
you are proposing is tying the in kernel data structures to the user
ABI forever.

I can see that it might be good performance wise if you dont have to
touch stuff twice, but reshuffling the bitmasks should not be that
expensive.

2) You can have an union of

   union {
   	 __u64 bla[N];
	 unsigned long blub[M];
   };

   Where M = N for 64 bit and M = 2 * N for 32 bit.

FYI, I talked to Paulus about that and he thinks that doing the PPC
BE32 bitops for u64 are pretty cheap, but we agreed that this is
neither a perfmon nor an arch feature and has to be done as generic as
possible similar to the atomic64 ops. That way we have just two
implementations (generic and BE32) and not 10 copies of the same
wrappers around ulong bitops all over the place. 

Also test_bit_64() is definitely more acceptable and more useful than
pfm_arch_bv_test_bit().

Thanks,

	tglx
