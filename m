Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZFBRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZFBRF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZFBRFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:05:19 -0400
Received: from www.tglx.de ([62.245.132.106]:51527 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZFBRFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:05:18 -0400
Date: Tue, 2 Jun 2009 18:58:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 01/17] xen/dom0: handle acpi lapic parsing in Xen dom0
In-Reply-To: <1243409850-21577-2-git-send-email-jeremy@goop.org>
Message-ID: <alpine.LFD.2.00.0906021826430.3419@localhost.localdomain>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-2-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Jeremy Fitzhardinge wrote:

> When running in Xen dom0, we still want to parse the ACPI tables to
> find out about local and IO apics, but we don't want to actually use
> the lapics.

Hmm, we parse the tables and discard the information. What's the point
of this exercise ? Some nice dmesg lines ?
 
> Put a couple of tests for Xen to prevent lapics from being mapped or
> accessed.  This is very Xen-specific behaviour, so there didn't seem to
> be any point in adding more indirection.

I hate these "if (xen_...)" extra cases even more than the paravirt
misery. They stick Xen dependencies into random places and enforce the
people who want to modify that code to find out why the heck this
needs to be there.

That's the fundamental design problem with the Dom0 model that you
want just certain parts of Linux and those parts which are in your way
are just hacked out. But this is designed to be a nightmare for
maintainence and development. Are you going to stick more and more of
those "if (xen..)" constructs into places which provide functionality
which is only partially useful to Xen ?

Thanks,

	tglx

> [ Impact: ignore local apics, which are not usable under Xen ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kernel/acpi/boot.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 723989d..4147e0c 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -41,6 +41,8 @@
>  #include <asm/mpspec.h>
>  #include <asm/smp.h>
>  
> +#include <asm/xen/hypervisor.h>
> +
>  static int __initdata acpi_force = 0;
>  u32 acpi_rsdt_forced;
>  #ifdef	CONFIG_ACPI
> @@ -218,6 +220,10 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
>  {
>  	unsigned int ver = 0;
>  
> +	/* We don't want to register lapics when in Xen dom0 */
> +	if (xen_initial_domain())
> +		return;
> +
>  	if (!enabled) {
>  		++disabled_cpus;
>  		return;
> @@ -802,6 +808,10 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
>  
>  static void __init acpi_register_lapic_address(unsigned long address)
>  {
> +	/* Xen dom0 doesn't have usable lapics */
> +	if (xen_initial_domain())
> +		return;
> +
>  	mp_lapic_addr = address;
>  
>  	set_fixmap_nocache(FIX_APIC_BASE, address);
> -- 
> 1.6.0.6
> 
