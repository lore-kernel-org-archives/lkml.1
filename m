Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbZCRTDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbZCRTDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZCRTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:03:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZCRTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:03:03 -0400
Date: Wed, 18 Mar 2009 20:02:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
Message-ID: <20090318190257.GB16286@elte.hu>
References: <1237314836.3212.10.camel@localhost.localdomain> <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu> <1237392355.12866.2.camel@ht.satnam> <20090318161829.GC21331@elte.hu> <20090318163933.GA29854@elte.hu> <1237396487.22438.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237396487.22438.2.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-03-18 at 17:39 +0100, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > >  1 files changed, 120 insertions(+), 141 deletions(-)
> > > 
> > > Looks good - pulled, thanks Jaswinder!
> > > 
> > > Would you be interested in resurrecting the more mechanic cleanups 
> > > you did as well, on top of this patch?
> > > 
> > > They are still valuable, we just have to keep them separate from a 
> > > potential breakage-causing change like the above one, so that if a 
> > > tester bisects to it, we have an as single-purpose and focused 
> > > commit to look at as possible.
> > 
> > So it's helpful to have a small commit when we have a regression.
> > 
> > Such as in this case - a -tip testbox crashed with:
> > 
> > weird, boot CPU (#0) not listed by the BIOS.
> > Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (0 vs 4)
> > Pid: 1, comm: swapper Not tainted 
> > 2.6.29-rc8-tip-02595-g170ae27-dirty #21111
> > Call Trace:
> >  [<c0599964>] ? printk+0x14/0x18
> >  [<c05998a6>] panic+0x3e/0xe8
> >  [<c08fc9e4>] native_smp_prepare_cpus+0x13e/0x1f8
> >  [<c08f335a>] kernel_init+0x47/0xd8
> >  [<c08f3313>] ? kernel_init+0x0/0xd8
> >  [<c0103ea3>] kernel_thread_helper+0x7/0x10
> > 
> > config and full crashlog attached.
> > 
> 
> As I told you earlier, I cannot check this on my side. Only 
> suspect will be check_irq_src() please test this patch if this 
> does not work I will revert check_irq_src():

no need to test on your side. If a patch is broken the first step is 
to take a look at the patch and think about it. For example this 
block:

                case MP_PROCESSOR:
-                       {
-                               struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-                               /* ACPI may have already provided this data */
-                               if (!acpi_lapic)
-                                       MP_processor_info(m);
-                               mpt += sizeof(*m);
-                               count += sizeof(*m);
-                               break;
-                       }
+                       /* ACPI may have already provided this data */
+                       if (!acpi_lapic)
+                               MP_processor_info((struct mpc_cpu *)&mpt);
+                       skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+                       break;


is buggy.

	Ingo
