Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbZAPJbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbZAPJbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbZAPJam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:30:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbZAPJaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:30:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Fri, 16 Jan 2009 10:29:57 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901152011.00216.rjw@sisk.pl> <4970385B.7030404@jp.fujitsu.com>
In-Reply-To: <4970385B.7030404@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161029.58647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Hidetoshi Seto wrote:
> Rafael J. Wysocki wrote:
> > On Thursday 15 January 2009, Rafael J. Wysocki wrote:
> >> On Thursday 15 January 2009, Rafael J. Wysocki wrote:
> >>> On Thursday 15 January 2009, Kenji Kaneshige wrote:
> >>>> Hidetoshi Seto wrote:
> >>>>> Rafael J. Wysocki wrote:
> >>>>>> On Wednesday 14 January 2009, Rafael J. Wysocki wrote:
> >>>>>>> On Wednesday 14 January 2009, Kenji Kaneshige wrote:
> >>>>>> [...]
> >>>>>>>> I'm sorry but I don't understand what the problem is.
> >>>>>>>> Do you mean pci_disable_msix() doesn't work on some platforms?
> >>>>>>> No, I don't.  It was just confusion on my side, sorry.
> >>>>>>>
> >>>>>>> Please have a look at the new version of the patch I sent yesterday
> >>>>>>> (http://marc.info/?l=linux-pci&m=123185510828181&w=4).
> >>>>>> BTW, in your patch the first dummy pci_enable_msix() allocates just one
> >>>>>> vector, which means that the contents of both
> >>>>>> msix_entries[idx_hppme].entry and msix_entries[idx_aer].entry will be the same,
> >>>>>> if my reading of the spec (PCI 3.0 in this case) is correct.
> >>>>> According to PCI 3.0 implementation note "Handling MSI-X Vector Shortage,"
> >>>>> it seems your reading is not correct.
> >>>>>
> >>>>> Assume that the port have 4 entries([0-3]) in MSI-X table, and that entry[2]
> >>>>> for hotplug/PME and entry[3] for AER, and that kernel only allocates 2 vector.
> >>>>> Spec says that the port could be designed for software to configure entries
> >>>>> assigning vectors{A,B} to multiple entries as ABAB, AABB, ABBB etc. 
> >>>>>
> >>>>> So if there is just one vector, it could be AAAA.
> >>> Our pci_enable_msix() doesn't do that.  It will always do A---.
> 
> Just above the implementation note, the spec says:
>   "Software is permitted to configure multiple MSI-X Table entries
>    with the same vector, and this may indeed be necessary when fewer
>    vectors are allocated than requested."
> while "software" refers to either system software or device driver software.
> 
> So, yes, the our current implementation of system software (=Linux kernel)
> doesn't do that.
> However I'd like to note that doing that by "software" is not prohibited
> in PCI 3.0.
> 
> >>>> BTW, I don't think pci_enable_msix() allows this kind of configuration.
> >>>> With the dummy pci_enable_msix() in my patch, it would be A---, I think.
> >>> And that exactly is why I'm not sure it's correct.
> >>>
> >>> Namely, if only the first entry is configured, the device is only able to use
> >>> one vector, represented by this entry, for any purpose.  Now, for instance, for
> >>> PCIE_CAPABILITIES_REG, there are two possibilities:
> >>> (1) the value in the register always points to the _valid_ entry in the MSI-X
> >>>     table and that would be the first one,
> >>> (2) the value in the register may point to an _invalid_ entry (1 - 3).
> 
> The "invalid entry" is not defined.

s/invalid/unused/ (or masked permanently)

> >>> You seem to assume that (2) is the case, but I'm not sure (that should follow
> >>> from the PCI Express spec, but it clearly doesn't, at least I couldn't find
> >>> any pointer in the spec).  IMO it wouldn't make sense, because the port
> >>> wouldn't have been able to generate interrupts for this service if only one
> >>> vector had been configured.
> >>>
> >>> Still, even though (2) is the case, but both PCIE_CAPABILITIES_REG and
> >>> PCI_ERR_ROOT_STATUS just happen to point to the same entry, which very well may
> >>> be possible, the second pci_enable_msix() in your patch will fail.
> >>>
> >>> In any case, I think we should
> >>> (a) get the number of the port's MSI-X table entries _first_, without enabling
> >>>     MSI-X,
> 
> We cannot do this because both of PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS
> will indicate the number for MSI, not for MSI-X without enabling MSI-X.

Yes, we can.  We don't read PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS at
this point yet and the number of entries in the MSI-X table is constant
(read-only), so we can read it even before enabling MSI-X.  Actually, our MSI-X
code does that already anyway.

> >>> (b) allocate as many MSI-X vectors as indicated by this number, even though
> >>>     some of them may not be used,

(b) should be: call pci_enable_msix() with the last argument equal to the
number of entries in the MSI-X table or 32, whichever is smaller.

> >>> (c) use PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS to check
> >>>     which vector has been allocated to which service.
> >> (d) mask the unused vectors.
> > 
> > However, it's probably simpler to do something like in your patch, although
> > I don't like the dummy enabling of MSI-X at all.
> 
> How about this?
> 
>   #define PCIE_MSIX_ENTRY_HPPME MAGIC_NUMBER_1
>   #define PCIE_MSIX_ENTRY_AER   MAGIC_NUMBER_2
> 
>   struct msix_entry msix_entries[] =
>                         {{0, PCIE_MSIX_ENTRY_HPPME}, {0, PCIE_MSIX_ENTRY_AER}};
>   status = pci_enable_msix(dev, msix_entries, nvec);
> 
> And modify pci_enable_msix() to handle these magic numbers.

Quite frankly, I prefer the procedure described above in (a) - (d).  I'll try
to implement it and we'll see how it looks like.

Thanks,
Rafael
