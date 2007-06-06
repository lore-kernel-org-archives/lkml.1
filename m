Return-Path: <linux-kernel-owner+w=401wt.eu-S936202AbXFFVDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936202AbXFFVDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933430AbXFFVD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:03:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:13829 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935327AbXFFVDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="254027291"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ACPI: Move timer broadcast and pmtimer access before C3arbiter shutdown
Date: Wed, 6 Jun 2007 14:02:46 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5FA2114@scsmsx415.amr.corp.intel.com>
In-Reply-To: <1181122673.4404.200.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ACPI: Move timer broadcast and pmtimer access before C3arbiter shutdown
Thread-Index: AceoHl+l3WLWKbMnSCWrL7pJs8eTzwAX40Vg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Andrew Morton" <akpm@osdl.org>
Cc: "Stable Team" <stable@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Arjan van de Ven" <arjan@infradead.org>, "Andi Kleen" <ak@suse.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       "Dave Jones" <davej@redhat.com>
X-OriginalArrivalTime: 06 Jun 2007 21:02:48.0455 (UTC) FILETIME=[09A5B970:01C7A87E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ack.

Thanks,
Venki 

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de] 
>Sent: Wednesday, June 06, 2007 2:38 AM
>To: Andrew Morton
>Cc: Pallipadi, Venkatesh; Stable Team; LKML; Len Brown; Ingo 
>Molnar; Arjan van de Ven; Andi Kleen; Udo A. Steinberg; Dave Jones
>Subject: [PATCH] ACPI: Move timer broadcast and pmtimer access 
>before C3arbiter shutdown
>
>From: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
>
>The chip set doc for IHC4 says:
>
>1.In general, software should not attempt any non-posted 
>accesses during
>arbiter disable except to the ICH4's power management registers. This
>implies that interrupt handlers for any unmasked hardware 
>interrupts and
>SMI/NMI should check ARB_DIS status before reading from ICH devices.
>
>So it's not a good idea to access ICH devices after arbiter shut down. 
>
>Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
>---
> drivers/acpi/processor_idle.c |    9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>
>Index: linux-2.6.22-rc4/drivers/acpi/processor_idle.c
>===================================================================
>--- linux-2.6.22-rc4.orig/drivers/acpi/processor_idle.c	
>2007-06-06 11:47:21.000000000 +0200
>+++ linux-2.6.22-rc4/drivers/acpi/processor_idle.c	
>2007-06-06 11:48:21.000000000 +0200
>@@ -488,6 +488,11 @@ static void acpi_processor_idle(void)
> 
> 	case ACPI_STATE_C3:
> 
>+		/* Get start time (ticks) */
>+		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>+		/* Handle timer broadcast before bus arbiter 
>shutdown ! */
>+		acpi_state_timer_broadcast(pr, cx, 1);
>+
> 		if (pr->flags.bm_check) {
> 			if (atomic_inc_return(&c3_cpu_count) ==
> 			    num_online_cpus()) {
>@@ -502,10 +507,7 @@ static void acpi_processor_idle(void)
> 			ACPI_FLUSH_CPU_CACHE();
> 		}
> 
>-		/* Get start time (ticks) */
>-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
> 		/* Invoke C3 */
>-		acpi_state_timer_broadcast(pr, cx, 1);
> 		acpi_cstate_enter(cx);
> 		/* Get end time (ticks) */
> 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>
