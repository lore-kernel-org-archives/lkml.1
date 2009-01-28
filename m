Return-Path: <linux-kernel-owner+w=401wt.eu-S1762343AbZA1U6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbZA1U6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZA1UqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:46:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850AbZA1UqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:46:12 -0500
Date: Wed, 28 Jan 2009 12:44:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: agraf@suse.de, Clemens Noss <cnoss@gmx.de>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: linux-next: Tree for January 23 (kvm)
Message-Id: <20090128124410.c203fab1.akpm@linux-foundation.org>
In-Reply-To: <20090128142616.GA4344@amt.cnet>
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
	<497A29D0.2010307@oracle.com>
	<20090128015149.791e10dd.akpm@linux-foundation.org>
	<A6E711C3-9127-4B57-9BD2-0C00D773C8EA@suse.de>
	<20090128142616.GA4344@amt.cnet>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc mailing lists)

On Wed, 28 Jan 2009 12:26:16 -0200
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Wed, Jan 28, 2009 at 11:20:16AM +0100, Alexander Graf wrote:
> >
> > On 28.01.2009, at 10:51, Andrew Morton wrote:
> >
> >> On Fri, 23 Jan 2009 12:34:24 -0800 Randy Dunlap 
> >> <randy.dunlap@oracle.com> wrote:
> >>
> >>> Stephen Rothwell wrote:
> >>>> Hi all,
> >>>>
> >>>> News:  I will be on leave next week, so there will probably be no
> >>>> linux-next release until Feb 2.
> >>>>
> >>>> Changes since 20090122:
> >>>
> >>>
> >>> kvm changes cause this build error on i386:
> >>>
> >>> when kvm is built as module:
> >>> ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!
> >>>
> >>> or when kvm is built into the kernel image:
> >>> lapic.c:(.text+0x19276): undefined reference to `__moddi3'
> >>>
> >>>
> >>> I guess it's this line:
> >>> 	ns = ktime_to_ns(remaining) % apic->timer.period;
> >>>
> >>
> >> dammit, I just spent N minutes hunting down the same thing in
> >> the Jan 26 linux-next :(
> >>
> >
> > Yeah, Clemens Foss posted a real fix on kvm@vger already.

Probably wasn't the best mailing list, as this bug affects all
developers and testers..  But whatever - thanks.

> commit efe4ff38b2bbc3944d0b2c9b6ec669b67cb7acbc
> Author: Clemens Noss <cnoss@gmx.de>
> Date:   Mon Jan 26 02:55:16 2009 +0100
> 
>     KVM: x86: fix "__moddi3 undefined" build failure in lapic.c
>     
>     use mod_64 from arch/x86/kvm/i8254.c to fix
>     ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!
>     
>     Signed-off-by: Clemens Noss <cnoss@gmx.de>
>     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d8adc50..f0b67f2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -35,6 +35,12 @@
>  #include "kvm_cache_regs.h"
>  #include "irq.h"
>  
> +#ifndef CONFIG_X86_64
> +#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
> +#else
> +#define mod_64(x, y) ((x) % (y))
> +#endif
> +
>  #define PRId64 "d"
>  #define PRIx64 "llx"
>  #define PRIu64 "u"
> @@ -525,7 +531,7 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
>  	if (ktime_to_ns(remaining) < 0)
>  		remaining = ktime_set(0, 0);
>  
> -	ns = ktime_to_ns(remaining) % apic->timer.period;
> +	ns = mod_64(ktime_to_ns(remaining), apic->timer.period);
>  	tmcct = div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
>  
>  	return tmcct;

Rather than cooking up a private implementation I think it would be
better to implement a kernel-wide mod64_u64() (?) facility and then to
use that in KVM.  There will presumably be other sites which will (or
already do) need such a thing.

However it'll probably be a bit hard, getting the signednesses of the
args and the return value right.

