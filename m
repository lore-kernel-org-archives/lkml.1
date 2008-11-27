Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYK0Lhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYK0Lhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYK0Lhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:37:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42194
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYK0Lhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:37:42 -0500
Date: Thu, 27 Nov 2008 03:37:42 -0800 (PST)
Message-Id: <20081127.033742.175440395.davem@davemloft.net>
To: tglx@linutronix.de
Cc: eranian@gmail.com, sfr@canb.auug.org.au, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811271132290.3325@localhost.localdomain>
References: <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain>
	<7c86c4470811270151i33ffaa44mb5d9bd79f9d73968@mail.gmail.com>
	<alpine.LFD.2.00.0811271132290.3325@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Nov 2008 11:56:24 +0100 (CET)

> Stephane,
> 
> On Thu, 27 Nov 2008, stephane eranian wrote:
> > > Why do you want to do u64 -> u32 BE32 magic on every interrupt,
> > > context switch etc., if you can do it once in the userspace interface ?
> > >
> > I think we agree as to why the user visible structures have to have fixed size.
> > 
> > Some structures have bitfields in them (no in the current patchset yet).
> > Here is an example:
> > 
> > #define PFM_PMD_BV   (256/sizeof(__u64))
> > 
> > struct pfarg_pmd_attr {
> >         __u16 reg_num;          /* which register */
> >         __u16 reg_set;          /* which event set */
> >         __u32 reg_flags;        /* REGFL flags */
> >         __u64 reg_value;        /* 64-bit value */
> >         __u64 reg_long_reset;   /* write: value to reload after notification */
> >         __u64 reg_short_reset;  /* write: reset after counter overflow */
> >         __u64 reg_random_mask;  /* write: bitmask used to limit random value */
> >         __u64 reg_smpl_pmds[PFM_PMD_BV];  /* write: record in sample */
> >         __u64 reg_reset_pmds[PFM_PMD_BV]; /* write: reset on overflow */
> >         __u64 reg_ovfl_swcnt;   /* write: # of overflows before switch */
> >         __u64 reg_smpl_eventid; /* write: opaque event identifier */
> >         __u64 reg_last_value;   /* read : return: PMD last reset value */
> >         __u64 reg_reserved[8];  /* for future use */
> > };
> 
>   __attribute__ ((packed)); ???

Shouldn't be needed and this woule kill performance on RISC (every
struct member is accessed with byte sized loads and shifts/masking).

We did this for the pfkey.h structures by accident, and I truly regret
it.
