Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0BTBag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:30:36 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:46820 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab0BTBab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UiF/5sJoLYbLRudUIR/TDUZDQY3jBjj1eryhieeQhHtGskXhtLP/c0XMxfNLSG6BZq
         EAc38jWczD51nXrW2WZJyDa1hdLsW9Xrk5yePgyT07bFE5FtwNY6q9A3+mBjTICTyxB4
         lw5x/CSP55QcGRQyNKM3+WGA5pSyqpGElla7Q=
MIME-Version: 1.0
In-Reply-To: <20100219035416.GA25645@kroah.com>
References: <4B7CAF95.6020306@gmail.com> <20100218042626.GB11649@kroah.com>
	 <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
	 <20100218052223.GA13254@kroah.com>
	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
	 <20100219004719.GA15965@kroah.com>
	 <51f3faa71002181946l69a9a307q930d6159e8e5ac77@mail.gmail.com>
	 <20100219035416.GA25645@kroah.com>
Date: Fri, 19 Feb 2010 19:30:30 -0600
Message-ID: <51f3faa71002191730s2bc8c9b2y46ce0befff771e63@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
From: Robert Hancock <hancockrwd@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>, dbrownell@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 9:54 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Feb 18, 2010 at 09:46:29PM -0600, Robert Hancock wrote:
>> On Thu, Feb 18, 2010 at 6:47 PM, Greg KH <greg@kroah.com> wrote:
>> >> > So you did not measure it?
>> >> >
>> >> > Hm, I guess this change must not be necessary :)
>> >>
>> >> I'll try and run some tests and see what I can quantify. However, I
>> >> only have 4GB of RAM on my machine (with a 1GB memory hole) and so a
>> >> random memory allocation only has a 25% chance of ending up in the
>> >> area where it would make a difference, so it may take a bit of doing.
>> >
>> > Without any good justification, including real tests being run, I can't
>> > take this patch, the risk is just too high.
>>
>> Again, this particular patch has essentially zero risk for anyone that
>> doesn't choose to experiment with the option. One can hardly say it
>> presents much of a long-term maintenance burden either..
>
> Then don't give them the option, as it doesn't seem needed :)
>
> Again, it is tough to remove options once you add them, so not adding
> them at all is the best thing to do.

I don't know why you would remove the option. Even if you someday
changed the default to 1, it would likely be a still idea to keep it
around for debugging purposes at least.

If you're complaining about options, ehci-hcd already has some which
are quite a bit more nebulous in usefulness than this one..

>
>> > And really, for USB 2.0 speeds, I doubt you are going to even notice
>> > this kind of overhead, it's in the noise.  Especially given that almost
>> > always the limiting factor is the device itself, not the host.
>>
>> Well, I do have some results. This is from running this "dd
>> if=/dev/sdg of=/dev/null bs=3800M iflag=direct" against an OCZ Rally2
>> USB flash drive, which gets about 30 MB/sec on read, with CPU-burning
>> tasks on all cores in the background. (The huge block size and
>> iflag=direct is to try to force more of the IO to happen to memory
>> above the 4GB mark.) With that workload, swiotlb_bounce shows up as
>> between 1.5 to 4% of the CPU time spent in the kernel according to
>> oprofile. Obviously with the 64-bit DMA enabled, that disappears. Of
>> course, the overall kernel time is only around 2% of the total time,
>> so that's a pretty small overall percentage.
>
> 2% is noise, right?  So overall you have not really shown any
> improvement.

What threshold of performance improvement would you rather see? It's
pretty clear that there will be a performance upside, even if small,
and no downside.

I honestly didn't expect as much resistance to a simple hardware
feature enablement patch, that has zero impact on anyone that doesn't
opt-in..

>
>> I'll try some tests later with a faster SATA-to-IDE device that should
>> stress things a bit more, but a huge difference doesn't seem likely.
>> One thing that's uncertain is just how much of the IO is needing to be
>> bounced - an even distribution of the buffer across all of physical
>> RAM would suggest 25% in this case, but I don't know an easy way to
>> verify that.
>>
>> Aside from speed considerations though, I should point out another
>> factor: IOMMU/SWIOTLB space is in many cases a limited resource for
>> all IO in flight at a particular time (SWIOTLB is typically 64MB). The
>> number of hits when Googling for "Out of IOMMU space" indicates it is
>> a problem that people do hit from time to time. From that perspective,
>> anything that prevents unnecessary use of bounce buffers is a good
>> thing.
>
> Sure, but again, for USB 2.0 stuff, we don't have many I/O in flight, as
> they are pretty slow devices.

Think that's a bit simplistic, if you have multiple devices active at
once, or multiple controllers (not at all uncommon these days, newer
Intel chipset machines have two EHCI controllers, with USB 1.x devices
handled through a logical hub with TT connected to each of them) that
can chew up more space.

>
> USB 3.0 is different, and that's a different driver, and hopefully that
> is all addressed already :)

Doesn't look like it, from the version in current -git anyway - I
don't see any calls to set DMA masks in the XHCI code so it will just
default to 32-bit. I imagine that'll hurt performance at 4.8 Gbps if
you've got lots of RAM..
