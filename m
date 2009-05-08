Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbZEHJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbZEHJ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZEHJ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:59:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbZEHJ7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:59:01 -0400
Date: Fri, 8 May 2009 11:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090508095748.GH3559@elte.hu>
References: <4A03B9C3.9090607@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03B9C3.9090607@intel.com>
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


* Joseph Cihula <joseph.cihula@intel.com> wrote:

> +	/* if we're being called before the 1:1 mapping is set up then just
> +	   return and let the normal shutdown happen; this should only be
> +	   due to very early panic() */
> +	if (!tboot_pg_dir)
> +		return;

Please use the customary comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

specified in Documentation/CodingStyle. Please fix this in all other 
multi-line comments in your patch as well.


> +	if (shutdown_type == TB_SHUTDOWN_S3) {
> +		tboot_shared->num_mac_regions = 3;
> +		/* S3 resume code */
> +		tboot_shared->mac_regions[0].start =
> +			PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
> +		tboot_shared->mac_regions[0].size =
> +			PFN_UP(WAKEUP_SIZE) << PAGE_SHIFT;
> +		/* AP trampoline code */
> +		tboot_shared->mac_regions[1].start =
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(trampoline_base)));
> +		tboot_shared->mac_regions[1].size =
> +			PFN_UP(TRAMPOLINE_SIZE) << PAGE_SHIFT;
> +		/* kernel code + data + bss */
> +		tboot_shared->mac_regions[2].start =
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> +		tboot_shared->mac_regions[2].size =
> +			PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
> +			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> +	}
> +
> +	tboot_shared->shutdown_type = shutdown_type;
> +
> +	switch_to_tboot_pt();
> +
> +	((void(*)(void))(unsigned long)tboot_shared->shutdown_entry)();

shutdown_entry should probably have a proper function pointer type, 
to avoid this ugliness.

	Ingo
