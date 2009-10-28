Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZJ1NVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZJ1NVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZJ1NVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:21:34 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:11647
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752571AbZJ1NVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:21:33 -0400
X-SpamScore: 6
X-BigFish: VPS6(z34a4jz1432R98dNzz1202hzz3198u327alz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KS87RK-04-1BA-02
X-M-MSG: 
Date: Wed, 28 Oct 2009 14:21:19 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       mingo@elte.hu
Subject: Re: [PATCH 0/10] x86: handle HW IOMMU initialization failure
 gracely
Message-ID: <20091028132119.GC5876@amd.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Oct 2009 13:21:19.0814 (UTC) FILETIME=[8961A660:01CA57D1]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 03:47:34PM +0900, FUJITA Tomonori wrote:
> If HW IOMMU initialization fails (Intel VT-d often does typically due
> to BIOS bugs), we fall back to nommu. It doesn't work for the majority
> since nowadays we have more than 4GB memory so we must use swiotlb
> instead of nommu.
> 
> The problem is that it's too late to initialize swiotlb when HW IOMMU
> initialization fails. We need to allocate swiotlb memory earlier from
> bootmem allocator. Chris explained the issue in detail:
> 
> http://marc.info/?l=linux-kernel&m=125657444317079&w=2
> 
> 
> The current x86 IOMMU initialization sequence is too complicated and
> handling the above issue makes it more hacky.
> 
> This series changes x86 IOMMU initialization sequence to handle the
> above issue cleanly.
> 
> The new x86 IOMMU initialization sequence are:
> 
> 1. initializing swiotlb (and setting swiotlb to 1) in the case of
> (max_pfn > MAX_DMA32_PFN && !no_iommu). dma_ops is set to
> swiotlb_dma_ops or nommu_dma_ops.
> 
> 2. calling the detection functions of all the IOMMUs
> 
> 3. the detection function sets x86_init.iommu.iommu_init to the IOMMU
> initialization function (so we can avoid calling the initialization
> functions of all the IOMMUs needlessly).
> 
> 4. if the IOMMU initialization function doesn't need to swiotlb then
> sets swiotlb to zero (e.g. the initialization is sucessful).
> 
> 5. if we find that swiotlb is set to zero, we free swiotlb resource.

I started to test this patchset. It breaks the iommu=soft selection to
force using swiotlb usage. On my machine always the AMD IOMMU driver
gots selected and initialized.

	Joerg


