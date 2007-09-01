Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXIABAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXIABAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXIABA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:00:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:49520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750737AbXIABA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:00:26 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+e/Yosp8uejfr4VmKESntYV80CkqoIa2yPZQmDXv
	IoeyM3DpnI1iTH
Date: Sat, 1 Sep 2007 03:00:53 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070901010053.GA29765@atjola.homenet>
References: <20070828194636.GB2814@frankl.hpl.hp.com> <1188332024.2435.328.camel@dhcp193.mvista.com> <20070829212451.GC4810@frankl.hpl.hp.com> <1188436919.26038.27.camel@dhcp193.mvista.com> <20070830210555.GA6635@frankl.hpl.hp.com> <1188571401.26038.41.camel@dhcp193.mvista.com> <20070831162146.GD7161@frankl.hpl.hp.com> <1188578123.26038.52.camel@dhcp193.mvista.com> <20070831180644.GA24174@atjola.homenet> <1188606286.26038.117.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1188606286.26038.117.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.08.31 17:24:46 -0700, Daniel Walker wrote:
> On Fri, 2007-08-31 at 20:06 +0200, Björn Steinbrink wrote:
> 
> 
> > > something to do with the nmi hertz adjustment that happens after
> > > check_nmi_watchdog() ..
> > 
> > Hm hm, does the same thing (watchdog stuck after check) happen with
> > older kernels, ie. those before Stephane's changeset that made it use
> > PERFCTR1?
> 
> I noticed the frequency gets turned down after check_nmi_watchdog() is
> called.. I think it's suppose to trigger once per second, but it's more
> like it updates randomly ..

It's once per second if the cpu is 100% busy, if it's just idling and
halted, the performance counters won't be increased.

> In older kernels it's very slow, but it's more consistent ..

With the same load on the box? Maybe some other changes caused the box
to behave differently (say, CFS), regarding eg. load distribution
amongst the cores.

> 
> Here is some output ..
> 
> morning-glory ~ # cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:        103          0          0          0   IO-APIC-edge      timer
>   1:          0          0          0          8   IO-APIC-edge      i8042
>   4:       2320          0          0          1   IO-APIC-edge      serial
>   8:          1          0          0          1   IO-APIC-edge      rtc
>  12:          0          0          0        113   IO-APIC-edge      i8042
>  14:       1143          0          0         10   IO-APIC-edge      ide0
>  16:        227          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
>  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0          0          0          1   IO-APIC-fasteoi   acpi
> NMI:        150        168        124        121
> LOC:       6188       6189       6187       6184
> ERR:          0
> MIS:          0
> morning-glory ~ # cat /proc/interrupts 
>            CPU0       CPU1       CPU2       CPU3       
>   0:        103          0          0          0   IO-APIC-edge      timer
>   1:          0          0          0          8   IO-APIC-edge      i8042
>   4:       2391          0          0          1   IO-APIC-edge      serial
>   8:          1          0          0          1   IO-APIC-edge      rtc
>  12:          0          0          0        113   IO-APIC-edge      i8042
>  14:       1143          0          0         10   IO-APIC-edge      ide0
>  16:        872          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
>  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:          0          0          0          1   IO-APIC-fasteoi   acpi
> NMI:        151        168        124        121 
> LOC:      21443      21444      21442      21439 
> ERR:          0
> MIS:          0
> dwalker2 ~ # 
> 
> 
> If you look at the LOC values you'll notice a lot of time has passed,
> with only one NMI and on only one cpu ..
> 
> It's possible this is something else completely tho ..

At least from the interrupt side, that box looks pretty idle, so that's
expected I'd say.

> 
> > Maybe you could "activate" the Dprintk in write_watchdog_counter32() to
> > see which value gets written to the MSR? (I don't see any switch to
> > activate it, so maybe just s/Dprintk(/printk(KERN_WHATEVER / ?)
> 
> Here's the only lines printed,
> 
> setting INTEL_ARCH_PERFCTR0 to -0x0131385e
> setting INTEL_ARCH_PERFCTR0 to -0x0131385e
> setting INTEL_ARCH_PERFCTR0 to -0x0131385e
> setting INTEL_ARCH_PERFCTR0 to -0x0131385e

Ok, dumb I am.

The "interesting" call from p6_rearm passes NULL as desc, and thus the
printk is never called that way. But before we start flooding your logs,
could you just hog all cores with a simple cpu hog and check if that
causes the NMI counter to increase at about 1 Hz? If that doesn't work,
we can go back to that debug output.

Björn
