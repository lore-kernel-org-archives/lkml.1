Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYKVQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYKVQlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 11:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbYKVQlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 11:41:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:40788 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591AbYKVQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 11:41:01 -0500
Date: Sun, 23 Nov 2008 01:40:39 +0900
To: fenghua.yu@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com, dwmw2@infradead.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: RE: [PATCH] IA64: fix VT-d dma_mapping_error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB88EAB57E1@orsmsx505.amr.corp.intel.com>
References: <20081122215822A.fujita.tomonori@lab.ntt.co.jp>
	<A6AD88C3F2289247BE726C37303E1EB88EAB57E1@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081123014037A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 08:18:02 -0800
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

>  
> >+int intel_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
> >+{
> >+	return !dma_addr;
> >+}
> 
> The implementation of inte_dma_mapping_error is incomplete.
> 
> Dma_addr is valid only when it belongs to hwdev's domain. This is all about VT-d isolation fundamental.
> 
> +int intel_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
> +{
> +        struct pci_dev *pdev = to_pci_dev(hwdev);
> +        struct dmar_domain *domain;
> +        struct iova *iova;
> +
> +        domain = find_domain(pdev);
> +
> +        iova = find_iova(&domain->iovad, IOVA_PFN(dma_addr));
> +        if (!iova)
> +                return -EINVAL;
> +	   return 0;
> +}

Hmm, intel_dma_mapping_error is used to test only the value that
intel_map_single() returns. If intel_map_single() returns a non-zero
dma address, it belongs to hwdev's domain. So intel_dma_mapping_error
can simply return 1 (failure) if the dma_addr is zero.

Do I misunderstand something?
