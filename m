Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYCZEg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYCZEg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYCZEgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:36:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:41349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbYCZEgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:36:45 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] acpi_unlazy_tlb only on C3 entry
Date: Wed, 26 Mar 2008 00:35:55 -0400
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20080324212410.GB6783@linux-os.sc.intel.com>
In-Reply-To: <20080324212410.GB6783@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260035.55874.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this was causeed by a merge error -- the checked-in patch
did not match the e-mailed patch.

I found that I could reproduce the error if I used patch(1)
and ignored this:

patching file drivers/acpi/processor_idle.c
Hunk #1 succeeded at 534 with fuzz 2 (offset 4 lines).
Hunk #2 succeeded at 1420 (offset -66 lines).

The 2nd hunk is what failed:
Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
@@ -530,6 +530,7 @@ static void acpi_processor_idle(void)
                break;

        case ACPI_STATE_C3:
+               acpi_unlazy_tlb(smp_processor_id());
                /*
                 * disable bus master
                 * bm_check implies we need ARB_DIS
@@ -1485,6 +1486,7 @@ static int acpi_idle_enter_bm(struct cpu
                return 0;
        }

+       acpi_unlazy_tlb(smp_processor_id());
        /*
         * Must be done before busmaster disable as we might need to
         * access HPET !


As this touches just acpi/processor_idle.c, I'll send this with
a batch of acpi patches I've got.

applied.

thanks,
-Len

On Monday 24 March 2008, Venki Pallipadi wrote:
> 
> Earlier patch here
> http://ussg.iu.edu/hypermail/linux/kernel/0712.2/1451.html
> was intending to add acpi_unlazy_tlb() to acpi_idle_enter_bm() routine which is
> used for C3 entry. But, some where along the way the call got added to
> acpi_idle_enter_simple() (which is C2 entry routine), probably due to identical
> context in that function. Move it back to acpi_idle_enter_bm().
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
>  drivers/acpi/processor_idle.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-x86.git/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6-x86.git.orig/drivers/acpi/processor_idle.c	2008-03-21 08:28:47.000000000 -0700
> +++ linux-2.6-x86.git/drivers/acpi/processor_idle.c	2008-03-24 06:43:01.000000000 -0700
> @@ -1487,7 +1487,6 @@ static int acpi_idle_enter_simple(struct
>  		return 0;
>  	}
>  
> -	acpi_unlazy_tlb(smp_processor_id());
>  	/*
>  	 * Must be done before busmaster disable as we might need to
>  	 * access HPET !
> @@ -1577,6 +1576,8 @@ static int acpi_idle_enter_bm(struct cpu
>  		return 0;
>  	}
>  
> +	acpi_unlazy_tlb(smp_processor_id());
> +
>  	/* Tell the scheduler that we are going deep-idle: */
>  	sched_clock_idle_sleep_event();
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


