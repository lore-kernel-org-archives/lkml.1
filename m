Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZBNCsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZBNCsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 21:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZBNCse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 21:48:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:10870 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZBNCsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 21:48:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,204,1233561600"; 
   d="scan'208";a="489944578"
Date: Fri, 13 Feb 2009 20:47:50 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090213124750.GB16067@yzhao-otc.sh.intel.com>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com> <1234256355-23153-2-git-send-email-yu.zhao@intel.com> <877i3uwa0j.fsf@basil.nowhere.org> <20090213174958.GD16841@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213174958.GD16841@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 01:49:59AM +0800, Matthew Wilcox wrote:
> On Fri, Feb 13, 2009 at 05:56:44PM +0100, Andi Kleen wrote:
> > > +	pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
> > > +	if (ctrl & PCI_SRIOV_CTRL_VFE) {
> > > +		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
> > > +		msleep(100);
> > 
> > That's really long. Hopefully that's really needed.
> 
> Yes and no.  The spec says:
> 
>   To allow components to perform internal initialization, system software
>   must wait for at least 100 ms after changing the VF Enable bit from
>   a 0 to a 1, before it is permitted to issue Configuration Requests to
>   the VFs which are enabled by that VF Enable bit.
> 
> So we don't have to wait here, but we do have to wait before exposing
> all these virtual functions to the rest of the system.  Should we add
> more complexity, perhaps spawn a thread to do it asynchronously, or add
> 0.1 seconds to device initialisation?  A question without an easy
> answer, iMO.

This clears the VF Enable bit only if the BIOS has set it, so it doesn't
always happen. Actually the `msleep(100)' should be `ssleep(1)' here,
according to the spec you showed us below. I remembered the waiting time
incorrectly as 100ms which is the requirment for setting the VF Enable
bit rather than clearing it.

> > > +
> > > +	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> > > +	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total);
> > > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
> > > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
> > > +	if (!offset || (total > 1 && !stride))
> > > +		return -EIO;
> > > +
> > > +	pci_read_config_dword(dev, pos + PCI_SRIOV_SUP_PGSIZE, &pgsz);
> > > +	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
> > > +	pgsz &= ~((1 << i) - 1);
> > > +	if (!pgsz)
> > > +		return -EIO;
> > 
> > All the error paths don't seem to undo the config space writes.
> > How will the devices behave with half initialized context?
> 
> I think we should clear the VF_ENABLE bit.  That action is also fraught
> with danger:

The VF Eanble bit hasn't been set yet :-) Actually the spec forbids the
s/w to write those registers (NumVFs, Supported Page Size, etc.) when the
enabling bit is set.

> 
>   If software Clears VF Enable, software must allow 1 second after VF
>   Enable is Cleared before reading any field in the SR-IOV Extended
>   Capability or the VF Migration State Array (see Section 3.3.15.1).
> 
> Another msleep(1000) here?  Not pretty, but what else can we do?
> 
> Not to mention the danger of something else innocently using lspci -xxxx
> to read a field in the extended capability -- I suspect we also need to
> block user config accesses before clearing this bit.

Yes, we should block user config access.
