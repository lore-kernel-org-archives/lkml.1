Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZDNQcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZDNQcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZDNQby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:31:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:31166 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZDNQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u8mvPKAVEoxIWK9tOFgub9N2Hw8LgvyYETG4hNLhZnRx1HjphOc4xUu8zueIBy4ehE
         IzgZiAJakMfBw5o6PvRmTMJMN/GqZAI1Nf9lqZIEKmKgZf8L6l/mLdJ1JXKmusRDr9Wz
         pnXOabmXBupYB2z76O89fSVvojHz+I/DXeu8w=
Date: Tue, 14 Apr 2009 20:31:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/14] [VOYAGER] x86: add {safe,hard}_smp_processor_id
	to smp_ops
Message-ID: <20090414163143.GB12888@lenovo>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James Bottomley - Tue, Apr 14, 2009 at 10:51:27AM -0500]
| Not having apics, Voyager can't use the default apic implementation of
| these, it has to read from a special port in the VIC to get the
| processor ID, so abstract these functions in smp_ops to allow voyager
| to live simultaneously with the apic code.
| 
| Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
| ---
|  arch/x86/include/asm/smp.h  |   13 +++++++++++--
|  arch/x86/kernel/apic/apic.c |    5 -----
|  arch/x86/kernel/apic/ipi.c  |    2 +-
|  arch/x86/kernel/smp.c       |    7 +++++++
|  arch/x86/xen/smp.c          |    7 +++++++
|  5 files changed, 26 insertions(+), 8 deletions(-)
| 
| diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
| index 19e0d88..aac866f 100644
| --- a/arch/x86/include/asm/smp.h
| +++ b/arch/x86/include/asm/smp.h
| @@ -60,6 +60,8 @@ struct smp_ops {
|  
|  	void (*send_call_func_ipi)(const struct cpumask *mask);
|  	void (*send_call_func_single_ipi)(int cpu);
| +	int (*hard_smp_processor_id)(void);
| +	int (*safe_smp_processor_id)(void);
|  };
|  
|  /* Globals due to paravirt */
| @@ -159,7 +161,11 @@ extern unsigned disabled_cpus __cpuinitdata;
|   * so this is correct in the x86 case.
|   */
|  #define raw_smp_processor_id() (percpu_read(cpu_number))
| -extern int safe_smp_processor_id(void);
| +int apic_safe_smp_processor_id(void);
| +static inline int safe_smp_processor_id(void)
| +{
| +	return smp_ops.safe_smp_processor_id();
| +}
|  
|  #elif defined(CONFIG_X86_64_SMP)
|  #define raw_smp_processor_id() (percpu_read(cpu_number))
| @@ -185,7 +191,10 @@ static inline int logical_smp_processor_id(void)
|  
|  #endif
|  
| -extern int hard_smp_processor_id(void);
| +static inline int hard_smp_processor_id(void)
| +{
| +	return smp_ops.hard_smp_processor_id();
| +}
|  

Hi James, wouldn't it break summit32 platform?
This snippet from summit_32.c

static void summit_init_apic_ldr(void)
{
	unsigned long val, id;
	int count = 0;
--->	u8 my_id = (u8)hard_smp_processor_id();
	u8 my_cluster = APIC_CLUSTER(my_id);

if we have CONFIG_SMP _not_ set smp_ops.hard_smp_processor_id
would be plain NULL deref (or linker warning)? I could be missing something...
 
        Cyrill
