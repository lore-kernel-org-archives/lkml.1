Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYGOSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYGOSKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOSKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:10:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:51087 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYGOSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lGZHmz6uiOHUZNcT97uNwhb+VMNp0mcnD436OGwa+wM9UTpRjWovrApRLq+lxnmfJ/
         24tTGAF0dOV9LCbZvll+sbubxTqzKxMH1ObaQ2D6cxa07e4pxdLv+d+artOpbbV6RqKL
         5DaZgHT78wo3kFrVM5WRZcbp8XDHDCEzzhL7Q=
Message-ID: <86802c440807151110vf814830r9bf0e9d50f559e1d@mail.gmail.com>
Date: Tue, 15 Jul 2008 11:10:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080715173318.GA18203@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807102038.26591.yhlu.kernel@gmail.com>
	 <200807111841.55403.yhlu.kernel@gmail.com>
	 <200807132219.35814.yhlu.kernel@gmail.com>
	 <20080715173318.GA18203@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 10:33 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Sun, Jul 13, 2008 at 10:19:35PM -0700, Yinghai Lu wrote:
>>
>> fix for pv.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/kernel/paravirt.c |    5 ----
>>  arch/x86/kernel/vmi_32.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
>>  arch/x86/xen/enlighten.c   |   19 +++++++---------
>>  include/asm-x86/paravirt.h |   29 -------------------------
>>  4 files changed, 57 insertions(+), 47 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/paravirt.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/paravirt.c
>> +++ linux-2.6/arch/x86/kernel/paravirt.c
>> @@ -373,11 +373,6 @@ struct pv_cpu_ops pv_cpu_ops = {
>>
>>  struct pv_apic_ops pv_apic_ops = {
>>  #ifdef CONFIG_X86_LOCAL_APIC
>> -#ifndef CONFIG_X86_64
>> -       .apic_write = native_apic_mem_write,
>> -       .apic_write_atomic = native_apic_mem_write_atomic,
>> -       .apic_read = native_apic_mem_read,
>> -#endif
>>         .setup_boot_clock = setup_boot_APIC_clock,
>>         .setup_secondary_clock = setup_secondary_APIC_clock,
>>         .startup_ipi_hook = paravirt_nop,
>> Index: linux-2.6/arch/x86/kernel/vmi_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/vmi_32.c
>> +++ linux-2.6/arch/x86/kernel/vmi_32.c
>> @@ -676,6 +676,50 @@ static inline int __init probe_vmi_rom(v
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_X86_LOCAL_APIC
>> +static u32 vmi_apic_read(u32 reg)
>> +{
>> +       return 0;
>> +}
>> +
>> +static void vmi_apic_write(u32 reg, u32 val)
>> +{
>> +       /* Warn to see if there's any stray references */
>> +       WARN_ON(1);
>> +}
>> +
>> +static u64 vmi_apic_icr_read(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static void vmi_apic_icr_write(u32 low, u32 id)
>> +{
>> +       /* Warn to see if there's any stray references */
>> +       WARN_ON(1);
>> +}
>> +
>> +static void vmi_apic_wait_icr_idle(void)
>> +{
>> +       return;
>> +}
>> +
>> +static u32 vmi_safe_apic_wait_icr_idle(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static struct apic_ops vmi_basic_apic_ops = {
>> +        .read = vmi_apic_read,
>> +        .write = vmi_apic_write,
>> +        .write_atomic = vmi_apic_write,
>> +        .icr_read = vmi_apic_icr_read,
>> +        .icr_write = vmi_apic_icr_write,
>> +        .wait_icr_idle = vmi_apic_wait_icr_idle,
>> +        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
>> +};
>> +#endif
>> +
>>  /*
>>   * VMI setup common to all processors
>>   */
>> @@ -904,9 +948,10 @@ static inline int __init activate_vmi(vo
>>  #endif
>>
>>  #ifdef CONFIG_X86_LOCAL_APIC
>> -       para_fill(pv_apic_ops.apic_read, APICRead);
>> -       para_fill(pv_apic_ops.apic_write, APICWrite);
>> -       para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
>> +       para_fill(vmi_basic_apic_ops.read, APICRead);
>> +       para_fill(vmi_basic_apic_ops.write, APICWrite);
>> +       para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
>> +       apic_ops = &vmi_basic_apic_ops;
>
> Yinghai, Looking more closely at this, based on my understanding this might be
> wrong for VMI. Correct patch should be as follows. Any comments?

so you mean icr related will still use default native member?

YH
