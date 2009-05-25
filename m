Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZEYA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZEYA4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEYA4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:56:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:22633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZEYA4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:56:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,241,1241420400"; 
   d="scan'208";a="460086219"
Date: Mon, 25 May 2009 08:56:46 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Subject: Re: [patch 2/2] x86: put offline CPUs into deepest mwait
	cstate_subcstate
Message-ID: <20090525005646.GA9093@sli10-desk.sh.intel.com>
References: <20090522231940.553094000@intel.com> <20090522232230.162239000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522232230.162239000@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 07:19:42AM +0800, Pallipadi, Venkatesh wrote:
> Offline CPUs can save power by going into deepest cstate, subcstate
> instead of hlt loop.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/kernel/acpi/cstate.c |   51 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> index bbbe4bb..5b0988a 100644
> --- a/arch/x86/kernel/acpi/cstate.c
> +++ b/arch/x86/kernel/acpi/cstate.c
> @@ -150,6 +150,54 @@ void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
>  }
>  EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_enter);
>  
> +static unsigned long mwait_play_dead_eax;
> +
> +static void mwait_play_dead(void)
> +{
> +	if (boot_cpu_data.x86 >= 4)
> +		wbinvd();
> +
> +	while (1) {
> +		__monitor((void *)&current_thread_info()->flags, 0, 0);
> +		smp_mb();
> +		__mwait(mwait_play_dead_eax, 0);
> +	}
> +}
CPU is dead, can current_thread_info() still be used? Maybe just monitor a never changed
address.

Looks the patch will always take the highest native C-state, is this safe, considering
BIOS usually limit C-state?

Thanks,
Shaohua
