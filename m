Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZAFKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZAFKWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZAFKWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:22:25 -0500
Received: from sh.osrg.net ([192.16.179.4]:47891 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZAFKWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:22:24 -0500
Date: Tue, 6 Jan 2009 19:22:08 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] remove map_single and unmap_single in struct
 dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090105180038.GD14298@8bytes.org>
References: <1231166848-20149-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1231166848-20149-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20090105180038.GD14298@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090106192022D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 19:00:38 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> Is it the right way to implement map_single in terms of map_page? Doing
> this you optimize for the map_page case. But a grep in drivers/ shows:
> 
> linux/drivers $ grep -r _map_page *|wc -l
> 126
> linux/drivers $ grep -r _map_single *|wc -l
> 613

The comparison is irrelevant since dma_map_page and dma_map_single
have different purposes.

If passing virtual memory address to an IOMMU is enough (and
convenient), then drivers use dma_map_single.

For some purposes, drivers need to pass a page frame and use
dma_map_page (or dma_map_sg).

We could have two hooks in dma_map_ops struct for dma_map_single and
dma_map_page. Say, we have map_single and map_page hooks. But the
map_page hook can be used to support both dma_map_single and
dma_map_page. Note that the map_single hook can't do that since it use
a virtual address as an argument. That's why I have only the map_page
hook in dma_map_ops struct.

As X86 does now, we could have map_single hook that use a physical
address to handle both dma_map_single and dma_map_page. However, it's
confusing since it means that the arguments of dma_map_single and its
hook (map_single) is inconsistent.


> There are a lot more users of map_single than of map_page. I think its
> better to optimize for the map_single case and implement map_page in
> terms of map_single.

As I wrote above, it doesn't make sense.
