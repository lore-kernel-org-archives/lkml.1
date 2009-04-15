Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZDOMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZDOMvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbZDOMvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:51:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52210 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759033AbZDOMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:51:09 -0400
Subject: Re: [PATCH 10/14] [VOYAGER] x86: make disabling the apics
	functional instead of a flag
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20090414174427.GA24578@lenovo>
References: <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090414170942.GC12888@lenovo>  <20090414174427.GA24578@lenovo>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 12:51:09 +0000
Message-Id: <1239799869.3371.3.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 21:44 +0400, Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Tue, Apr 14, 2009 at 09:09:42PM +0400]
> ...
> | | diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> | | index f9e830e..aa96dbe 100644
> | | --- a/arch/x86/kernel/apic/apic.c
> | | +++ b/arch/x86/kernel/apic/apic.c
> | | @@ -1539,6 +1539,9 @@ void __init early_init_lapic_mapping(void)
> | |   */
> | |  void __init init_apic_mappings(void)
> | |  {
> | | +	if (disable_apic)
> | | +		return;
> | | +
> | 
> | No, we shouldn't do that without additional
> | code review (otherwise we will loose mapping for fake apic page).
> | And I suspect we get NULL deref on reboot procedure
> | if kernel was compiled _with_ SMP support but APIC disabled
> | by kernel option. hmm, can't find this reference in LKML.
> | I was telling Ingo about my suspicious on smp operations
> | when APIC is disabled by option and we're safe _only_ 'cause
> | we have fake mapping page reserved. For example call of
> | smp_send_stop() in kernel/panic.c if kernel was compiled _with_ SMP
> | support and then APIC disabled by kernel option.
> | 
> | |  	if (x2apic) {
> | |  		boot_cpu_physical_apicid = read_apic_id();
> | |  		return;
> ...
> 
> Ah, I found that link -- http://lkml.org/lkml/2009/4/12/139
> I've promised to take a look, unfortunately out of time now.
> Maybe a bit later.

Hmm, well, looking at this, I think there are two points

The first is that disable_apic should really mean that: It is a
dangerous option; there are modern CPUs that can't deliver interrupts
without apics and if you have one and disable it, there's no way of
preventing the hang that follows (because you can't even get timer
interrupts).

Secondly, I can fix your original emailed problem by having a check for
disable_apic in the shutdown path on disable_local_apic() ... I think
that fixes everything?

James


