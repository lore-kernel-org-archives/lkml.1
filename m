Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZBSWoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZBSWoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:44:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZBSWnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:43:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbZBSWnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:43:52 -0500
Message-ID: <499DE05A.40804@kernel.org>
Date: Thu, 19 Feb 2009 14:42:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu>
In-Reply-To: <1235081612.14523.23.camel@vayu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, 2009-02-19 at 13:50 -0800, Yinghai Lu wrote:
>> Impact: fix bug.
>>
>> otherwise will get panic from early_acpi_boot_init()
>> also make disable_x2apic global, so could use it it x2_apic_xxx.c
>> and can get warning if preenabled system using nox2apic.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/apic/apic.c           |    3 +--
>>  arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
>>  arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
>>  arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
>>  drivers/pci/dmar.c                    |    3 ++-
>>  5 files changed, 14 insertions(+), 6 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
>> +++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
>> @@ -14,8 +14,11 @@ DEFINE_PER_CPU(u32, x86_cpu_to_logical_a
>>
>>  static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>>  {
>> -       if (cpu_has_x2apic)
>> +       if (cpu_has_x2apic && !disable_x2apic) {
>> +               x2apic = 1;
>> +               enable_x2apic();
> 
> Yinghai, I also ran into couple of x2apic issues on the latest tip and
> this issue is one of them. I don't like this patch mainly because we are
> enabling x2apic mode in the cpu, with out checking the intr-remapping
> support. We should fall back to xapic mode (in a clean fashion) if there
> is any issue with intr-remapping. So I am planning to post another patch
> to fix this early hang issue that we both encountered.

Ingo want to decouple that x2apic and intr_remapping.
it seems it does work with x2apic without intr_remapping in one of setup.

YH
