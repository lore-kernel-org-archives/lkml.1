Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYCYNnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYCYNnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYCYNno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:43:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbYCYNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:43:43 -0400
Message-ID: <47E90149.5040506@redhat.com>
Date: Tue, 25 Mar 2008 10:42:33 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat <12059477792893-git-send-email-gcosta@redhat.com> <alpine.SOC.1.00.0803201016540.12075@piorun> <47E27D08.9050809@redhat.com> <alpine.SOC.1.00.0803202125520.21415@piorun> <47E7C00B.5000503@redhat.com> <alpine.SOC.1.00.0803241608310.12757@piorun>
In-Reply-To: <alpine.SOC.1.00.0803241608310.12757@piorun>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>> is inherited from x86_64, we call do_boot_cpu with irqs clearly enabled, and
>> check esr in the process.
> 
>  Please note that ESR may hold some leftover state from whatever happened 
> before Linux has taken control, so it is reasonable and I think actually 
> recommended by Intel (FWIW) to clear the register before enabling the 
> error interrupt.  For how to clear the ESR properly, please see 
> setup_local_APIC() -- subtle differences and errata in various APIC 
> implementations have made it more complicated than necessary, sigh...
which excerpt specifically are you talking about ?
the only ESR mention I see in setup_local_APIC() is this:

          /* Pound the ESR really hard over the head with a big hammer - 
mbligh */
         if (esr_disable) {
                 apic_write(APIC_ESR, 0);
                 apic_write(APIC_ESR, 0);
                 apic_write(APIC_ESR, 0);
                 apic_write(APIC_ESR, 0);
         }
which seems more like a disablement.

the bootup code does clean it, tough, by writing and reading the ESR.

>> But I can understand from the spec you posted that this is clearly an error.
>> So I'd have better come up with a new solution from this
> 
>  Well, with CONFIG_X86_GOOD_APIC set there is no RMW access to the ESR as 
> apic_write_around() expands to apic_write().  And the option is meant to 
> be clear only for the original integrated APIC as included in the Pentium 
> processor ("Pentium-Classic" in the Kconfig nomenclature).  I have no 
> means to test such a system, but I still have a working dual-Pentium-MMX 
> machine, which features local APICs that should be the same modulo errata.  
> I may check and see whether a RMW cycle to the ESR triggers any problems 
> with this computer, but the box is currently at the other end of the 
> continent, so it will take a while.
> 
>  I have asked this question already: what kind of CPU are you running on?  
> Do you really need to have CONFIG_X86_GOOD_APIC clear with it?
> 
My testings that triggered that were with qemu, with randconfigs. 
Probably it has a good apic, but it is good that it triggered anyway. 
Otherwise I'd never see it.

