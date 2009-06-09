Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZFIFsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZFIFsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 01:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZFIFsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 01:48:01 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40334
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752526AbZFIFsA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 01:48:00 -0400
X-SpamScore: -42
X-BigFish: VPS-42(zz1418M1432R98dR1805M179dP9371P873fizz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKYIRU-01-RTX-01
Date: Tue, 9 Jun 2009 07:47:04 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090609054704.GC12431@alberich.amd.com>
References: <20090417100155.GE16198@alberich.amd.com> <20090417162115.GF8253@elte.hu> <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com> <20090420084747.GA7286@alberich.amd.com> <20090420130341.098c8ebe@hobbes> <20090507085136.GC2868@alberich.amd.com> <20090511145423.3663ed31@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090511145423.3663ed31@jbarnes-g45>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Jun 2009 05:47:53.0320 (UTC) FILETIME=[D4CD5E80:01C9E8C5]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 02:54:23PM -0700, Jesse Barnes wrote:
> On Thu, 7 May 2009 10:51:36 +0200
> Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > On Mon, Apr 20, 2009 at 01:03:41PM -0700, Jesse Barnes wrote:
> > > On Mon, 20 Apr 2009 10:47:47 +0200
> > > Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > > > On Fri, Apr 17, 2009 at 12:26:54PM -0700, Yinghai Lu wrote:
> > > > > On Fri, Apr 17, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu>
> > > > > wrote:
> > > > > > const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
> > > > > > {
> > > > > >        if (dev->numa_node == -1)
> > > > > >                return cpumask_of_pcibus(to_pci_dev(dev)->bus);
> > > > > >
> > > > > >        return cpumask_of_node(dev_to_node(dev));
> > > > > > }
> > > > > >
> > > > > > ? This would work fine in all cases.
> > > > 
> > > > Yes, I think so. That's the general solution w/o additional
> > > > "ifdefing".
> > > > 
> > > > > you are right, dev_to_node(dev) could return -1 on 64bit, if
> > > > > there is no memory on that node.
> > > > 
> > > > Hmm, I thought just in the CONFIG_NUMA=n case -1 is returned.
> > > > 
> > > > During initialization the struct device's numa_node is set to -1
> > > > and later on the information is inherited from the parent
> > > > numa_node.
> > > > 
> > > > So what do I miss?
> > > 
> > > I like the idea of cpumask_of_pcidev(), but it seems like
> > > cpumask_of_pcibus should return the same value.  So if the node is
> > > unassigned or "equadistant" (there's code that treats -1 as both I
> > > think), cpumask_of_pcibus should figure out what the nearest CPUs
> > > are and return that, right?
> > 
> > Usually this is true.
> > 
> > But there is one special case.
> > 
> > Northbridge functions of AMD CPUs appear to be on bus 0 device 24-31
> > (each having 4 or 5 functions depending on the CPU family).
> > 
> > Requests to those devices (e.g. reading config space) are handled by
> > the processor(s) themselves and aren't routed to the PCI bus.
> > At most such requests are routed to another processor (node) if the
> > request is for a northbridge function of a different processor.
> > 
> > See 9b94b3a19b13e094c10f65f24bc358f6ffe4eacd for some additional info.
> > 
> > That is why I think that using cpumask_of_pcidev should have
> > precedence over cpumask_of_pcibus. (numa_node information of a PCI
> > device can be fixed up and then differ from node information of the
> > PCI bus .)
> 
> So we're making the generic code more confusing to handle an AMD
> special case?

Yes.

> Are the functions you mention likely to have drivers
> that allocate memory or need cpumask_of_pcibus info?

Rarely or better say not at the moment.

> I guess there are no nice solutions given the above split of the
> device across busses (in a logical sense), so the cleanups Ingo
> suggested may be the best we can do.

Yes, I think so.


Regards,
Andreas


