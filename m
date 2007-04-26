Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXDZGuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXDZGuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXDZGuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:50:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36648 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbXDZGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:50:04 -0400
Date: Thu, 26 Apr 2007 12:18:06 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, horms@verge.net.au,
       mbligh@google.com
Subject: Re: [RFC PATCH 0/10] apic_wait_icr_idle issues and possible solutions
Message-ID: <20070426064806.GA2626@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:03:04PM +0900, Fernando Luis Vázquez Cao wrote:
> 
> static __inline__ void apic_wait_icr_idle(void)
> {
>   while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
>     cpu_relax();
> }
> 
> The busy loop in this function would not be problematic if the
> corresponding status bit in the ICR were always updated, but that does
> not seem to be the case under certain crash scenarios. As an example,
> when the other CPUs are locked-up inside the NMI handler the CPU that
> sends the IPI will end up looping forever in the ICR check, effectively
> hard-locking the whole system.
> 
> Quoting from Intel's "MultiProcessor Specification" (Version 1.4), B-3:
> 
> "A local APIC unit indicates successful dispatch of an IPI by
> resetting the Delivery Status bit in the Interrupt Command
> Register (ICR). The operating system polls the delivery status
> bit after sending an INIT or STARTUP IPI until the command has
> been dispatched.
> 
> A period of 20 microseconds should be sufficient for IPI dispatch
> to complete under normal operating conditions. If the IPI is not
> successfully dispatched, the operating system can abort the
> command. Alternatively, the operating system can retry the IPI by
> writing the lower 32-bit double word of the ICR. This “time-out”
> mechanism can be implemented through an external interrupt, if
> interrupts are enabled on the processor, or through execution of
> an instruction or time-stamp counter spin loop."
> 
> Intel's documentation suggests the implementation of a time-out
> mechanism, which, by the way, is already being open-coded in some parts
> of the kernel that tinker with ICR.
> 
> --- Possible solutions
> 
> * Solution A: Implement the time-out mechanism in apic_wait_icr_idle.
> 
> The problem with this approach is that introduces a performance penalty
> that may not be acceptable for some callers of apic_wait_icr_idle.
> Besides, during normal operation delivery errors should not occur. This
> brings us to solution B.
> 

Hi Fernando,

How much is the performance penalty? Is it really significant. My point
is that, to me changing apic_wait_icr_dle() itself seems to be the simple
approach instead of introducing another function.

Original implementation is:

static __inline__ void apic_wait_icr_idle(void)
{
	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
	cpu_relax();
}

And new one will look something like.

        do {
                send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
                if (!send_status)
                        break;
                udelay(100);
        } while (timeout++ < 1000);

There will be at max 100 microsecond delay before you realize that IPI has
been dispatched. To optimize it further we can change it to 10 microsecond
delay

        do {
                send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
                if (!send_status)
                        break;
                udelay(10);
        } while (timeout++ < 10000);
 
or may be

        do {
                send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
                if (!send_status)
                        break;
                udelay(1);
        } while (timeout++ < 100000);

I don't know if 1 micro second delay is supported. I do see it being
used in kernel/hpet.c

Is it too much of performance overhead? Somebody who knows more about it
needs to tell. To me changing apic_wait_icr_idle() seems simple instead
of introducing a new function and then making a special case for NMI.

Thanks
Vivek
