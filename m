Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZHZIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZHZIIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZHZIIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:08:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZHZIIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:08:47 -0400
Date: Wed, 26 Aug 2009 10:08:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: fix vsmp booting with phys_pkg_id changing
Message-ID: <20090826080811.GG23435@elte.hu>
References: <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain> <20090825191231.GA22821@elte.hu> <4A9438D1.4030608@kernel.org> <20090825192416.GA6974@elte.hu> <20090825203640.GG6456@localdomain> <4A944D3C.5030100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A944D3C.5030100@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 2.6.31-rc7 does not boot on vSMPowered systems. 
> 
> [    8.501108] CPU31: Thermal monitoring enabled (TM1)
> [    8.501127] CPU 31 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> [    8.650254] CPU31: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 04
> [    8.710324] Brought up 32 CPUs
> [    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
> [    8.721489] ERROR: parent span is not a superset of domain->span
> [    8.727686] ERROR: domain->groups does not contain CPU0
> [    8.733091] ERROR: groups don't span domain->span
> [    8.737975] ERROR: domain->cpu_power not set
> [    8.742416]
> 
> bisected to
> |
> | commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c
> | x86: don't call read_apic_id if !cpu_has_apic
> |
> 
> need to use apic id in phys_pkg_id for vsmp...
> 
> Reported-and-Tested-by: Ravikiran Thirumalai <kiran@scalex86.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
> +++ linux-2.6/arch/x86/kernel/apic/probe_64.c
> @@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initd
>  	NULL,
>  };
>  
> +static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
> +{
> +	return hard_smp_processor_id() >> index_msb;
> +}
> +
>  /*
>   * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
>   */
> @@ -69,6 +74,11 @@ void __init default_setup_apic_routing(v
>  		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
>  	}
>  
> +	if (is_vsmp_box()) {
> +		/* need to update phys_pkg_id */
> +		apic->phys_pkg_id = apicid_phys_pkg_id;
> +	}

Ok, this looks like a rather straightforward quirk - and vSMP is 
indeed special in that it sets up overlapping APIC ids. It's also 
the smaller patch with basically zero cross section to other 
systems, so a lot more -rc7 worthy.

So i've applied it to x86/urgent (with small edits to the 
changelog). Any objections from anyone?

Note, should any other, real hardware show problems with , we might 
still have to consider reverting the original change in 2759c32. 
It's borderline.

Btw., the code is still not fully clean. For example this bit in 
generic_identify():

#ifdef CONFIG_X86_32
# ifdef CONFIG_X86_HT
                c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
# else
                c->apicid = c->initial_apicid;
# endif
#endif

and in another place we have:

#ifdef CONFIG_X86_64
        c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
#endif

This ifdeffery could probably be removed and we could call 
->phys_pkg_id() all the time, right?

	Ingo
