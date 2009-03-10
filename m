Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZCJWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZCJWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZCJWCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:02:39 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39050 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbZCJWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:02:38 -0400
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <86802c440903101458yb029691h84c87cf480a7750@mail.gmail.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <86802c440903101458yb029691h84c87cf480a7750@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 17:02:32 -0500
Message-Id: <1236722552.14822.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 14:58 -0700, Yinghai Lu wrote:
> On Sun, Mar 8, 2009 at 9:48 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Given the lack of feedback, I went ahead and implemented the additions
> > to smp_ops and x86_quirks (and a dynamic mca NMI hook) to allow
> > voyager to be plumbed in.
> >
> > There also needs to be changes in the boot setup to make voyager work
> > dynamically: It has to be detected first, so the a20 gate check is
> > only executed if a voyager is not found.
> >
> > I also completed some of the subarchitecture eliminations, so all the
> > include file infrastructure should be gone.
> >
> > The result is that I can boot both my PC SMP x86 boxes and voyager
> > with the same kernel.
> >
> > This patch series applies on the x86/apic branch of the x86 tree
> > (obviously with 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 reverted)
> >
> > James
> >
> > ---
> >
> >  [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
> >  [VOYAGER] x86/mca: make mca_nmi_hook external
> >  [VOYAGER] x86: add prefill_possible_map to x86_quirks
> >  [VOYAGER] x86: use boot_cpu_id instead of zero for checking boot
> >    processor
> >  [VOYAGER] x86/voyager: Move voyager detection to a new bootparam area
> >  [VOYAGER] x86: eliminate subarchitecture file setup_arch.h
> >  [VOYAGER] x86: eliminate subarchitecture file entry_arch.h
> >  [VOYAGER] x86: eliminate subarchitecture file do_timer.h
> >  [VOYAGER] x86: redo irq2 cascade setup
> >  [VOYAGER] x86: make disabling the apics functional instead of a flag
> >  [VOYAGER] x86/Voyager: add missing QIC call function single gate
> >  [VOYAGER] x86/Voyager: replace inline io area reads with readX
> >    accessors
> >  [VOYAGER] x86/Voyager: Plumb voyager back into the build
> >
> >  arch/x86/Kconfig                               |    4 +-
> >  arch/x86/Makefile                              |    2 +
> >  arch/x86/boot/Makefile                         |    4 +-
> >  arch/x86/boot/a20.c                            |   13 +-
> >  arch/x86/boot/boot.h                           |    2 +-
> >  arch/x86/boot/voyager.c                        |    5 +-
> >  arch/x86/include/asm/apic.h                    |    6 +
> >  arch/x86/include/asm/bootparam.h               |    5 +-
> >  arch/x86/include/asm/do_timer.h                |   16 -
> >  arch/x86/include/asm/entry_arch.h              |   57 ---
> >  arch/x86/include/asm/hw_irq.h                  |   11 +
> >  arch/x86/include/asm/mach-voyager/do_timer.h   |   17 -
> >  arch/x86/include/asm/mach-voyager/entry_arch.h |   26 --
> >  arch/x86/include/asm/mach-voyager/setup_arch.h |   12 -
> 
> could remove "mach-" here.

This directory is actually gone after the patch.

> >  arch/x86/include/asm/mca.h                     |    3 +
> >  arch/x86/include/asm/setup.h                   |    6 +-
> >  arch/x86/include/asm/setup_arch.h              |    3 -
> >  arch/x86/include/asm/smp.h                     |   13 +-
> >  arch/x86/include/asm/voyager.h                 |   80 ++---
> >  arch/x86/include/asm/voyager_bios.h            |   21 +
> >  arch/x86/include/asm/voyager_boot.h            |   27 ++
> >  arch/x86/include/asm/voyager_vectors.h         |   37 ++
> >  arch/x86/kernel/apic/apic.c                    |    8 +-
> >  arch/x86/kernel/apic/ipi.c                     |    2 +-
> >  arch/x86/kernel/apic/probe_32.c                |    3 +
> >  arch/x86/kernel/entry_32.S                     |   70 +++-
> >  arch/x86/kernel/irqinit_32.c                   |   15 +-
> >  arch/x86/kernel/mca_32.c                       |   12 +
> >  arch/x86/kernel/probe_roms_32.c                |    1 -
> >  arch/x86/kernel/setup.c                        |   35 +--
> >  arch/x86/kernel/smp.c                          |    7 +
> >  arch/x86/kernel/smpboot.c                      |    2 +-
> >  arch/x86/kernel/time_32.c                      |   11 +-
> >  arch/x86/kernel/visws_quirks.c                 |    7 -
> >  arch/x86/mach-voyager/setup.c                  |   66 ++--
> >  arch/x86/mach-voyager/voyager_basic.c          |   98 ++---
> >  arch/x86/mach-voyager/voyager_smp.c            |  544 ++++++++----------------
> >  arch/x86/mach-voyager/voyager_thread.c         |    5 +-
> 
> same here

Heh, that would blow my nice diffstat out of the water ...

It's useful to keep code like this separated, since you don't
necessarily want some kernelnewby wandering across it as an example of
how to do SMP on x86 ... I'm not wedded to the name, but mach-voyager is
as good a descriptive directory name as any other.

James


