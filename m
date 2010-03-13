Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0CMMdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:33:01 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49118 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0CMMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:33:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OogKO+a+LfhzCmjGiVZQhtwTQ3t99DXA/p4HzH6wgNbEw33O8xtYjURUre0F4qpBMy
         ib4j+JRLjsZuG+5oJwEAlWy7FxKYsZC/uZn7VGI87m8a3rM366tAXK5+Jt6fQf6rgPvn
         Fb8AmH8fC6/xqtY34+HguzUrMfn3XjqTzMP+I=
Date: Sat, 13 Mar 2010 15:32:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,perf: Unmask LVTPC only if we have APIC supported
Message-ID: <20100313123256.GC5179@lenovo>
References: <20100313081116.GA5179@lenovo> <20100313122432.GA10810@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313122432.GA10810@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 01:24:32PM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > Ingo reported
> > |
> > | There's a build failure on -tip with the P4 driver, on UP 32-bit, if
> > | PERF_EVENTS is enabled but UP_APIC is disabled:
> > |
> > | arch/x86/built-in.o: In function `p4_pmu_handle_irq':
> > | perf_event.c:(.text+0xa756): undefined reference to `apic'
> > | perf_event.c:(.text+0xa76e): undefined reference to `apic'
> > |
> > 
> > So we have to unmask LVTPC only if we're configured to have one.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > CC: Lin Ming <ming.m.lin@intel.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> >  arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > =====================================================================
> > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> > @@ -365,8 +365,10 @@ static int p4_pmu_handle_irq(struct pt_r
> >  	}
> >  
> >  	if (handled) {
> > +#ifdef CONFIG_X86_LOCAL_APIC
> >  		/* p4 quirk: unmask it again */
> >  		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> > +#endif
> >  		inc_irq_stat(apic_perf_irqs);
> 
> This ugly #ifdef looks like a workaround though. Why doesnt apic_write() map 
> to nothing in that case?
> 
> 	Ingo
> 

It is. I mean -- it maps to nothing if apic is disabled. But the scenario is
that no apic configured at all. Actually I wonder how this code is supposed to
work without apic support.

Pehpaps better to make a p4 quirk helper here, since #ifdef at this point looks
ugly indeed.

Don't apply it then. Will back with other solution.

	-- Cyrill
