Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbZEGIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbZEGIwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbZEGIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:52:12 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:59281
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755463AbZEGIwK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:52:10 -0400
X-BigFish: VPS-35(zz1418M1432R98dR1805M179dR936fJ9371P873fnzz1202hzzz32i6bh15fn43j)
X-FB-SS: 5,
X-WSS-ID: 0KJ9NAM-02-37J-01
Date: Thu, 7 May 2009 10:51:36 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090507085136.GC2868@alberich.amd.com>
References: <20090417100155.GE16198@alberich.amd.com> <20090417162115.GF8253@elte.hu> <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com> <20090420084747.GA7286@alberich.amd.com> <20090420130341.098c8ebe@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090420130341.098c8ebe@hobbes>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 May 2009 08:52:00.0002 (UTC) FILETIME=[15818620:01C9CEF1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:03:41PM -0700, Jesse Barnes wrote:
> On Mon, 20 Apr 2009 10:47:47 +0200
> Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > On Fri, Apr 17, 2009 at 12:26:54PM -0700, Yinghai Lu wrote:
> > > On Fri, Apr 17, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
> > > > {
> > > >        if (dev->numa_node == -1)
> > > >                return cpumask_of_pcibus(to_pci_dev(dev)->bus);
> > > >
> > > >        return cpumask_of_node(dev_to_node(dev));
> > > > }
> > > >
> > > > ? This would work fine in all cases.
> > 
> > Yes, I think so. That's the general solution w/o additional
> > "ifdefing".
> > 
> > > you are right, dev_to_node(dev) could return -1 on 64bit, if there
> > > is no memory on that node.
> > 
> > Hmm, I thought just in the CONFIG_NUMA=n case -1 is returned.
> > 
> > During initialization the struct device's numa_node is set to -1 and
> > later on the information is inherited from the parent numa_node.
> > 
> > So what do I miss?
> 
> I like the idea of cpumask_of_pcidev(), but it seems like
> cpumask_of_pcibus should return the same value.  So if the node is
> unassigned or "equadistant" (there's code that treats -1 as both I
> think), cpumask_of_pcibus should figure out what the nearest CPUs are
> and return that, right?

Usually this is true.

But there is one special case.

Northbridge functions of AMD CPUs appear to be on bus 0 device 24-31
(each having 4 or 5 functions depending on the CPU family).

Requests to those devices (e.g. reading config space) are handled by
the processor(s) themselves and aren't routed to the PCI bus.
At most such requests are routed to another processor (node) if the
request is for a northbridge function of a different processor.

See 9b94b3a19b13e094c10f65f24bc358f6ffe4eacd for some additional info.

That is why I think that using cpumask_of_pcidev should have
precedence over cpumask_of_pcibus. (numa_node information of a PCI
device can be fixed up and then differ from node information of the
PCI bus .)


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


