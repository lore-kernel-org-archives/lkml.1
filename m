Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZECItV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZECItV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZECItL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:49:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZECItK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:49:10 -0400
Date: Sun, 3 May 2009 10:48:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090503084847.GA20394@elte.hu>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501203123.GA10878@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> >  arch/x86/kernel/apic/x2apic_uv_x.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> > =====================================================================
> > --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> > +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
> > @@ -584,15 +584,18 @@ void __init uv_system_init(void)
> >  
> >  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
> >  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
> > +	BUG_ON(!uv_blade_info);
> >  
> >  	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
> >  
> >  	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
> >  	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
> > +	BUG_ON(!uv_node_to_blade);
> >  	memset(uv_node_to_blade, 255, bytes);
> >  
> >  	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
> >  	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
> > +	BUG_ON(!uv_cpu_to_blade);
> >  	memset(uv_cpu_to_blade, 255, bytes);

Hm, would be nice if we had a __GFP_PANIC variant in kmalloc that 
would just panic straight in the allocator, when allocation failure 
is not acceptable. (Andrew Cc:-ed)

It does not increase the priority of the allocation nor does it 
trigger any 'dont fail' logic - it is simply the central expression 
of 'this should not have failed, panic'.

Thus we'd avoid all these duplicated BUG_ON() places.

	Ingo
