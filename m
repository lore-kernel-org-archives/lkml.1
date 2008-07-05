Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYGEGcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYGEGcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYGEGcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:32:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbYGEGce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:32:34 -0400
Date: Fri, 4 Jul 2008 23:32:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-Id: <20080704233205.5cf6f04b.akpm@linux-foundation.org>
In-Reply-To: <20080705071401.0fe75d9f@linux360.ro>
References: <20080623153104.50549291@linux360.ro>
	<20080702230636.66e484bb.akpm@linux-foundation.org>
	<20080705071401.0fe75d9f@linux360.ro>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 07:14:01 +0300 Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Wed, 2 Jul 2008 23:06:36 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>  
> > This breaks on sparc64.
> > 
> > > +			err = smp_call_function_single(i,
> > > +
> > > __relay_set_buf_dentry,
> > > +						       &disp, 0,
> > > 1);
> > 
> > Because that ain't implemented.
> > 
> > There's a call in net/iucv/iucv.c, but that's s390-only.
> > 
> > There's a call in virt/kvm/kvm_main.c.
> > 
> > There's a call in kernel/time/tick-broadcast.c, so I assume that the
> > intersection between CONFIG_GENERIC_CLOCKEVENTS_BROADCAST and
> > non-smp_call_function_single() architectures is presently empty.
> 
> Hi,
> 
> I'm not sure what I should do.

Nothing, I'd suggest.  I think that all architectures should implement
smp_call_function_single().  You can have a shot at doing that if you
like, but the implementations will need to be reviewed and merged by
the relevant architectures maintainers.  (That's why I snuck linux-arch
into the cc list last time).

> Maybe disable relay_late_setup_files()
> on sparc64, with an empty inline?
>  
> > I guess all SMP-capable architectures should now implement this,
> > please.  It is presently defined on all architectures for CONFIG_SMP=n
> > and it is declared in include/linux/smp.h.
> 
> sparc64 seems to have smp_call_function_mask(). If we have the generic
> kernel/smp.c in linux-next or -mmotm, then this will define
> smp_call_function_single() to call smp_call_function_mask().
> 
> Is there anything I can do regarding this patch? Does it work since
> kernel/smp.c reappeared?

Nope:

y:/usr/src/25> grep USE_GENERIC_SMP_HELPERS arch/*/Kconfig
arch/alpha/Kconfig:     select USE_GENERIC_SMP_HELPERS
arch/arm/Kconfig:       select USE_GENERIC_SMP_HELPERS
arch/ia64/Kconfig:      select USE_GENERIC_SMP_HELPERS
arch/m32r/Kconfig:      select USE_GENERIC_SMP_HELPERS
arch/mips/Kconfig:      select USE_GENERIC_SMP_HELPERS
arch/parisc/Kconfig:    select USE_GENERIC_SMP_HELPERS
arch/powerpc/Kconfig:   select USE_GENERIC_SMP_HELPERS if SMP
arch/sh/Kconfig:        select USE_GENERIC_SMP_HELPERS
arch/x86/Kconfig:       select USE_GENERIC_SMP_HELPERS

It would help if you could check to see which architectures need work
and then perhaps propose patches.  If not, well, 2.6.27-rc1 will be
broken on some architectures on some configs and people will have a
couple of months to unbreak it.  Not a big problem, I expect.
