Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXLRFQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXLRFQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXLRFQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:16:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:54756 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbXLRFQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:16:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="446256759"
Date: Tue, 18 Dec 2007 13:08:09 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>, "Gross, Mark" <mark.gross@intel.com>
Subject: [RFC][PATCH 0/4] enabling graphics memory dma remapping
Message-ID: <20071218050809.GA12564@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
	"Gross, Mark" <mark.gross@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel IOMMU (a.k.a VT-d) is under rapid deployment on desktop
and mobile platforms. As platform provides multiple dma remap
engines for devices like those lives on south bridge (net, sound,
etc.), and we also have one engine specific to graphics device.

If this engine is functioning, the access to graphics memory
routine is to first look up in GART table, which return virtual
dma address that will further be route to graphics DMAR engine,
which then looking up DMAR table to get real physical address.

Current intel iommu function in kernel is providing a graphics
workaround kernel config (CONFIG_DMAR_GFX_WA) to make a 1:1 mapping
initialization for graphics device, so what we fill in GART table
got from agpgart page alloc is identical to virtual dma address in
DMAR table. No change needs to be made for graphics driver.

Following patches try to add dma remapping function to agpgart
module, so we won't depend on intel iommu graphics workaround. 
As DMAR is only available on x86_64 now, so these patches can only
work for x86_64 system.

Here're three patches below:

- intel_iommu-explicit-export-current-graphics-dmar-status.patch
  
  This exports current status of graphics dma remap engine, which
  depends on current platform iommu support, kernel config or runtime
  config. This info will be used in agp module for detect whether
  we should do remapping or not.

- AGP-Add-generic-support-for-graphics-dma-remapping.patch

  This adds new hooks into agp bridge driver to do map/unmap when
  bind/unbind memory into GART table. The aim is to provide generic
  interfaces to let driver implement hardware specific operations.

- AGP-intel_agp-add-support-for-graphics-dma-remapping.patch

  This implements graphics dma remapping support in intel_agp module,
  current only desktop chipset G33 series can use it.

Thanks.

