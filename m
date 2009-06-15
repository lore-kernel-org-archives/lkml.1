Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbZFOKv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbZFOKv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZFOKvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:51:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47332 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFOKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:51:18 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <4A329CF8.4050502@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Jun 2009 03:51:17 -0700
In-Reply-To: <4A329CF8.4050502@goop.org> (Jeremy Fitzhardinge's message of "Fri\, 12 Jun 2009 11\:22\:48 -0700")
Message-ID: <m18wjtbwii.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Parse the ACPI MADT for I/O APIC information, even if the cpu has no
> (apparent) local APIC (ie, the CPU's APIC feature flag is clear).
>
> In principle, the local APIC and the I/O APIC are distinct (but related)
> components, which can be independently present.
>
> In practice this can happen in a Xen system, where the hypervisor has
> full control over the local APICs, and delivers interrupts initiated by
> the I/O APICs via Xen's event channel mechanism.
>
> (This eliminates the need for any explicit if (xen...) tests in
> acpi/boot.c)
>
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>

To be very clear.  We have mechanism and policy mixed in the mptable
and related code today.  While we continue to have that mixed I think
even attempting to reuse it for Xen dom0 is a horrifically bad move.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 2410469..19d13e5 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -193,9 +193,6 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
>  {
>  	struct acpi_table_madt *madt = NULL;
>
> -	if (!cpu_has_apic)
> -		return -EINVAL;
> -
>  	madt = (struct acpi_table_madt *)table;
>  	if (!madt) {
>  		printk(KERN_WARNING PREFIX "Unable to map MADT\n");
> @@ -1252,9 +1249,6 @@ static int __init acpi_parse_madt_ioapic_entries(void)
>  	if (acpi_disabled || acpi_noirq)
>  		return -ENODEV;
>
> -	if (!cpu_has_apic)
> -		return -ENODEV;
> -
>  	/*
>  	 * if "noapic" boot option, don't look for IO-APICs
>  	 */
> @@ -1357,6 +1351,16 @@ static void __init acpi_process_madt(void)
>  #ifdef CONFIG_X86_BIGSMP
>  			generic_bigsmp_probe();
>  #endif
> +		}
> +		if (error == -EINVAL) {
> +			/*
> +			 * The ACPI tables themselves were malformed.
> +			 * Dell Precision Workstation 410, 610 come here.
> +			 */
> +			printk(KERN_ERR PREFIX
> +			       "Invalid BIOS MADT, disabling ACPI\n");
> +			disable_acpi();
> +		} else {
>  			/*
>  			 * Parse MADT IO-APIC entries
>  			 */
> @@ -1370,14 +1374,6 @@ static void __init acpi_process_madt(void)
>  					apic->setup_apic_routing();
>  			}
>  		}
> -		if (error == -EINVAL) {
> -			/*
> -			 * Dell Precision Workstation 410, 610 come here.
> -			 */
> -			printk(KERN_ERR PREFIX
> -			       "Invalid BIOS MADT, disabling ACPI\n");
> -			disable_acpi();
> -		}
>  	} else {
>  		/*
>   		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index c6acce2..d5e3f03 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1807,6 +1807,10 @@ __apicdebuginit(void) print_all_local_APICs(void)
>  {
>  	int cpu;
>
> +	/* don't print out if apic is not there */
> +	if (!cpu_has_apic)
> +		return;
> +
>  	preempt_disable();
>  	for_each_online_cpu(cpu)
>  		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
> @@ -1849,8 +1853,7 @@ __apicdebuginit(int) print_all_ICs(void)
>  {
>  	print_PIC();
>
> -	/* don't print out if apic is not there */
> -	if (!cpu_has_apic || disable_apic)
> +	if (disable_apic)
>  		return 0;
>
>  	print_all_local_APICs();
