Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDNRKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDNRKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZDNRJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:09:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:15132 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r0hznpkRWDovlEM0VZTQGuzB+QTENECrnIBs+HI4KoV8LyV+573/Ucuw8keoIBtCXf
         RrU0PG3paWgrLd0y86JmZA8tH/XWdkYEOsMFq0HFuVrAcZ7wE3NIdqo9okoVJyJ43PHW
         viAX08/zJs4N09PBqP+HJUKxgtFV7uLHxjXEU=
Date: Tue, 14 Apr 2009 21:09:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 10/14] [VOYAGER] x86: make disabling the apics
	functional instead of a flag
Message-ID: <20090414170942.GC12888@lenovo>
References: <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James Bottomley - Tue, Apr 14, 2009 at 10:51:36AM -0500]
| This allows the elimination of some ifdef guards in setup.c.
| Additionally probe_32.c doesn't need to run through the apics in
| generic_apic_probe() if they're disabled.
| 
| Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
| ---
|  arch/x86/include/asm/apic.h     |    6 ++++++
|  arch/x86/kernel/apic/apic.c     |    3 +++
|  arch/x86/kernel/apic/probe_32.c |    3 +++
|  arch/x86/kernel/setup.c         |    4 +---
|  4 files changed, 13 insertions(+), 3 deletions(-)
| 
| diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
| index 42f2f83..391c464 100644
| --- a/arch/x86/include/asm/apic.h
| +++ b/arch/x86/include/asm/apic.h
| @@ -246,12 +246,18 @@ static inline int apic_is_clustered_box(void)
|  extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
|  extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
|  
| +static inline void disable_APIC(void)
| +{
| +	disable_local_APIC();
| +	disable_apic = 1;
| +}
|  
|  #else /* !CONFIG_X86_LOCAL_APIC */
|  static inline void lapic_shutdown(void) { }
|  #define local_apic_timer_c2_ok		1
|  static inline void init_apic_mappings(void) { }
|  static inline void disable_local_APIC(void) { }
| +static inline void disable_APIC(void) { }
|  
|  #endif /* !CONFIG_X86_LOCAL_APIC */
|  
| diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| index f9e830e..aa96dbe 100644
| --- a/arch/x86/kernel/apic/apic.c
| +++ b/arch/x86/kernel/apic/apic.c
| @@ -1539,6 +1539,9 @@ void __init early_init_lapic_mapping(void)
|   */
|  void __init init_apic_mappings(void)
|  {
| +	if (disable_apic)
| +		return;
| +

No, we shouldn't do that without additional
code review (otherwise we will loose mapping for fake apic page).
And I suspect we get NULL deref on reboot procedure
if kernel was compiled _with_ SMP support but APIC disabled
by kernel option. hmm, can't find this reference in LKML.
I was telling Ingo about my suspicious on smp operations
when APIC is disabled by option and we're safe _only_ 'cause
we have fake mapping page reserved. For example call of
smp_send_stop() in kernel/panic.c if kernel was compiled _with_ SMP
support and then APIC disabled by kernel option.

|  	if (x2apic) {
|  		boot_cpu_physical_apicid = read_apic_id();
|  		return;
| diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
| index 01eda2a..049d7a0 100644
| --- a/arch/x86/kernel/apic/probe_32.c
| +++ b/arch/x86/kernel/apic/probe_32.c
| @@ -226,6 +226,9 @@ void __init generic_bigsmp_probe(void)
|  
|  void __init generic_apic_probe(void)
|  {
| +	if (disable_apic)
| +		return;
| +

Look suspicious too, sorry. If kernel compiled with local apic
set we rely on apic read ops regardless if apic facility
has been disabled by option or not.

I could be missing something /which has quite a high probability magnitude/.
Yinghai help needed :) CC'ed

|  	if (!cmdline_apic) {
|  		int i;
|  		for (i = 0; apic_probe[i]; i++) {
| diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
| index bee0914..13779e2 100644
| --- a/arch/x86/kernel/setup.c
| +++ b/arch/x86/kernel/setup.c
| @@ -770,9 +770,7 @@ void __init setup_arch(char **cmdline_p)
|  	reserve_early_setup_data();
|  
|  	if (acpi_mps_check()) {
| -#ifdef CONFIG_X86_LOCAL_APIC
| -		disable_apic = 1;
| -#endif
| +		disable_APIC();
|  		setup_clear_cpu_cap(X86_FEATURE_APIC);
|  	}
|  
| -- 
| 1.6.2.1
| 

        Cyrill
