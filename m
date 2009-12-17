Return-Path: <linux-kernel-owner+w=401wt.eu-S965498AbZLQTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498AbZLQTlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbZLQTly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:41:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51310 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482AbZLQTlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=avFsCPYcc6E3E0gf0ZkYcVl7wHPgQxX8hFRZdBQSnlt6IHRdR7wG9k/Sjbr62bA9ml
         uH5whr41bGJEdu3diB1kSsHObFAd67YysLFo+9ll0snOZRZ51b8sA6Nmfg5Zk7zfkRyC
         qF+3GtBe1i1xzEXVhSCobvMLWAzw4EUWD18fM=
Date: Thu, 17 Dec 2009 22:41:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
	setup
Message-ID: <20091217194148.GB5414@lenovo>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:59:23AM -0800, Pan, Jacob jun wrote:
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 17 Dec 2009 08:07:57 -0800
> Subject: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup
> 
> Global clockevent is needed to calibrate local apic timer.
> This patch makes sure we have a valid global clockevent prior
> to lapic timer setup.
> Non-pc x86 mid platform with per cpu platform timer may not
> have a global clockevent device.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index aa57c07..7e7aee1 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -724,6 +724,13 @@ static int __init calibrate_APIC_clock(void)
>   */
>  void __init setup_boot_APIC_clock(void)
>  {
> +	/* global clockevent is needed for calibration */
> +	if (!global_clock_event) {
> +		apic_printk(APIC_DEBUG,
> +				"no global clockevent for calibration\n");
> +		return;
> +	}
> +
>  	/*
>  	 * The local apic timer can be disabled via the kernel
>  	 * commandline or from the CPU detection code. Register the lapic
> -- 
> 1.6.5.3
>

Hi Jacob,

Wouldn't be better to operate the same way as in case of "noapictimer"
boot option. I guess the non-pc x86 midplatforms you're mentioning
do not use SMP ever but just to be consistent in code.

Perhaps something like:

void __init setup_boot_APIC_clock(void) {

	if (!global_clock_event) {
		pr_info("No global clockevent for calibration\n");
		disable_apic_timer = 1;
	}

	if (disable_apic_timer) {
		pr_info("Disabling APIC timer\n");
		/* No broadcast on UP ! */
		if (num_possible_cpus() > 1) {
			lapic_clockevent.mult = 1;
			setup_APIC_timer();
		}
		return;
	}

	...
}

Or I miss something?

	-- Cyrill
