Return-Path: <linux-kernel-owner+w=401wt.eu-S1161857AbXDYLDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161857AbXDYLDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXDYLDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:03:09 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47117 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbXDYLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:03:07 -0400
Subject: [RFC PATCH 0/10] apic_wait_icr_idle issues and possible solutions
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Keith Owens <kaos@ocs.com.au>, akpm@linux-foundation.org,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ak@suse.de,
       vgoyal@in.ibm.com, horms@verge.net.au, mbligh@google.com
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 20:03:04 +0900
Message-Id: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Background

On i386 and x86_64, in the event of a crash, kdump attempts to stop all
other CPUs before proceeding to boot into the dump capture kernel.
Depending on the sub-architecture several implementations exist as
detailed below.

- i386

smp_send_nmi_allbutself
  send_IPI_mask(mask, NMI_VECTOR)

* mach-default
  send_IPI_mask
-->send_IPI_mask_bitmask
      apic_wait_icr_idle

* mach-bigsmp, mach-es7000, mach-numaq, mach-summit
  send_IPI_mask
-->send_IPI_mask_sequence
      apic_wait_icr_idle

-- x86_64

smp_send_nmi_allbutself
  send_IPI_allbutself(NMI_VECTOR)

* flat APIC
  send_IPI_allbutself=flat_send_IPI_allbutself
-->flat_send_IPI_mask
      apic_wait_icr_idle

* clustered APIC, physflat APIC

send_IPI_allbutself=(cluster_send_IPI_allbutself/physflat_send_IPI_allbutself)
    (cluster_send_IPI_mask/physflat_send_IPI_mask)
   -->send_IPI_mask_sequence
        apic_wait_icr_idle

As the pseudo-code above shows all the sub-architectures end up calling
apic_wait_icr_idle, which looks like this:

static __inline__ void apic_wait_icr_idle(void)
{
  while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
    cpu_relax();
}

The busy loop in this function would not be problematic if the
corresponding status bit in the ICR were always updated, but that does
not seem to be the case under certain crash scenarios. As an example,
when the other CPUs are locked-up inside the NMI handler the CPU that
sends the IPI will end up looping forever in the ICR check, effectively
hard-locking the whole system.

Quoting from Intel's "MultiProcessor Specification" (Version 1.4), B-3:

"A local APIC unit indicates successful dispatch of an IPI by
resetting the Delivery Status bit in the Interrupt Command
Register (ICR). The operating system polls the delivery status
bit after sending an INIT or STARTUP IPI until the command has
been dispatched.

A period of 20 microseconds should be sufficient for IPI dispatch
to complete under normal operating conditions. If the IPI is not
successfully dispatched, the operating system can abort the
command. Alternatively, the operating system can retry the IPI by
writing the lower 32-bit double word of the ICR. This “time-out”
mechanism can be implemented through an external interrupt, if
interrupts are enabled on the processor, or through execution of
an instruction or time-stamp counter spin loop."

Intel's documentation suggests the implementation of a time-out
mechanism, which, by the way, is already being open-coded in some parts
of the kernel that tinker with ICR.

--- Possible solutions

* Solution A: Implement the time-out mechanism in apic_wait_icr_idle.

The problem with this approach is that introduces a performance penalty
that may not be acceptable for some callers of apic_wait_icr_idle.
Besides, during normal operation delivery errors should not occur. This
brings us to solution B.

* Solution B: Create a new function that implements the time-out
mechanism.

Create a new function (what about safe_apic_wait_icr_idle?) that
provides the apic_wait_icr_idle functionality but also implements a
time-out mechanism. This function would look like this:

static __inline__ int safe_apic_wait_icr_idle(void)
{
  unsigned long send_status;
  int timeout;

  timeout = 0;
  do {
    udelay(100);
    send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
  } while (send_status && (timeout++ < 1000));

  return send_status;
}

Once we have this function we still have to decide how to use it:

Solution B-1: Create send_IPI_mask and send_IPI_allbutself replacements
that use the new safe_apic_wait_icr_idle instead of apic_wait_icr_idle.
The problem with this approach is that it may be overkill, since they
probably would not have many users besides kdump.

Solution B-2: Use safe_apic_wait_icr_idle when the vector is NMI_VECTOR
and apic_wait_icr_icr_idle otherwise. This solution has the advantage
that it is very simple, but it probably isn't very elegant.

--- About this patch set

The kdump-related stuff is included in patches 9 and 10, but even this
part is rejected I think that patches 1 through 8 include some necessary
cleanups.

Patches 1 and 2: implement safe_apic_wait_icr_idle for i386 and x86_64
respectively.

Patches 3 through 6: remove some ugly cut and pasting from the smp code.

Patches 7 and 8: Cleanup *send_IPI*.

Patches 9 and 10: Implement solution B-2.

I would appreciate your feedback on these patches.

- Fernando

