Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXKMWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXKMWPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbXKMWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:15:17 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48563 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757269AbXKMWPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:15:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAP6vOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 17:10:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: pageexec@freemail.hu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 06/11] Text Edit Lock - Alternative code for x86
Message-ID: <20071113221012.GC9057@Krystal>
References: <20071113184719.506949138@polymtl.ca> <473A2B1A.16967.38D5698D@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <473A2B1A.16967.38D5698D@pageexec.freemail.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:04:20 up 10 days,  3:09,  6 users,  load average: 0.26, 0.45,
	0.78
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* pageexec@freemail.hu (pageexec@freemail.hu) wrote:
> On 13 Nov 2007 at 13:46, Mathieu Desnoyers wrote:
> 
> > +void *text_poke_early(void *addr, const void *opcode, size_t len)
> > +{
> > +	memcpy(addr, opcode, len);
> > +	text_sync(addr, len);
> > +	return addr;
> > +}
> 
> why do you need this function (vs. using text_poke throughout)?
> 

Because it's not safe to use read_cr0() in paravirtualization
before the alternatives are set.

> > +#define kernel_wp_save(cr0)					\
> > +	do {							\
> > +		preempt_disable();				\
> > +		cr0 = read_cr0();				\
> > +		if (cpu_data(smp_processor_id()).wp_works_ok)	\
> 
> why do you need this test? if cr0.wp is ineffective, then it doesn't
> matter whether it's on or off (in fact, at least the intel manual
> says that 386s would not even let you change its value, they'll
> silently ignore attempts of setting the wp bit).
> 

Ok.. then this test could go away then. I prefered to use a conservative
approach. Will fix. Thanks for the hint.

Mathieu

> > +			write_cr0(cr0 & ~X86_CR0_WP);		\
> > +	} while (0)
> > +
> > +#define kernel_wp_restore(cr0)					\
> > +	do {							\
> > +		if (cpu_data(smp_processor_id()).wp_works_ok)	\
> 
> ditto...
> 
> > +			write_cr0(cr0);				\
> > +		preempt_enable();				\
> > +	} while (0)
> >  
> >  #endif /* _I386_ALTERNATIVE_H */
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
