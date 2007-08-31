Return-Path: <linux-kernel-owner+w=401wt.eu-S965866AbXHaSG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbXHaSG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXHaSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:06:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:40547 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965503AbXHaSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:06:20 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX189ZoVjweQ94gIybAeDGsq9dOLRbO2niYG7k5WeoU
	35woNNj4IOOlqc
Date: Fri, 31 Aug 2007 20:06:44 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070831180644.GA24174@atjola.homenet>
References: <20070828170556.GI1645@frankl.hpl.hp.com> <1188325835.2435.317.camel@dhcp193.mvista.com> <20070828194636.GB2814@frankl.hpl.hp.com> <1188332024.2435.328.camel@dhcp193.mvista.com> <20070829212451.GC4810@frankl.hpl.hp.com> <1188436919.26038.27.camel@dhcp193.mvista.com> <20070830210555.GA6635@frankl.hpl.hp.com> <1188571401.26038.41.camel@dhcp193.mvista.com> <20070831162146.GD7161@frankl.hpl.hp.com> <1188578123.26038.52.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1188578123.26038.52.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.08.31 09:35:23 -0700, Daniel Walker wrote:
> On Fri, 2007-08-31 at 09:21 -0700, Stephane Eranian wrote:
> > In this patch, the setup_*() routine now extract the MSR from the wd_ops
> > to copy them into the nmi_watchdog_ctlblk. This is not done for P4 because
> > of the special and ugly case of HT. 
> > 
> > With this approach, we can now create a custom wd_ops for CoreDuo that is
> > a clone of the intel_arch_wd_ops, except for the MSR.
> > 
> > Could you try this one instead?
> 
> So I tested your patch unchanged and the system boots, and the
> check_nmi_watchdog() passes .. However, the nmi stops ticking right
> after bootup,
> 
> >>From my /proc/interrupts below,
> 
>            CPU0       CPU1       CPU2       CPU3       
>   0:        108          0          0          0   IO-APIC-edge      timer
>   1:          0          0          0          8   IO-APIC-edge      i8042
>   4:       3427          0          0          1   IO-APIC-edge      serial
>   8:          1          0          0          1   IO-APIC-edge      rtc
>  12:          0          0          0        113   IO-APIC-edge      i8042
>  14:       1128          0          0         10   IO-APIC-edge      ide0
>  16:       1664          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
>  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0          0          0          1   IO-APIC-fasteoi   acpi
> NMI:       1670       1453       1097        967 
> LOC:      48001      48002      48000      48006 
> ERR:          0
> MIS:          0
> 
> 
> The NMI field never changes ..
> 
> So I added another change which looked appropriate,
> 
> @@ -674,6 +688,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz
>  {
>         struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
>         if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
> +           wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 ||
>             wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
>                 hz = adjust_for_32bit_ctr(hz);
>         return hz;
> 
> 
> Unfortunately that didn't fix anything, but I have a feeling is has

That's because MSR_P6_PERFCTR0 is the same as MSR_ARCH_PERFMON_PERFCTR0.
But I'd personally add that change anyway, as it makes the code less
tricky and the compiler should optimize it away.

> something to do with the nmi hertz adjustment that happens after
> check_nmi_watchdog() ..

Hm hm, does the same thing (watchdog stuck after check) happen with
older kernels, ie. those before Stephane's changeset that made it use
PERFCTR1?

Maybe you could "activate" the Dprintk in write_watchdog_counter32() to
see which value gets written to the MSR? (I don't see any switch to
activate it, so maybe just s/Dprintk(/printk(KERN_WHATEVER / ?)

Thanks,
Björn
