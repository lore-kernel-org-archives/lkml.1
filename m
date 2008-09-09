Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYIIEy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYIIEy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYIIEyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:54:49 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:46616 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751183AbYIIEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:54:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=iWbgB9n5V68+Qpi1Hnwr7Ro30EDKhpYC8P3iBQVce/Y1/klnlsmXvDdXHtsq5TA7IogDWAflmHaqfUhsursKAVM7A2WdeMaucdDxCoUt31lqSB5PU37J+cacac2j+bJf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix printk format compiler warnings
Date: Mon, 8 Sep 2008 21:54:44 -0700
User-Agent: KMail/1.9.9
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org
References: <48C13CE0.76E4.0078.0@novell.com> <20080905142040.7497be38.akpm@linux-foundation.org>
In-Reply-To: <20080905142040.7497be38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082154.44515.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 05, 2008 2:20 pm Andrew Morton wrote:
> On Fri, 05 Sep 2008 13:06:24 +0100
>
> "Jan Beulich" <jbeulich@novell.com> wrote:
> > %llx and the like cannot be used on u64-derived data types - they must
> > be cast to long long explicitly for arch-es where u64 is a typedef of
> > unsigned long (ia64 is where I observed the problem).
> >
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >
> > ---
> >  drivers/pci/probe.c     |   16 +++++++++++++---
> >  drivers/pci/setup-bus.c |    6 +++++-
> >  2 files changed, 18 insertions(+), 4 deletions(-)
> >
> > --- linux-2.6.27-rc5/drivers/pci/probe.c	2008-08-21 14:37:32.000000000
> > +0200 +++ 2.6.27-rc5-pci-probe-print/drivers/pci/probe.c	2008-09-02
> > 15:18:08.000000000 +0200 @@ -383,7 +383,10 @@ void __devinit
> > pci_read_bridge_bases(str
> >  			res->start = base;
> >  		if (!res->end)
> >  			res->end = limit + 0xfff;
> > -		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
> > pci_name(dev), res->start, res->end); +		printk(KERN_INFO "PCI: bridge %s
> > io port: [%Lx, %Lx]\n",
> > +		       pci_name(dev),
> > +		       (unsigned long long)res->start,
> > +		       (unsigned long long)res->end);
> >  	}
> >
> >  	res = child->resource[1];
> > @@ -395,7 +398,10 @@ void __devinit pci_read_bridge_bases(str
> >  		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
> > IORESOURCE_MEM; res->start = base;
> >  		res->end = limit + 0xfffff;
> > -		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
> > pci_name(dev), res->start, res->end); +		printk(KERN_INFO "PCI: bridge %s
> > 32bit mmio: [%Lx, %Lx]\n",
> > +		       pci_name(dev),
> > +		       (unsigned long long)res->start,
> > +		       (unsigned long long)res->end);
> >  	}
> >
> >  	res = child->resource[2];
> > @@ -431,7 +437,11 @@ void __devinit pci_read_bridge_bases(str
> >  		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
> > IORESOURCE_MEM | IORESOURCE_PREFETCH; res->start = base;
> >  		res->end = limit + 0xfffff;
> > -		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
> > pci_name(dev), (res->flags &
> > PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
> > +		printk(KERN_INFO "PCI: bridge %s %dbit mmio pref: [%Lx, %Lx]\n", +		  
> >     pci_name(dev),
> > +		       res->flags & PCI_PREF_RANGE_TYPE_64 ? 64 : 32,
> > +		       (unsigned long long)res->start,
> > +		       (unsigned long long)res->end);
> >  	}
> >  }
> >
> > --- linux-2.6.27-rc5/drivers/pci/setup-bus.c	2008-08-21
> > 14:37:32.000000000 +0200 +++
> > 2.6.27-rc5-pci-probe-print/drivers/pci/setup-bus.c	2008-09-02
> > 15:18:20.000000000 +0200 @@ -539,7 +539,11 @@ static void
> > pci_bus_dump_res(struct pci_
> >                  if (!res)
> >                          continue;
> >
> > -		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number,
> > i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
> > +		printk(KERN_INFO "bus: %02x index %x %s: [%Lx, %Lx]\n",
> > +		       bus->number, i,
> > +		       res->flags & IORESOURCE_IO ? "io port" : "mmio",
> > +		       (unsigned long long)res->start,
> > +		       (unsigned long long)res->end);
> >          }
> >  }
>
> These have been fixed in linux-next for a month.
>
> Jesse, can we get that into 2.6.27 please?

I suppose.  They only appear with certain configs and are fairly harmless, so 
I wasn't planning on pushing them into 2.6.27.  But I'll include it in my 
next pull request anyway, since you're such a cool guy and I want to make you 
happy :)  (assuming 2.6.27 proper isn't released in the next couple of 
day...)

Thanks,
Jesse
