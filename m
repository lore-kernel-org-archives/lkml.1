Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXG0AMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXG0AMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXG0AMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:12:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754959AbXG0AMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:12:39 -0400
Date: Thu, 26 Jul 2007 17:12:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix uninitialized local variable "covered" in i386
 acpi-cpufreq driver
Message-Id: <20070726171222.4459155a.akpm@linux-foundation.org>
In-Reply-To: <20070726234630.GA29288@linux-os.sc.intel.com>
References: <1181754124.6148.37.camel@localhost>
	<20070726234630.GA29288@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 16:46:30 -0700 Fenghua Yu <fenghua.yu@intel.com> wrote:

> The local variable "covered" is used without initialization in i386 acpi-cpufreq
> driver. The initial value of covered should be 0. The bug will cause memory leak
> when hit. The following patch fixes this bug.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
> 
>  arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 6f846be..bfb4959 100644
> --- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -511,7 +511,7 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
>  static int acpi_cpufreq_early_init(void)
>  {
>  	struct acpi_processor_performance *data;
> -	cpumask_t covered;
> +	cpumask_t covered=0;
>  	unsigned int i, j;
>  
>  	dprintk("acpi_cpufreq_early_init\n");

- please put spaces around "="

- that should have been CPU_MASK_NONE

- that code's way overengineered.  This:

--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~a
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -511,7 +511,6 @@ acpi_cpufreq_guess_freq(struct acpi_cpuf
 static int acpi_cpufreq_early_init(void)
 {
 	struct acpi_processor_performance *data;
-	cpumask_t covered;
 	unsigned int i, j;
 
 	dprintk("acpi_cpufreq_early_init\n");
@@ -520,14 +519,13 @@ static int acpi_cpufreq_early_init(void)
 		data = kzalloc(sizeof(struct acpi_processor_performance),
 			       GFP_KERNEL);
 		if (!data) {
-			for_each_cpu_mask(j, covered) {
+			for_each_possible_cpu(j) {
 				kfree(acpi_perf_data[j]);
 				acpi_perf_data[j] = NULL;
 			}
 			return -ENOMEM;
 		}
 		acpi_perf_data[i] = data;
-		cpu_set(i, covered);
 	}
 
 	/* Do initialization in ACPI core */
_

should do the trick (please check it)

- what we have here is an open-coded alloc_percpu().  Hows about
  converting it to alloc_percpu()?

- that function should have been be __init.


How's that for a one-liner? ;)
