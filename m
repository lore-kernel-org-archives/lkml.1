Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbXHHP4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbXHHP4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbXHHP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:56:23 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:15772 "EHLO
	outbound5-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761235AbXHHP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:56:21 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Yinghai Lu" <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error
 vector.
Date: Wed, 8 Aug 2007 17:31:23 +0200
User-Agent: KMail/1.9.7
cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200708071319.35423.yinghai.lu@sun.com>
In-Reply-To: <200708071319.35423.yinghai.lu@sun.com>
MIME-Version: 1.0
Message-ID: <200708081731.24106.joachim.deguara@amd.com>
X-OriginalArrivalTime: 08 Aug 2007 15:31:25.0632 (UTC)
 FILETIME=[2E95F400:01C7D9D1]
X-WSS-ID: 6AA73E5AR0G4687961-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007 22:19:35 Yinghai Lu wrote:
> [PATCH] x86_64: clear IO_APIC before enabing apic error vector.
>
> some apic id lifting system: 4 socket quad core, 8 socket quad core will do
> apic id lifting for BSP.
>
> but io-apic regs for ExtINT still use 0 as dest.

good catch!

> diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
> index 900ff38..a2ae138 100644
> --- a/arch/x86_64/kernel/apic.c
> +++ b/arch/x86_64/kernel/apic.c
> @@ -436,6 +436,14 @@ void __cpuinit setup_local_APIC (void)
>  		value = APIC_DM_NMI | APIC_LVT_MASKED;
>  	apic_write(APIC_LVT1, value);
>
> +	/*
> +	 * Now enable IO-APICs, actually call clear_IO_APIC
> +	 * We need clear_IO_APIC before enabling vector on BP
> +	 */
> +	if (!smp_processor_id())
> +	if (!skip_ioapic_setup && nr_ioapics)
> +		enable_IO_APIC();

Surely you meant something prettier like
+	if (!smp_processor_id() && !skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();

-Joachim


