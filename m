Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZBMKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZBMKBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZBMKBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:01:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbZBMKBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:01:38 -0500
Date: Fri, 13 Feb 2009 10:58:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Subject: Re: [patch] x86, ptrace: fix double-free on race
Message-ID: <20090213095847.GA20311@redhat.com>
References: <20090211151027.A16643@sedona.ch.intel.com> <20090211220821.GA17637@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A3D5FC1@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A3D5FC1@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12, Metzger, Markus T wrote:
>
> >-----Original Message-----
> >From: Oleg Nesterov [mailto:oleg@redhat.com]
> >
> >	static inline void arch_bts_init(struct task_struct *p)
> >	{
> >	#ifdef CONFIG_X86_PTRACE_BTS
> >		if (unlikely(p->bts)) {
> >			p->bts = NULL;
> >			p->bts_buffer = NULL;
> >			p->bts_size = 0;
> >			p->thread.bts_ovfl_signal = 0;
> >		}
> >	#endif /* CONFIG_X86_PTRACE_BTS */
> >	}
>
> It looked cleaner and more consistent to me, that way.
>
> Ptrace passes things down to arch in other cases already,
> e.g. ptrace_detach()->ptrace_disable(), ptrace()->arch_ptrace(),
> ptrace_attach()->arch_ptrace_attach().
>
> I think the function should be in arch/x86/ptrace.c - if we call it from
> ptrace or from arch_dup_task_struct() doesn't really matter.
>
> Do you want me to move the call to arch_dup_task_struct()?

Please do what you like more. We can call this from dup_task_struct()
or even from copy_process(). Actually, the initialization above is not
arch dependent, it only depends on CONFIG_BTS.

> >Btw, just curious, bts_ovfl_signal is not used, except the user can
> >set/get it via PTRACE_BTS_CONFIG/PTRACE_BTS_STATUS ?
>
> It's not really necessary for debugging, but we wanted to get the interface
> general enough to support other use cases.
>
> There's already a PMI interrupt handler in perfmon which handles the PEBS
> buffer overflow. Stephane was planning to extract it so it can be used by
> ds.c. Once that is done, we were planning to move the buffer overflow
> handling for BTS and PEBS into ds.c and enable the feature in ptrace.

OK, thanks. (of course I don't understand this magic, but hopefully
can understand your answer ;)

Oleg.

