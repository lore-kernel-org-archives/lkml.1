Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYKUKa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYKUKa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYKUKau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:30:50 -0500
Received: from koto.vergenet.net ([210.128.90.7]:50097 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYKUKat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:30:49 -0500
Date: Fri, 21 Nov 2008 16:17:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 36 of 38] xen: route hardware irqs via Xen
Message-ID: <20081121071754.GA4680@verge.net.au>
References: <patchbomb.1226603398@abulafia.goop.org> <00079eee3818aa0205e2.1226603434@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00079eee3818aa0205e2.1226603434@abulafia.goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:10:34AM -0800, Jeremy Fitzhardinge wrote:
> This patch puts the hooks into place so that when the interrupt
> subsystem registers an irq, it gets routed via Xen (if we're running
> under Xen).
> 
> The first step is to get a gsi for a particular device+pin.  We use
> the normal acpi interrupt routing to do the mapping.
> 
> Normally the gsi number is used directly as the irq number.  We can't
> do that since we also have irqs for non-hardware event channels, and
> so we must share the irq space between them.  A given gsi is only
> allocated a single irq, so re-registering a gsi will simply return the
> same irq.
> 
> We therefore allocate an irq for a given gsi, and return that.  As a
> special case, we reserve the first 16 irqs for identity-mapping legacy
> irqs, since there's a fair amount of code which assumes that.
> 
> Having allocated an irq, we ask Xen to allocate a vector, and then
> bind that pirq/vector to an event channel.  When the hardware raises
> an interrupt on a vector, Xen signals us on the corresponding event
> channel, which gets routed to the irq and delivered to the appropriate
> device driver.
> 
> This patch does everything except set up the IO APIC pin routing to
> the vector.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    8 +++
>  arch/x86/pci/legacy.c       |    4 +
>  arch/x86/xen/Makefile       |    1
>  arch/x86/xen/pci.c          |   98 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/xen-ops.h      |    1
>  drivers/xen/events.c        |    9 ++-
>  include/asm-x86/xen/pci.h   |    7 +++
>  include/xen/events.h        |    8 +++
>  8 files changed, 132 insertions(+), 4 deletions(-)
> 

[snip]

> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -63,7 +63,6 @@
>  static inline void xen_smp_init(void) {}
>  #endif
>  
> -
>  void xen_init_apic(void);
>  
>  /* Declare an asm function, along with symbols needed to make it

Hi Jeremy,

This seems like a spurious whitespace change that could be
merged into "[PATCH 30 of 38] xen: implement io_apic_ops"

[snip]

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

