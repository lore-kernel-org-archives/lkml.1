Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYCTW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYCTW17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYCTW1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:27:42 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:56385 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbYCTW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:27:40 -0400
Date: Thu, 20 Mar 2008 22:27:31 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
X-X-Sender: macro@piorun
To: Glauber Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
In-Reply-To: <47E27D08.9050809@redhat.com>
Message-ID: <alpine.SOC.1.00.0803202125520.21415@piorun>
References: <12059475744092-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com>
 <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com>
 <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com>
 <12059477561937-git-send-email-gcosta@redhat <12059477792893-git-send-email-gcosta@redhat.com> <alpine.SOC.1.00.0803201016540.12075@piorun> <47E27D08.9050809@redhat.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Glauber Costa wrote:

> >  Are you sure this actually triggers for APIC chips affected by the erratum
> > in question?  And please note that for them the effect of two consecutive
> > writes will be much more disastrous than setting a bit in the ESR register.
> 
> I'm not _sure_, but I can't find anything in the errata list that states
> otherwise. It would be great that anyone has such a system to test it. But
> with the current conditions, it will break bootup code. In case it is really a
> problem, we'd need to make a special case for that.

 I have dug out the relevant erratum -- it is the 11AP one as referred to 
from arch/x86/kernel/smp_32.c and the text even mentions the EOI register 
explicitly:

"This problem affects systems that use HOLD/HLDA or BOFF# and enable the 
local APIC of the CPU.  If the second APIC write cycle is an EOI (End of 
Interrupt) cycle, the CPU will stop servicing subsequent interrupts of 
equal or less priority.  This may cause the system to hang.  If the second 
APIC write cycle is not an EOI, the failure mode would depend on the 
particular APIC register that is not updated correctly."

 But on this occasion I took the opportunity to refresh my memory on the 
ESR register and there is apparently no bit there, at least up to 
Pentium4, that would signify an error resulting from an incorrect access 
type -- only accesses to invalid register indices are marked as errors.  

 Which bit of the ESR can you see set as a result of using an RMW cycle to 
the EOI register and with what kind of CPU/APIC?  And why wouldn't it have 
affected older kernels? -- the error interrupt has been kept enabled by 
Linux for ages and writes to the EOI register are frequent enough it would 
be hard to miss the resulting flood of errors.  Hmm...

  Maciej
