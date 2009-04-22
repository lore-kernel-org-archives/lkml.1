Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZDVC4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZDVC4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZDVC4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:56:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:42050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDVC4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,228,1239001200"; 
   d="scan'208";a="450140280"
From: "Han, Weidong" <weidong.han@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Wed, 22 Apr 2009 10:55:23 +0800
Subject: RE: [patch 4/5] x2apic, IR: remove reinit_intr_remapped_IO_APIC()
Thread-Topic: [patch 4/5] x2apic, IR: remove reinit_intr_remapped_IO_APIC()
Thread-Index: AcnCrqMDfPQiZFCDTVe4ekk5ryYwEQARqj1Q
Message-ID: <715D42877B251141A38726ABF5CABF2C01A6B7FC31@pdsmsx503.ccr.corp.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
	 <20090420200450.552359000@linux-os.sc.intel.com>
	 <715D42877B251141A38726ABF5CABF2C01A6B7F9FC@pdsmsx503.ccr.corp.intel.com>
	 <20090421070130.GC22937@elte.hu>
 <1240338284.27006.8519.camel@localhost.localdomain>
In-Reply-To: <1240338284.27006.8519.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Tue, 2009-04-21 at 00:01 -0700, Ingo Molnar wrote:
>> * Han, Weidong <weidong.han@intel.com> wrote:
>> 
>>> Siddha, Suresh B wrote:
>>>> When interrupt-remapping is enabled, We are relying on
>>>> setup_IO_APIC_irqs() to configure remapped entries in the IO-APIC,
>>>> which comes little bit later after enabling interrupt-remapping.
>>>> 
>>>> Meanwhile, Restore of old io-apic entries after enabling
>>>> interrupt-remapping will not make the interrupts through io-apic
>>>> functional anyway. 
>>>> 
>>>> So remove unnecessary reinit_intr_remapped_IO_APIC().
>>>> 
>>>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>>>> Cc: Weidong Han <weidong.han@intel.com>
>>>> ---
>>>> 
>>>> Index: tip/arch/x86/include/asm/io_apic.h
>>>> ===================================================================
>>>> --- tip.orig/arch/x86/include/asm/io_apic.h
>>>> +++ tip/arch/x86/include/asm/io_apic.h
>>>> @@ -166,8 +166,6 @@ extern void free_ioapic_entries(struct I
>>>>  extern int save_IO_APIC_setup(struct IO_APIC_route_entry
>>>>  **ioapic_entries); extern void mask_IO_APIC_setup(struct
>>>>  IO_APIC_route_entry **ioapic_entries); extern int
>>>> restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
>>>> -extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
>>>> -	struct IO_APIC_route_entry **ioapic_entries);
>>>> 
>>>>  extern void probe_nr_irqs_gsi(void);
>>>> 
>>>> Index: tip/arch/x86/kernel/apic/apic.c
>>>> ===================================================================
>>>> --- tip.orig/arch/x86/kernel/apic/apic.c
>>>> +++ tip/arch/x86/kernel/apic/apic.c
>>>> @@ -1416,8 +1416,6 @@ end_restore:
>>>>  		 * IR enabling failed
>>>>  		 */
>>>>  		restore_IO_APIC_setup(ioapic_entries);
>>>> -	else
>>>> -		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
>>> 
>>> Whether IR enabling succeeds or fails, it always needs to restore
>>> old IOAPIC entries. Due to removing reinit_intr_remapped_IO_APIC
>>> here, it needs to also remove the "if (ret)" before
>>> restore_IO_APIC_setup(ioapic_entries);
>> 
>> Ok - i skipped this patch for now.
> 
> Let me clarify what I am doing in this patch:
> 
> When interrupt-remapping is enabled, IO-APIC entries need to be setup
> in the re-mappable format (pointing to interrupt-remapping table
> entries setup by the OS). This remapping configuration is happening
> in the same place where we traditionally configure IO-APIC (i.e., in
> setup_IO_APIC_irqs()).
> 
> So when we enable interrupt-remapping successfully, there is no need
> to restore old io-apic RTE entries before we actually do a complete
> configuration shortly in setup_IO_APIC_irqs(). Old IO-APIC RTE's may
> be in traditional format (non re-mappable) or in re-mappable format
> pointing to interrupt-remapping table entries setup by BIOS. Restoring
> both of these will not make IO-APIC functional. We have to rely on
> setup_IO_APIC_irqs() for proper configuration by OS.
> 
> So I am removing this unnecessary and broken step.
> 
> When enabling interrupt-remapping is not successful, we are doing
> plain restore of old RTE's (which will still work as we went back to
> original no-remapping state). Complete IO-APIC configuration will be
> done shortly in setup_IO_APIC_irqs().
> 

Clear explanation. I misunderstood it. This patch is fine.

Regards,
Weidong

> thanks,
> suresh

