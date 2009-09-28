Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZI1BzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZI1BzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZI1BzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:55:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43448 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752466AbZI1BzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:55:09 -0400
Date: Sun, 27 Sep 2009 20:54:17 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: limit irq affinity
Message-ID: <20090928015417.GA17347@sgi.com>
References: <20090928010217.GA16863@sgi.com> <86802c440909271819i303df4ccw9c5df1f4d4455e36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440909271819i303df4ccw9c5df1f4d4455e36@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 06:19:09PM -0700, Yinghai Lu wrote:
> On Sun, Sep 27, 2009 at 6:02 PM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> > This patch allows for restrictions to irq affinity via a new cpumask and
> > device node value in the irq_cfg structure.  The node value can then be
> > used by specific x86 architectures to determine the cpumask for the
> > desired cpu irq affinity domain.
> >
> > The mask forces IRQ affinity to remain within the specified cpu domain.
> > On some UV systems, this domain will be limited to the nodes accessible
> > to the given node.  Currently other X86 systems will have all bits in
> > the cpumask set, so non-UV systems will remain unaffected at this time.
> >
> > Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> >
> > ---
> >
> >  arch/x86/Kconfig                   |    1
> >  arch/x86/include/asm/uv/uv_irq.h   |    2
> >  arch/x86/include/asm/uv/uv_mmrs.h  |   25 ++++
> >  arch/x86/kernel/apic/io_apic.c     |  166 +++++++++++++++++++++++++++------
> >  arch/x86/kernel/apic/x2apic_uv_x.c |    2
> >  arch/x86/kernel/uv_irq.c           |   68 +++++++++++++
> >  6 files changed, 235 insertions(+), 29 deletions(-)
> >
> > Index: linux/arch/x86/kernel/apic/io_apic.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic/io_apic.c   2009-09-26 15:28:04.000000000 -0500
> > +++ linux/arch/x86/kernel/apic/io_apic.c        2009-09-26 16:20:04.000000000 -0500
> > @@ -62,6 +62,7 @@
> >  #include <asm/hw_irq.h>
> >  #include <asm/uv/uv_hub.h>
> >  #include <asm/uv/uv_irq.h>
> > +#include <asm/uv/uv.h>
> >
> >  #include <asm/apic.h>
> >
> > @@ -149,6 +150,8 @@ struct irq_cfg {
> >        struct irq_pin_list *irq_2_pin;
> >        cpumask_var_t domain;
> >        cpumask_var_t old_domain;
> > +       cpumask_var_t allowed;
> > +       int node;
> >        unsigned move_cleanup_count;
> >        u8 vector;
> >        u8 move_in_progress : 1;
> > @@ -184,6 +187,18 @@ void __init io_apic_disable_legacy(void)
> >        nr_irqs_gsi = 0;
> >  }
> >
> 
> original irq affinity in irq_desc does not work?
>

The allowed cpumask allows us to store the complete set of possible cpus allowed for the life of the irq, without having to recalculate that everytime IRQ affinity changes.   The irq_desc affinity is a dynamically changing value.
