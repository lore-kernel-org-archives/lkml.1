Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZC3B4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZC3B4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZC3Bzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:55:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:30374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZC3Bzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,443,1233561600"; 
   d="scan'208";a="501798588"
Date: Mon, 30 Mar 2009 09:56:46 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] PCI: support the ATS capability
Message-ID: <20090330015646.GA10521@yzhao-otc.sh.intel.com>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com> <20090326161556.05cdd801@hobbes> <20090329135131.GS8014@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329135131.GS8014@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 09:51:31PM +0800, Matthew Wilcox wrote:
> On Thu, Mar 26, 2009 at 04:15:56PM -0700, Jesse Barnes wrote:
> > >   2, avoid using pci_find_ext_capability every time when reading ATS
> > >      Invalidate Queue Depth (Matthew Wilcox)
> 
> I asked a question about how that was used, and got back a version which
> changed how it was done.  I still don't have an answer to my question.

VT-d hardware is designed as that the Invalidate Queue Depth is used
every time when the software prepares the Invalidate Request descriptor.
This happens when the device IOMMU mapping changes (i.e. device driver
calls DMA map/unmap if the device is use by the host; or when a guest
is started/destroyed if the device is assigned to this guest).

Given the DMA map/unmap are used very frequently, I suppose the queue
depth should be cached somewhere. And it used to be cached in the VT-d
private data structure (before v3) because I'm not sure about how the
IOMMU hardware from other vendors use the queue depth.

After you commented the code, I checked the AMD/IBM/Sun IOMMU: AMD IOMMU
also uses the invalidate queue for every Invalidate Request descriptor;
IBM/Sun IOMMUs don't look like supporting the ATS. So it's reasonable to
cache the queue depth in the PCI subsystem since all IOMMUs that support
the ATS use the queue depth in the same way (very frequently), right?
