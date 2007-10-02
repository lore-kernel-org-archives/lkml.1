Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbXJBHxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbXJBHxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXJBHx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:53:26 -0400
Received: from ozlabs.org ([203.10.76.45]:58339 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXJBHx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:53:26 -0400
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <4701E552.3070501@goop.org>
References: <470186C4.5080208@goop.org>
	 <1191288858.6979.20.camel@localhost.localdomain>
	 <4701E552.3070501@goop.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 17:53:04 +1000
Message-Id: <1191311584.17826.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 23:29 -0700, Jeremy Fitzhardinge wrote: 
> Rusty Russell wrote:
> > That's good, but this code does lose on native because we no longer
> > simply replace the entire thing with noops.
> >
> > Perhaps inverting this and having (inline) helpers is the way to go?
> > 
> > static inline void paravirt_enter_lazy(enum paravirt_lazy_mode mode)
> > {
> > 	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
> > 	BUG_ON(preemptible());
> >
> > 	x86_write_percpu(paravirt_lazy_mode, mode);
> > }
> >
> > static inline void paravirt_exit_lazy(enum paravirt_lazy_mode mode)
> > {
> > 	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
> > 	BUG_ON(preemptible());
> >
> > 	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
> > }
> >   
> 
> Er, they should probably call something to make the switch actually
> happen, no?

No, they're helpers.  eg:

static void lguest_exit_lazy(enum paravirt_lazy_mode mode)
{
paravirt_exit_lazy(mode);
lguest_flush_hcalls();
}

> > The only trick would be that the flushes are so rarely required it's
> > probably worth putting the unlikely() in the top level:
> 
> Sure, I guess.  Would it make any difference?  (I've never personally
> noticed likely/unlikely change the generated code in any seriously
> positive way.)

Probably overkill (I was trying to avoid the branch for the case where
we don't need to flush, as that's always what happens).

So just expose a flush hook:

static inline void arch_flush_lazy_cpu_mode(void)
{
	PVOP_VCALL1(flush_lazy_mode, PARAVIRT_LAZY_CPU);
}

....

static void lguest_flush_lazy_mode(enum paravirt_lazy_mode mode)
{
	if (unlikely(x86_read_percpu(paravirt_lazy_mode) == mode)) {
		lguest_lazy_cpu_leave();
		lguest_lazy_cpu_enter();
	}
}

Cheers,
Rusty.

