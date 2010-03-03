Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0CCBnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:43:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:60957 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0CCBnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:43:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="600745064"
Subject: Re: [PATCH 2/2] ACPI, APEI, PCIE AER, use general HEST table
 parsing in AER firmware_first setup
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <4B8CF0D0.2000704@jp.fujitsu.com>
References: <1267494902-7193-1-git-send-email-ying.huang@intel.com>
	 <1267494902-7193-2-git-send-email-ying.huang@intel.com>
	 <4B8CC7BD.5020206@jp.fujitsu.com>
	 <1267521207.1640.130.camel@yhuang-dev.sh.intel.com>
	 <4B8CF0D0.2000704@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 09:43:49 +0800
Message-ID: <1267580629.1640.142.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 19:04 +0800, Hidetoshi Seto wrote:
> (2010/03/02 18:13), Huang Ying wrote:
> > On Tue, 2010-03-02 at 16:09 +0800, Hidetoshi Seto wrote:
> >> The aer_init() will be called for root ports, but not for end point
> >> devices or so on.  So please remain the firmware_first setup code in
> >> PCI core.  Otherwise endpoint drivers will get success on call of
> >> pci_enable_pcie_error_reporting() regardless of the firmware first.
> > 
> > Or we can call firmware_first setup code in
> > pci_enable_pcie_error_reporting(), because
> > 
> > 1. I think AER related code should be put in drivers/pci/pcie/aer
> > instead of PCI core or drivers/acpi, if it is possible.
> > 
> > 2. pci_setup_device is called so early, so that it is hard to do some
> > HEST related initialization (such as checking bad format) before it.
> 
> I understands the feeling, but before agreeing with your
> proposal, I'd like to have an answer of a question:
> 
>  - Is it necessary to setup the firmware_first flag
>    for an endpoint even if the endpoint's driver never
>    call pci_enable_pcie_error_reporting()?
> 
> According to the current implementation, there are no
> driver referring the firmware_first flag other than that
> it owns.  However I guess that the flag will be necessary
> for AER driver (i.e. aerdrv_core) in near future, because
> we can use the flag to determine whether the AER driver
> can check the device or not, when it is required to walk
> pci bus hierarchy to find an erroneous device.
> 
> For example, assume that there are 2 endpoints under a same
> root port.  One is (likely on-board) "firmware first" endpoint,
> with driver which does not call pci_enable_pcie_error_reporting()
> (because of no interest in AER, or just not implemented yet,
> anyway).  The other is (likely card seated on a slot) not
> firmware first, with better driver which can handle it's AER.
> If my understanding is correct and if everything goes well,
> errors on one should be reported via APEI while the other should
> be reported via AER driver.

Yes. I think this should be supported. How about something as follow?

struct pci_dev {
	...
	unsigned int __firmware_first:2;
	...
};

int pcie_aer_get_firmware_first(struct pci_dev *dev)
{
	if (!dev->__firmware_first)
		aer_set_firmware_first(dev);
	return dev->__firmware_first & 0x1;
}

Then we use pcie_aer_get_firmware_first() instead of dev->firmware_first
directly.

Best Regards,
Huang Ying


