Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbXHaQp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbXHaQp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbXHaQpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:45:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2260 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896AbXHaQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:45:12 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070831162146.GD7161@frankl.hpl.hp.com>
References: <20070828091217.GA1645@frankl.hpl.hp.com>
	 <1188311684.2435.288.camel@dhcp193.mvista.com>
	 <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
	 <1188332024.2435.328.camel@dhcp193.mvista.com>
	 <20070829212451.GC4810@frankl.hpl.hp.com>
	 <1188436919.26038.27.camel@dhcp193.mvista.com>
	 <20070830210555.GA6635@frankl.hpl.hp.com>
	 <1188571401.26038.41.camel@dhcp193.mvista.com>
	 <20070831162146.GD7161@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 09:35:23 -0700
Message-Id: <1188578123.26038.52.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 09:21 -0700, Stephane Eranian wrote:
> Daniel,
> 
> On Fri, Aug 31, 2007 at 07:43:20AM -0700, Daniel Walker wrote:
> > On Thu, 2007-08-30 at 14:05 -0700, Stephane Eranian wrote:
> > > Daniel,
> > 
> > > Yes, I realized I missed a small detail in the switch statement.
> > > Could you try the new version?
> > 
> > This patch still has the stuck NMI .. Essentially the same thing that
> > happened without the patch..
> > 
> Ok, looks like deaulting to P6 does not quite work.
> 
> Here is a new version. This time I used a different approach.
> I am must admit I am a bit puzzled by the duplication of information
> between the wd_ops and the nmi_watchdog_ctlblk structure. My understanding
> is that thelater is used as a cache for the info that needs to be per-cpu.
> 
> The wd_ops provides the MSR to use for the counter, yet all the setup_*()
> routines hardcode the MSR. Not sure why?

Yeah, that's bad .. For instance, if those had all been centralized
Bjorn wouldn't have needed to fix those up later..

> In this patch, the setup_*() routine now extract the MSR from the wd_ops
> to copy them into the nmi_watchdog_ctlblk. This is not done for P4 because
> of the special and ugly case of HT. 
> 
> With this approach, we can now create a custom wd_ops for CoreDuo that is
> a clone of the intel_arch_wd_ops, except for the MSR.
> 
> Could you try this one instead?

So I tested your patch unchanged and the system boots, and the
check_nmi_watchdog() passes .. However, the nmi stops ticking right
after bootup,

>From my /proc/interrupts below,

           CPU0       CPU1       CPU2       CPU3       
  0:        108          0          0          0   IO-APIC-edge      timer
  1:          0          0          0          8   IO-APIC-edge      i8042
  4:       3427          0          0          1   IO-APIC-edge      serial
  8:          1          0          0          1   IO-APIC-edge      rtc
 12:          0          0          0        113   IO-APIC-edge      i8042
 14:       1128          0          0         10   IO-APIC-edge      ide0
 16:       1664          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
 18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 20:          0          0          0          1   IO-APIC-fasteoi   acpi
NMI:       1670       1453       1097        967 
LOC:      48001      48002      48000      48006 
ERR:          0
MIS:          0


The NMI field never changes ..

So I added another change which looked appropriate,

@@ -674,6 +688,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz
 {
        struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
        if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+           wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 ||
            wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
                hz = adjust_for_32bit_ctr(hz);
        return hz;


Unfortunately that didn't fix anything, but I have a feeling is has
something to do with the nmi hertz adjustment that happens after
check_nmi_watchdog() ..

Daniel


