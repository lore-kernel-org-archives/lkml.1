Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbZBMRun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbZBMRun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbZBMRuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:50:19 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59570 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759858AbZBMRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:50:16 -0500
Date: Fri, 13 Feb 2009 10:49:59 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090213174958.GD16841@parisc-linux.org>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com> <1234256355-23153-2-git-send-email-yu.zhao@intel.com> <877i3uwa0j.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877i3uwa0j.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 05:56:44PM +0100, Andi Kleen wrote:
> > +	pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
> > +	if (ctrl & PCI_SRIOV_CTRL_VFE) {
> > +		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
> > +		msleep(100);
> 
> That's really long. Hopefully that's really needed.

Yes and no.  The spec says:

  To allow components to perform internal initialization, system software
  must wait for at least 100 ms after changing the VF Enable bit from
  a 0 to a 1, before it is permitted to issue Configuration Requests to
  the VFs which are enabled by that VF Enable bit.

So we don't have to wait here, but we do have to wait before exposing
all these virtual functions to the rest of the system.  Should we add
more complexity, perhaps spawn a thread to do it asynchronously, or add
0.1 seconds to device initialisation?  A question without an easy
answer, iMO.

> > +
> > +	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> > +	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total);
> > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
> > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
> > +	if (!offset || (total > 1 && !stride))
> > +		return -EIO;
> > +
> > +	pci_read_config_dword(dev, pos + PCI_SRIOV_SUP_PGSIZE, &pgsz);
> > +	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
> > +	pgsz &= ~((1 << i) - 1);
> > +	if (!pgsz)
> > +		return -EIO;
> 
> All the error paths don't seem to undo the config space writes.
> How will the devices behave with half initialized context?

I think we should clear the VF_ENABLE bit.  That action is also fraught
with danger:

  If software Clears VF Enable, software must allow 1 second after VF
  Enable is Cleared before reading any field in the SR-IOV Extended
  Capability or the VF Migration State Array (see Section 3.3.15.1).

Another msleep(1000) here?  Not pretty, but what else can we do?

Not to mention the danger of something else innocently using lspci -xxxx
to read a field in the extended capability -- I suspect we also need to
block user config accesses before clearing this bit.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
