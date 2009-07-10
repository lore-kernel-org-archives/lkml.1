Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZGJFww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZGJFww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZGJFwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:52:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZGJFwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:52:43 -0400
Date: Fri, 10 Jul 2009 07:52:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 11/12] SFI, PCI: Hook MMCONFIG
Message-ID: <20090710055229.GD22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <24fe646fcbbd9049850de4ac57cf6a67846b38c4.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fe646fcbbd9049850de4ac57cf6a67846b38c4.1247025117.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> First check ACPI, and if that fails, ask SFI to find the MCFG.
> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/Kconfig               |    2 +-
>  arch/x86/pci/mmconfig-shared.c |    5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8e864c0..8e20a0e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1880,7 +1880,7 @@ config PCI_DIRECT
>  
>  config PCI_MMCONFIG
>  	def_bool y
> -	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
> +	depends on X86_32 && PCI && (ACPI || SFI) && (PCI_GOMMCONFIG || PCI_GOANY)

Please also update the 64-bit side (there's no reason to do this on 
32-bit only - even though your sample hw is probably 32-bit only) - 
and while at it, also unify the currently separate 32-bit and 64-bit 
PCI_MMCONFIG definitions.

> @@ -606,7 +607,9 @@ static void __init __pci_mmcfg_init(int early)
>  	}
>  
>  	if (!known_bridge)
> -		acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> +		if (acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg))
> +			sfi_acpi_table_parse(ACPI_SIG_MCFG, NULL, NULL, 0,
> +				pci_parse_mcfg);

Please introduce one common/generic helper:

		x86_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);

and do the fallback in that helper. We generally want to try ACPI 
first, SFI second. That helper makes it easier to add such fallback 
in other places as well, and will de-uglify the above code as well.

	Ingo
