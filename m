Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbXIERFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbXIERFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXIERFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:05:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46957 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbXIERFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:05:22 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Zachary Amsden <zach@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <1189010022.10802.161.camel@localhost.localdomain>
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>
	 <46CE81DC.90103@vmware.com>  <46D9D517.6010201@goop.org>
	 <1188850468.10802.66.camel@localhost.localdomain>
	 <46DD60A9.8080203@goop.org>
	 <1189010022.10802.161.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 10:05:09 -0700
Message-Id: <1189011909.21516.1.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 02:33 +1000, Rusty Russell wrote:
> On Tue, 2007-09-04 at 14:42 +0100, Jeremy Fitzhardinge wrote:
> > Rusty Russell wrote:
> > >  static inline void arch_flush_lazy_mmu_mode(void)
> > >  {
> > > -	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
> > > +	if (unlikely(__get_cpu_var(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU))
> > > +		arch_leave_lazy_mmu_mode();
> > >  }
> > >   
> > 
> > This changes the semantics a bit; previously "flush" would flush
> > anything pending but leave us in lazy mode.  This just drops lazymode
> > altogether?
> > 
> > I guess if we assume that flushing is a rare event then its OK, but I
> > think the name's a bit misleading.  How does it differ from plain
> > arch_leave_lazy_mmu_mode()?
> 
> Whether it's likely or unlikely to be in lazy mode, basically.  But
> you're right, this should be folded, since we don't want to "leave" lazy
> mode twice.
> 
> ===
> Hoist per-cpu lazy_mode variable up into common code.
> 
> VMI, Xen and lguest all track paravirt_lazy_mode individually, meaning
> we hand a "magic" value for set_lazy_mode() to say "flush if currently
> active".
> 
> We can simplify the logic by hoisting this variable into common code.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> ---
>  arch/i386/kernel/vmi.c      |   16 ++++------------
>  arch/i386/xen/enlighten.c   |   15 +++------------
>  arch/i386/xen/multicalls.h  |    2 +-
>  arch/i386/xen/xen-ops.h     |    7 -------
>  drivers/lguest/lguest.c     |   25 ++++++-------------------
>  include/asm-i386/paravirt.h |   29 ++++++++++++++++-------------
>  6 files changed, 30 insertions(+), 64 deletions(-)
> 
> diff -r 072a0b3924fb arch/i386/kernel/vmi.c
> --- a/arch/i386/kernel/vmi.c	Thu Aug 30 04:47:43 2007 +1000
> +++ b/arch/i386/kernel/vmi.c	Wed Sep 05 04:06:20 2007 +1000
> @@ -554,22 +554,14 @@ vmi_startup_ipi_hook(int phys_apicid, un
>  
>  static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
>  {
> -	static DEFINE_PER_CPU(enum paravirt_lazy_mode, lazy_mode);
> -
>  	if (!vmi_ops.set_lazy_mode)
>  		return;
>  
>  	/* Modes should never nest or overlap */
> -	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
> -					     mode == PARAVIRT_LAZY_FLUSH));
> -
> -	if (mode == PARAVIRT_LAZY_FLUSH) {
> -		vmi_ops.set_lazy_mode(0);
> -		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
> -	} else {
> -		vmi_ops.set_lazy_mode(mode);
> -		__get_cpu_var(lazy_mode) = mode;
> -	}
> +	BUG_ON(get_lazy_mode() && !(mode == PARAVIRT_LAZY_NONE |
> +				    | mode == PARAVIRT_LAZY_FLUSH));

That's a pretty strange line break.



