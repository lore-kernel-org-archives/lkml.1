Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZJ1R43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZJ1R43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZJ1R42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:56:28 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:9405 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZJ1R41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:56:27 -0400
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big
	range for pcie devices
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4AE88305.8020207@kernel.org>
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>
	 <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>
	 <4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>
	 <4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>
	 <4AE80170.6030402@jp.fujitsu.com>  <4AE88305.8020207@kernel.org>
Content-Type: text/plain
Date: Wed, 28 Oct 2009 11:52:39 -0600
Message-Id: <1256752359.30701.12.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 10:44 -0700, Yinghai Lu wrote:
> Kenji Kaneshige wrote:
> > Yinghai Lu wrote:
> >> Yinghai Lu wrote:
> >>> Kenji Kaneshige wrote:
> >>>> I understand you need to touch I/O base/limit and Mem base/limit. But
> >>>> I don't understand why you also need to update bridge's BARs. Could
> >>>> you please explain a little more about it?
> >>>>
> >>>> Just in case, my terminology "bridge's BARs" is Base Address Register
> >>>> 0 (offset 0x10) and Base Address Register 1 (offset 0x14) in the
> >>>> (type 1) configuration space header of the bridge.
> >>> i mean 0x1c, 0x20, 0x28
> >>>
> >>> did not notice that bridge device's 0x10, 0x14 are used...
> >>> if port service need to use 0x10, 0x14, and the device is enabled, we
> >>> should touch 0x10, and 0x14.
> >>
> >> after check the code, if
> >> pci_bridge_assign_resources ==> pdev_assign_resources_sorted ==> 
> >> pdev_sort_resources
> >>
> >> will not touch 0x10 and 0x14, if those resource is claimed by port
> >> service.
> >>
> >> /* Sort resources by alignment */
> >> void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
> >> {               int i;
> >>                         for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> >>                 struct resource *r;
> >>                 struct resource_list *list, *tmp;
> >>                 resource_size_t r_align;
> >>                                 r = &dev->resource[i];
> >>                                         if (r->flags &
> >> IORESOURCE_PCI_FIXED)
> >>                         continue;
> >>                         if (!(r->flags) || r->parent)
> >>                         continue;
> >>                
> >> r->parent != NULL, will make it skip those two.
> >>
> >> So -v3 should be safe.
> >>
> > 
> > Thank you for the clarification.
> > 
> > But I still don't understand the whole picture of your set of
> > changes. Let me ask some questions.
> > 
> > In my understanding of your set of changes, if there is a PCIe
> > switch with some hot-plug slots and all of those slots are empty,
> > I/O and Memory resources assigned by BIOS are all released at
> > the boot time. For example, suppose the following case.
> > 
> >                bridge(A)
> >                   |
> >        -----------------------
> >        |                     |
> >     bridge(B)             bridge(C)
> >        |                     |
> >      slot(1)               slot(2)
> >      (empty)               (empty)
> > 
> >   bridge(A): P2P bridge for switch upstream port
> >   bridge(B): P2P bridge for switch downstream port
> >   bridge(C): P2P bridge for switch downstream port
> > 
> > In the above example, I/O and Mem resource assigned to bridge(A),
> > bridge(B) and bridge(C) are all released at the boot time. Correct?
> > 
> > Then, when a adapter card is hot-added to slot(1), I/O and Mem
> > resources enough for enabling the hot-added adapter card is assigned
> > to bridge(A), bridge(B) and the adapter card. Correct?
> > 
> > Then, when an another adpater card is hot-added to slot(2), we
> > need to assign enough resource to bridge(C) and the new card.
> > But bridge(A) doesn't have enough resource for bridge(C) and
> > the new card. In addition, all bridge(A) and bridge(B) and the
> > adapter card on slot(1) are already working. How do you assign
> > resource to bridge(C) and the card on slot(2)?
> > 
> 
> thanks, will update the patches to only handle leaf bridge, and don't touch min_size etc.

When you do, can you please add printks showing the changes you're
making to bridge resources?  I think these events are infrequent, and
knowing about the changes is vital to debugging problems.

Bjorn


