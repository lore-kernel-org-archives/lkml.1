Return-Path: <linux-kernel-owner+w=401wt.eu-S1751297AbXIAAe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbXIAAe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 20:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXIAAer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 20:34:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41485 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbXIAAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 20:34:46 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070831180644.GA24174@atjola.homenet>
References: <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
	 <1188332024.2435.328.camel@dhcp193.mvista.com>
	 <20070829212451.GC4810@frankl.hpl.hp.com>
	 <1188436919.26038.27.camel@dhcp193.mvista.com>
	 <20070830210555.GA6635@frankl.hpl.hp.com>
	 <1188571401.26038.41.camel@dhcp193.mvista.com>
	 <20070831162146.GD7161@frankl.hpl.hp.com>
	 <1188578123.26038.52.camel@dhcp193.mvista.com>
	 <20070831180644.GA24174@atjola.homenet>
Content-Type: text/plain; charset=utf-8
Date: Fri, 31 Aug 2007 17:24:46 -0700
Message-Id: <1188606286.26038.117.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 20:06 +0200, Björn Steinbrink wrote:


> > something to do with the nmi hertz adjustment that happens after
> > check_nmi_watchdog() ..
> 
> Hm hm, does the same thing (watchdog stuck after check) happen with
> older kernels, ie. those before Stephane's changeset that made it use
> PERFCTR1?

I noticed the frequency gets turned down after check_nmi_watchdog() is
called.. I think it's suppose to trigger once per second, but it's more
like it updates randomly ..

In older kernels it's very slow, but it's more consistent ..

Here is some output ..

morning-glory ~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:        103          0          0          0   IO-APIC-edge      timer
  1:          0          0          0          8   IO-APIC-edge      i8042
  4:       2320          0          0          1   IO-APIC-edge      serial
  8:          1          0          0          1   IO-APIC-edge      rtc
 12:          0          0          0        113   IO-APIC-edge      i8042
 14:       1143          0          0         10   IO-APIC-edge      ide0
 16:        227          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
 18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 20:          0          0          0          1   IO-APIC-fasteoi   acpi
NMI:        150        168        124        121
LOC:       6188       6189       6187       6184
ERR:          0
MIS:          0
morning-glory ~ # cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:        103          0          0          0   IO-APIC-edge      timer
  1:          0          0          0          8   IO-APIC-edge      i8042
  4:       2391          0          0          1   IO-APIC-edge      serial
  8:          1          0          0          1   IO-APIC-edge      rtc
 12:          0          0          0        113   IO-APIC-edge      i8042
 14:       1143          0          0         10   IO-APIC-edge      ide0
 16:        872          0          0          1   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
 18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 20:          0          0          0          1   IO-APIC-fasteoi   acpi
NMI:        151        168        124        121 
LOC:      21443      21444      21442      21439 
ERR:          0
MIS:          0
dwalker2 ~ # 


If you look at the LOC values you'll notice a lot of time has passed,
with only one NMI and on only one cpu ..

It's possible this is something else completely tho ..

> Maybe you could "activate" the Dprintk in write_watchdog_counter32() to
> see which value gets written to the MSR? (I don't see any switch to
> activate it, so maybe just s/Dprintk(/printk(KERN_WHATEVER / ?)

Here's the only lines printed,

setting INTEL_ARCH_PERFCTR0 to -0x0131385e
setting INTEL_ARCH_PERFCTR0 to -0x0131385e
setting INTEL_ARCH_PERFCTR0 to -0x0131385e
setting INTEL_ARCH_PERFCTR0 to -0x0131385e

Daniel

