Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZBTJwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZBTJwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZBTJvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:51:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZBTJvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:51:50 -0500
Date: Fri, 20 Feb 2009 10:51:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220095127.GK24555@elte.hu>
References: <499DD40F.40102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DD40F.40102@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix bug.
> 
> otherwise will get panic from early_acpi_boot_init()
> also make disable_x2apic global, so could use it it x2_apic_xxx.c
> and can get warning if preenabled system using nox2apic.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/apic.c           |    3 +--
>  arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
>  arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
>  arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
>  drivers/pci/dmar.c                    |    3 ++-
>  5 files changed, 14 insertions(+), 6 deletions(-)

I've applied it because it fixes a real bug, but this code 
really needs a cleanup. Look at the repeat patterns:

> Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -14,8 +14,11 @@ DEFINE_PER_CPU(u32, x86_cpu_to_logical_a
>  
>  static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
> -	if (cpu_has_x2apic)
> +	if (cpu_has_x2apic && !disable_x2apic) {
> +		x2apic = 1;
> +		enable_x2apic();
>  		return 1;
> +	}
>  
>  	return 0;
>  }
> Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
> @@ -21,8 +21,11 @@ early_param("x2apic_phys", set_x2apic_ph
>  
>  static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
> -	if (cpu_has_x2apic && x2apic_phys)
> +	if (cpu_has_x2apic && !disable_x2apic && x2apic_phys) {
> +		x2apic = 1;
> +		enable_x2apic();
>  		return 1;
> +	}
>  
>  	return 0;
>  }
> Index: linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -41,8 +41,10 @@ static int uv_acpi_madt_oem_check(char *
>  			uv_system_type = UV_LEGACY_APIC;
>  		else if (!strcmp(oem_table_id, "UVX"))
>  			uv_system_type = UV_X2APIC;
> -		else if (!strcmp(oem_table_id, "UVH")) {
> +		else if (!strcmp(oem_table_id, "UVH") && !disable_x2apic) {
>  			uv_system_type = UV_NON_UNIQUE_APIC;
> +			x2apic = 1;
> +			enable_x2apic();
>  			return 1;
>  		}
>  	}

Such repeat patterns with small variations are always the sign 
of an inefficient code structure.

The clean approach would be to have one generic helper function 
concentrated into enable_x2apic(). So instead of:

 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
	if (cpu_has_x2apic && !disable_x2apic && x2apic_phys) {
		x2apic = 1;
		enable_x2apic();
		return 1;
	}

	return 0;
 }

We'd have:

 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
	if (!x2apic_phys)
		return 0;

	return x86_enable_x2apic();
 }

That way all the repeat and common functionality (and the return 
code logic) is concentrated into enable_x2apic(), and the 
x2apic_acpi_madt_oem_check() function has _only_ its own special 
check open-coded. (namely, whether physical ID delivery mode is 
forced off.)

Okay?

	Ingo
