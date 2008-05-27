Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYE0H0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYE0H0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYE0H0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:26:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:52797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbYE0H0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,547,1204531200"; 
   d="scan'208";a="387406900"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080516005121.GA6926@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
	 <1210830110.23707.141.camel@caritas-dev.intel.com>
	 <20080516005121.GA6926@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2008 15:27:43 +0800
Message-Id: <1211873263.12819.103.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 27 May 2008 07:26:25.0117 (UTC) FILETIME=[F85C80D0:01C8BFCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 20:51 -0400, Vivek Goyal wrote:
> On Thu, May 15, 2008 at 01:41:50PM +0800, Huang, Ying wrote:
> > Hi, Vivek,
> > 
> > On Wed, 2008-05-14 at 16:52 -0400, Vivek Goyal wrote:
> > [...]
> > > Ok, I have done some testing on this patch. Currently I have just
> > > tested switching back and forth between two kernels and it is working for
> > > me.
> > > 
> > > Just that I had to put LAPIC and IOAPIC in legacy mode for it to work. Few
> > > comments/questions are inline.
> > 
> > It seems that for LAPIC and IOAPIC, there is
> > lapic_suspend()/lapic_resume() and ioapic_suspend()/ioapic_resume(),
> > which will be called before/after kexec jump through
> > device_power_down()/device_power_up(). So, the mechanism for
> > LAPIC/IOAPIC is there, we may need to check the corresponding
> > implementation.
> > 
> 
> ioapic_suspend() is not putting APICs in Legacy mode and that's why
> we are seeing the issue. It only saves the IOAPIC routing table entries
> and these entries are restored during ioapic_resume().
> 
> But I think somebody has to put APICs in legacy mode for normal 
> hibernation also. Not sure who does it. May be BIOS, so that during
> resume, second kernel can get the timer interrupts.

As for IOAPIC legacy mode, is it related to the following code which set
the routing table entry for i8259?


void disable_IO_APIC(void)
{
        /*
         * Clear the IO-APIC before rebooting:
         */
        clear_IO_APIC();

        /*
         * If the i8259 is routed through an IOAPIC
         * Put that IOAPIC in virtual wire mode
         * so legacy interrupts can be delivered.
         */
        if (ioapic_i8259.pin != -1) {
                struct IO_APIC_route_entry entry;

                memset(&entry, 0, sizeof(entry));
                entry.mask            = 0; /* Enabled */
                entry.trigger         = 0; /* Edge */
                entry.irr             = 0;
                entry.polarity        = 0; /* High */
                entry.delivery_status = 0;
                entry.dest_mode       = 0; /* Physical */
                entry.delivery_mode   = dest_ExtINT; /* ExtInt */
                entry.vector          = 0;
                entry.dest.physical.physical_dest =
                                        GET_APIC_ID(apic_read(APIC_ID));

                /*
                 * Add it to the IO-APIC irq-routing table:
                 */
                ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin,
entry);
        }
        disconnect_bsp_APIC(ioapic_i8259.pin != -1);
}


But, because IOAPIC may need to be in original state during
suspend/resume, so it is not appropriate to call disable_IO_APIC() in
ioapic_suspend(). So I think we can call disable_IO_APIC() in new
hibernation/restore callback.

Am I right?

Best Regards,
Huang Ying

