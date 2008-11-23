Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYKWGcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYKWGcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 01:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYKWGcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 01:32:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:40582 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYKWGcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 01:32:35 -0500
Date: Sun, 23 Nov 2008 15:32:03 +0900
To: fenghua.yu@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com, dwmw2@infradead.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: RE: [PATCH] IA64: fix VT-d dma_mapping_error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB88EAB5850@orsmsx505.amr.corp.intel.com>
References: <A6AD88C3F2289247BE726C37303E1EB88EAB57E1@orsmsx505.amr.corp.intel.com>
	<20081123014037A.fujita.tomonori@lab.ntt.co.jp>
	<A6AD88C3F2289247BE726C37303E1EB88EAB5850@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081123153159S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 22:10:05 -0800
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> >Hmm, intel_dma_mapping_error is used to test only the value that
> >intel_map_single() returns. If intel_map_single() returns a non-zero
> >dma address, it belongs to hwdev's domain. So intel_dma_mapping_error
> >can simply return 1 (failure) if the dma_addr is zero.
> 
> Then there is no usage of hwdev which is one of two parameters in intel_dma_mapping_error?

Yes, and that's how VT-d dma_mapping_error() works on X86_64.

Note that we use hwdev in the following way, see
arch/x86/kernel/include/asm/dma-mapping.h

static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
{
#ifdef CONFIG_X86_32
	return 0;
#else
	struct dma_mapping_ops *ops = get_dma_ops(dev);
	if (ops->mapping_error)
		return ops->mapping_error(dev, dma_addr);

	return (dma_addr == bad_dma_address);
#endif
}

dma_mapping_error uses a point to struct device to choose a proper
dma_mapping_ops.


> Maybe checking dma_addr only is good enough for the function? At least it's fast to check errors.

Yeah, that's what my patch does (and what x86 VT-d dma_mapping_error()
does).
