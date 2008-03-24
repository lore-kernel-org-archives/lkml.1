Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYCXXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYCXXTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYCXXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:19:20 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33193 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYCXXTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:19:20 -0400
Date: Mon, 24 Mar 2008 23:19:13 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
X-X-Sender: macro@piorun
To: Glauber Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
In-Reply-To: <47E7C00B.5000503@redhat.com>
Message-ID: <alpine.SOC.1.00.0803241608310.12757@piorun>
References: <12059475744092-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com>
 <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com>
 <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
 <12059477792893-git-send-email-gcosta@redhat.com> <alpine.SOC.1.00.0803201016540.12075@piorun> <47E27D08.9050809@redhat.com> <alpine.SOC.1.00.0803202125520.21415@piorun> <47E7C00B.5000503@redhat.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Glauber Costa wrote:

> I see bit 7 - Illegal Register Address being set.

 Hmm, it looks like the only one to be reasonably set under these 
conditions, but I have never seen it reported for a read cycle to the EOI 
register anyway, so I suppose it has to be a relatively recent addition.

> I believe the reason we never saw it, is that the ESR register is not checked
> that often when interrupts are enabled. In the new bootup state machine, that

 Well, as I wrote, the error interrupt handler is always enabled, 
reporting the state recorded in the ESR register as soon as an error 
condition triggers and if an RMW cycle was a problem before, we would have 
seen a flood of reports from people -- like we indeed have many times for 
inter-APIC bus data corruption that triggers the same event (using bits 
3:0 in the ESR as relevant).

> is inherited from x86_64, we call do_boot_cpu with irqs clearly enabled, and
> check esr in the process.

 Please note that ESR may hold some leftover state from whatever happened 
before Linux has taken control, so it is reasonable and I think actually 
recommended by Intel (FWIW) to clear the register before enabling the 
error interrupt.  For how to clear the ESR properly, please see 
setup_local_APIC() -- subtle differences and errata in various APIC 
implementations have made it more complicated than necessary, sigh...

> But I can understand from the spec you posted that this is clearly an error.
> So I'd have better come up with a new solution from this

 Well, with CONFIG_X86_GOOD_APIC set there is no RMW access to the ESR as 
apic_write_around() expands to apic_write().  And the option is meant to 
be clear only for the original integrated APIC as included in the Pentium 
processor ("Pentium-Classic" in the Kconfig nomenclature).  I have no 
means to test such a system, but I still have a working dual-Pentium-MMX 
machine, which features local APICs that should be the same modulo errata.  
I may check and see whether a RMW cycle to the ESR triggers any problems 
with this computer, but the box is currently at the other end of the 
continent, so it will take a while.

 I have asked this question already: what kind of CPU are you running on?  
Do you really need to have CONFIG_X86_GOOD_APIC clear with it?

  Maciej
