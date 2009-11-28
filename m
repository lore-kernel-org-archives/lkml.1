Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZK1GRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZK1GRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZK1GRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:17:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:37082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZK1GRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:17:49 -0500
Subject: Re: [stable][PATCH] PCIe hot-plug for Intel IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jbarnes@virtuousgeek.org,
       stable@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440911111327o49bb2b09xc8ab801ce281d04@mail.gmail.com>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
	 <20091111152306.GA29256@linux-os.sc.intel.com>
	 <86802c440911111327o49bb2b09xc8ab801ce281d04@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 06:17:37 +0000
Message-ID: <1259389057.3691.2186.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 13:27 -0800, Yinghai Lu wrote:
> On Wed, Nov 11, 2009 at 7:23 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> > To support PCIe hot plug in IOMMU, we register a notifier to respond to device
> > change action.
> >
> > When the notifier gets BUS_NOTIFY_UNBOUND_DRIVER, it removes the device from its
> > DMAR domain.
> >
> > A hot added device will be added into an IOMMU domain when it first does IOMMU
> > op. So there is no need to add more code for hot add.
> >
> > Without the patch, after a hot-remove, a hot-added device on the same slot will
> > not work.
> >
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> Tested-by: Yinghai Lu <yinghai@kernel.org>

But not with 'intel_iommu=igfx_off', I note. The call to find_domain()
will oops when it runs on the graphics device with ->archdata.iommu ==
DUMMY_DEVICE_DOMAIN_INFO (== -1). All other calls to find_domain() are
guaranteed not to happen for such devices.

One might argue that find_domain() should cope, but do we really want to
be doing that extra check in the unmap fast path?

Testing this fix now...

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1840a05..f44a015 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3228,6 +3228,9 @@ static int device_notifier(struct notifier_block *nb,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 
+	if (iommu_no_mapping(dev))
+		return 0;
+
 	domain = find_domain(pdev);
 	if (!domain)
 		return 0;


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

