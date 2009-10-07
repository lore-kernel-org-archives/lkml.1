Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbZJGASe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbZJGASe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZJGASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:18:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:28648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505AbZJGASd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,515,1249282800"; 
   d="scan'208";a="733666560"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@sous-sol.org" <chris@sous-sol.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Date: Tue, 6 Oct 2009 17:17:55 -0700
Subject: RE: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Topic: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Index: AcpG3qlZMS2EV6G4Rlabx1XxOCWuIQAAriEg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E3088733@orsmsx505.amr.corp.intel.com>
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
 <20091006234208.GB23140@sequoia.sous-sol.org>
In-Reply-To: <20091006234208.GB23140@sequoia.sous-sol.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Chris, I was not aware of these two functions.  I have made the following change:

	if (iommu_found() || xen_initial_domain())
		pci_enable_acs(dev);

xen_intial_domain() should take care of dom0 case.  We just make the rough assumption that P2P upstream forwarding is needed if we are running on top of xen HV - similar to what we are doing for native kernel case.

If this is ok, I'm going to re-spin the patch.  Separate out xen_initial_domain() modification since it is predicated on Jeremy's xen.h patch.

-----Original Message-----
From: Chris Wright [mailto:chrisw@sous-sol.org] 
Sent: Tuesday, October 06, 2009 4:42 PM
To: Kay, Allen M
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx; chris@sous-sol.org; jeremy@goop.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding

* Allen Kay (allen.m.kay@intel.com) wrote:
> +#ifdef CONFIG_DMAR
> +extern int iommu_detected;
> +#endif

This should not be needed.

> +
> +#ifdef CONFIG_XEN
> +extern int xen_domain_type;
> +#endif

Nor this (there's already a check for is dom0 called xen_initial_domain(),
but unclear it's relevant yet for this patch).

> +
> +	/* Enable ACS P2P upstream forwarding if HW iommu is detected */
> +	if (iommu_detected)

I think you'd want iommu_found() instead.  To avoid, e.g., GART
triggering this one.

> +		pci_enable_acs(dev);
> +
> +#ifdef CONFIG_XEN
> +	/* HW iommu is not visible in xen dom0 */
> +	if (xen_domain_type)
> +		pci_enable_acs(dev);

could do this (xen_initial_domain()) above, but it's only relevant for
dom0 (so not needed yet?), and really seems to like it should be done by hv.

thanks,
-chris
