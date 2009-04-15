Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZDOONU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZDOONU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZDOOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:12:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:34725 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbZDOOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=COhqFFG2/S37KgaTAoM8V2HcNy1s2hYHBM0n52kjS/VAW07jndm20VvuHRJ7VJ4qxK
         l05woUWy60JYAxeCOQEloNZWkfrAIzXq/j9aQdhVghuiQQXWBdRJxIb2818ZZ/DBeH+p
         m8O7LzCqM5hboju7HIN/CAdAfr3WkC67126yg=
Date: Wed, 15 Apr 2009 18:12:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 10/14] [VOYAGER] x86: make disabling the apics
	functional instead of a flag
Message-ID: <20090415141251.GA10433@lenovo>
References: <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com> <20090414170942.GC12888@lenovo> <20090414174427.GA24578@lenovo> <1239799869.3371.3.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239799869.3371.3.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James Bottomley - Wed, Apr 15, 2009 at 12:51:09PM +0000]
| On Tue, 2009-04-14 at 21:44 +0400, Cyrill Gorcunov wrote:
| > [Cyrill Gorcunov - Tue, Apr 14, 2009 at 09:09:42PM +0400]
| > ...
| > | | diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| > | | index f9e830e..aa96dbe 100644
| > | | --- a/arch/x86/kernel/apic/apic.c
| > | | +++ b/arch/x86/kernel/apic/apic.c
| > | | @@ -1539,6 +1539,9 @@ void __init early_init_lapic_mapping(void)
| > | |   */
| > | |  void __init init_apic_mappings(void)
| > | |  {
| > | | +	if (disable_apic)
| > | | +		return;
| > | | +
| > | 
| > | No, we shouldn't do that without additional
| > | code review (otherwise we will loose mapping for fake apic page).
| > | And I suspect we get NULL deref on reboot procedure
| > | if kernel was compiled _with_ SMP support but APIC disabled
| > | by kernel option. hmm, can't find this reference in LKML.
| > | I was telling Ingo about my suspicious on smp operations
| > | when APIC is disabled by option and we're safe _only_ 'cause
| > | we have fake mapping page reserved. For example call of
| > | smp_send_stop() in kernel/panic.c if kernel was compiled _with_ SMP
| > | support and then APIC disabled by kernel option.
| > | 
| > | |  	if (x2apic) {
| > | |  		boot_cpu_physical_apicid = read_apic_id();
| > | |  		return;
| > ...
| > 
| > Ah, I found that link -- http://lkml.org/lkml/2009/4/12/139
| > I've promised to take a look, unfortunately out of time now.
| > Maybe a bit later.
| 
| Hmm, well, looking at this, I think there are two points
| 
| The first is that disable_apic should really mean that: It is a
| dangerous option; there are modern CPUs that can't deliver interrupts
| without apics and if you have one and disable it, there's no way of
| preventing the hang that follows (because you can't even get timer
| interrupts).

Even having APIC (local or discrete) cpu (well, not cpu itself but
chipset logic rather) is to provide backward compatibility via 8259(a)
(or familiar one) controller for ExtInt or VirtualWire modes I believe.
Though to be fair I don't have most modern cpus like Core i7 under the
hands to check this. We're talking about x86 family right?

| 
| Secondly, I can fix your original emailed problem by having a check for
| disable_apic in the shutdown path on disable_local_apic() ... I think
| that fixes everything?

Yes, it should do the trick. Though there could be other ways
to hang on SMP+APIC compiled kernel with disable_apic passed
I guess :) But testing should reveal the screwed pathes.

| 
| James
| 
| 
        Cyrill
