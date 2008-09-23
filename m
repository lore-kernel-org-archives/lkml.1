Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYIWTbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYIWTbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYIWTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:30:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbYIWTay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:30:54 -0400
Date: Tue, 23 Sep 2008 14:30:49 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Add early detection of UV system types
Message-ID: <20080923193049.GA21605@sgi.com>
References: <20080923182817.GA6335@sgi.com> <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:59:26AM -0700, Yinghai Lu wrote:
> On Tue, Sep 23, 2008 at 11:28 AM, Jack Steiner <steiner@sgi.com> wrote:
> > Portions of system boot needs to know if a system is a UV system prior
> > to genapic initialization. This patch adds a call from acpi_boot_table_init()
> > to the UV code to parse the MADT to determine if the system is a UV system.
> >
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> >
> > ---
> >  arch/x86/kernel/acpi/boot.c      |    4 ++++
> >  arch/x86/kernel/genx2apic_uv_x.c |   21 ++++++++++++---------
> >  arch/x86/mm/srat_64.c            |    2 +-
> >  include/asm-x86/genapic_64.h     |    2 ++
> >  4 files changed, 19 insertions(+), 10 deletions(-)
> >
> > Index: linux/arch/x86/kernel/acpi/boot.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/acpi/boot.c      2008-09-23 12:55:15.000000000 -0500
> > +++ linux/arch/x86/kernel/acpi/boot.c   2008-09-23 12:55:19.000000000 -0500
> > @@ -1667,6 +1667,10 @@ int __init acpi_boot_table_init(void)
> >
> >        acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
> >
> > +#ifdef CONFIG_X86_64
> > +       acpi_table_parse(ACPI_SIG_MADT, uv_early_madt_oem_check);
> > +#endif
> > +
> >        /*
> >         * blacklist may disable ACPI entirely
> >         */
> 
> you don't need to that.
> 
> please call early_acpi_boot_init instead

I don't mind moving the new call from acpi_boot_table_init() to early_acpi_boot_init(),
but I still need to determine the UV type very early in boot. System type is needed
prior to parsing the SRAT.

> 
> sth like
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 3d677b5..7ead2aa 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -997,6 +997,8 @@ void __init setup_arch(char **cmdline_p)
>          */
>         acpi_boot_table_init();
> 
> +       early_acpi_boot_init();
> +
>  #ifdef CONFIG_ACPI_NUMA
>         /*
>          * Parse SRAT to discover nodes.
> 
> YH
