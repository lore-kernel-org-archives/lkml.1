Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZBDFKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZBDFKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBDFKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:10:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbZBDFKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:10:03 -0500
Date: Tue, 3 Feb 2009 21:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Renninger <trenn@suse.de>
Cc: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] CPUFREQ: powernow-k8: Only print error message
 once, not per core.
Message-Id: <20090203210947.49fc5933.akpm@linux-foundation.org>
In-Reply-To: <1233679606-1971-7-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
	<1233679606-1971-7-git-send-email-trenn@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Feb 2009 17:46:45 +0100 Thomas Renninger <trenn@suse.de> wrote:

> This is the typical message you get if you plug in a CPU
> which is newer than your BIOS. It's annoying seeing this
> message for each core.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 9accffb..9e312c5 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -743,7 +743,7 @@ static int find_psb_table(struct powernow_k8_data *data)
>  	 * BIOS and Kernel Developer's Guide, which is available on
>  	 * www.amd.com
>  	 */
> -	printk(KERN_ERR PFX "BIOS error - no PSB or ACPI _PSS objects\n");
> +	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
>  	return -ENODEV;
>  }
>  
> @@ -1154,11 +1154,11 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
>  		 * an UP version, and is deprecated by AMD.
>  		 */
>  		if (num_online_cpus() != 1) {
> -			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
> -			       " ACPI _PSS objects in a way that Linux "
> -			       "understands. Please report this to the Linux "
> -			       "ACPI maintainers and complain to your BIOS "
> -			       "vendor.\n");
> +			WARN_ONCE(1, KERN_ERR FW_BUG PFX "Your BIOS does not "
> +				  "provide ACPI _PSS objects in a way that "
> +				  "Linux understands. Please report this to "
> +				  "the Linux ACPI maintainers and complain to "
> +				  "your BIOS vendor.\n");
>  			goto err_out;
>  		}
>  		if (pol->cpu != 0) {

WARN_ONCE will also spew a stack backtrace, which seems inappropriate here.

There was talk of writing a simple ONCE() macro for this sort of thing:

	if (ONCE())
		printk(...)

but it never happened.
