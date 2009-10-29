Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZJ2Prd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZJ2Prd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZJ2Prc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:47:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28595 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZJ2Prc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:47:32 -0400
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big
	range for pcie devices
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <m1bpjqb5dj.fsf@fess.ebiederm.org>
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>
	 <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>
	 <4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>
	 <4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>
	 <4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>
	 <m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>
	 <m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org>
	 <m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org>
	 <4AE8C4BF.8040306@kernel.org> <m1my3aboon.fsf@fess.ebiederm.org>
	 <1256822508.30701.41.camel@dc7800.home>  <m1bpjqb5dj.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 09:43:08 -0600
Message-Id: <1256830988.30701.55.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 08:13 -0700, Eric W. Biederman wrote:
> Bjorn Helgaas <bjorn.helgaas@hp.com> writes:
> 
> > On Thu, 2009-10-29 at 01:16 -0700, Eric W. Biederman wrote:
> >> Yinghai Lu <yinghai@kernel.org> writes:
> >> >
> >> > after closing look up the code, it looks it will not break your setup.
> >> >
> >> > 1. before the patches:
> >> > a. when master card is inserted, all bridge in that card will get assigned with min_size
> >> > b. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
> >> >
> >> > 2. after the patches: v5
> >> > a. booted up, all leaf bridge mmio get clearred.
> >> > b. when master card is inserted, all bridge in that card will get assigned with min_size, and master bridge will be sum of them
> >> > c. when new cards is inserted to those slots in master card, will get assigned in the bridge size.
> >> >
> >> > can you check those two patches in your setup to verify it?
> >> 
> >> I have a much simpler case I will break, as I tried something similar by accident.
> >> 
> >> AMD cpu MCP55 with one pcie port setup as hotplug.
> >> The system only has 2GB of RAM.  So plenty of space for pcie devices.
> >> 
> >> If the firmware assigns nothing and linux at boot time assigns the pci mmio space:
> >> Reads from the bar of the hotplugged device work
> >> Writes to the bar of the hotplugged device, cause further writes to go to lala land.
> >> 
> >> So I had to have the firmware make the assignment, because only it knows the
> >> details of the hidden AMD bar registers for each hypertransport chain etc.
> >
> > Do you mean you had to have firmware program a hot-added device, or just
> > that firmware had to program the apertures of the root port that was
> > present at boot, even though it had no devices below it?
> 
> Firmware had to program the apertures of the root port that was present
> at boot, even though it had no devices below it.
> 
> > Firmware normally supplies ACPI _CRS information that tells us how it
> > programmed the host bridge windows.  On x86, Linux normally ignores that
> > and just assumes a range based on memory size.  If we paid attention to
> > it (as with "pci=use_crs"), it's likely that we could do a better job of
> > doing this setup.
> >
> > Or, of course, we could add a Linux driver that knows about "the hidden
> > AMD bar registers."  But I think that should be a last resort, for when
> > firmware supplied incorrect _CRS information.
> 
> In this case there was no ACPI, and even if there was correct _CRS information
> it would have said only those addresses routed to bars/apertures on the
> root bridge was routed to the MCP55.  So while it looked like we had gobs
> of unallocated space we could use.  In practice we did not.

I know this is a hypothetical case since you don't have ACPI, but I'm
curious about this.

I assume the magic AMD BARs only affect the host bridge, and that the
downstream root ports look like standard PCI-to-PCI bridges.  If that's
the case, and if we have correct descriptions of the host bridge
apertures, Linux should theoretically be able to do as well as firmware.

But you seem to be suggesting that even with a correct host bridge
description, there's space that *looks* available but is not.  I don't
understand how this can be.

Bjorn


