Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0BSOY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:24:57 -0500
Received: from kroah.org ([198.145.64.141]:49246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0BSOYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:24:53 -0500
Date: Thu, 18 Feb 2010 19:54:16 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>, dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
 support
Message-ID: <20100219035416.GA25645@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
 <20100218042626.GB11649@kroah.com>
 <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
 <20100218052223.GA13254@kroah.com>
 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
 <20100219004719.GA15965@kroah.com>
 <51f3faa71002181946l69a9a307q930d6159e8e5ac77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51f3faa71002181946l69a9a307q930d6159e8e5ac77@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:46:29PM -0600, Robert Hancock wrote:
> On Thu, Feb 18, 2010 at 6:47 PM, Greg KH <greg@kroah.com> wrote:
> >> > So you did not measure it?
> >> >
> >> > Hm, I guess this change must not be necessary :)
> >>
> >> I'll try and run some tests and see what I can quantify. However, I
> >> only have 4GB of RAM on my machine (with a 1GB memory hole) and so a
> >> random memory allocation only has a 25% chance of ending up in the
> >> area where it would make a difference, so it may take a bit of doing.
> >
> > Without any good justification, including real tests being run, I can't
> > take this patch, the risk is just too high.
> 
> Again, this particular patch has essentially zero risk for anyone that
> doesn't choose to experiment with the option. One can hardly say it
> presents much of a long-term maintenance burden either..

Then don't give them the option, as it doesn't seem needed :)

Again, it is tough to remove options once you add them, so not adding
them at all is the best thing to do.

> > And really, for USB 2.0 speeds, I doubt you are going to even notice
> > this kind of overhead, it's in the noise.  Especially given that almost
> > always the limiting factor is the device itself, not the host.
> 
> Well, I do have some results. This is from running this "dd
> if=/dev/sdg of=/dev/null bs=3800M iflag=direct" against an OCZ Rally2
> USB flash drive, which gets about 30 MB/sec on read, with CPU-burning
> tasks on all cores in the background. (The huge block size and
> iflag=direct is to try to force more of the IO to happen to memory
> above the 4GB mark.) With that workload, swiotlb_bounce shows up as
> between 1.5 to 4% of the CPU time spent in the kernel according to
> oprofile. Obviously with the 64-bit DMA enabled, that disappears. Of
> course, the overall kernel time is only around 2% of the total time,
> so that's a pretty small overall percentage.

2% is noise, right?  So overall you have not really shown any
improvement.

> I'll try some tests later with a faster SATA-to-IDE device that should
> stress things a bit more, but a huge difference doesn't seem likely.
> One thing that's uncertain is just how much of the IO is needing to be
> bounced - an even distribution of the buffer across all of physical
> RAM would suggest 25% in this case, but I don't know an easy way to
> verify that.
> 
> Aside from speed considerations though, I should point out another
> factor: IOMMU/SWIOTLB space is in many cases a limited resource for
> all IO in flight at a particular time (SWIOTLB is typically 64MB). The
> number of hits when Googling for "Out of IOMMU space" indicates it is
> a problem that people do hit from time to time. From that perspective,
> anything that prevents unnecessary use of bounce buffers is a good
> thing.

Sure, but again, for USB 2.0 stuff, we don't have many I/O in flight, as
they are pretty slow devices.

USB 3.0 is different, and that's a different driver, and hopefully that
is all addressed already :)

thanks,

greg k-h
