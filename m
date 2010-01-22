Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701Ab0AVGid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab0AVGid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 01:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590Ab0AVGic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 01:38:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60194
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab0AVGib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 01:38:31 -0500
Date: Thu, 21 Jan 2010 22:38:41 -0800 (PST)
Message-Id: <20100121.223841.145479578.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: jarkao2@gmail.com, alan@lxorguk.ukuu.org.uk,
       shemminger@linux-foundation.org, mbreuer@majjas.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mchan@broadcom.com, pcnet32@verizon.net, romieu@fr.zoreil.com,
       mcarlson@broadcom.com, James.Bottomley@suse.de
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100122141018D.fujita.tomonori@lab.ntt.co.jp>
References: <20100122002053X.fujita.tomonori@lab.ntt.co.jp>
	<20100121184158.GA3085@del.dom.local>
	<20100122141018D.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 22 Jan 2010 14:11:29 +0900

> Even if 'offset' is zero, 'size' still matters, I think. If 'size' is
> not a multiple of the cache line size, it's possible that driver
> writers who aren't familiar with cache would be surprised (it depends
> on the way their drivers use buffers though).
> 
> The easiest way for 'completely safe sync for any driver writers' is
> asking for all the sync parameters must be the same as those passed
> into the single mapping API. If writes knows what they do, they can do
> a partial sync with sync_range API. That's the author intention, I
> guess.

This is not reasonable.

You have to think about how people actually use these
interfaces.

They have a large buffer, and if they receive a small request they
want to allocate a smaller buffer, copy into that smaller buffer, and
give the larger buffer back to the hardware.

It's an optimization, it performs better this way.

If you make it so that the DMA sync has to cover the entire large
buffer, the whole point of the optimization is taken away.

That makes no sense at all.

I know that when I designed and wrote the first implementation of the
PCI DMA interfaces, I sure as hell meant to allow partial DMA sync
operations.

I know this as a fact, because the first drivers ported over
to these interfaces were network drivers.  And I definitely
knew about the copy-break mechanism I describe above and how
networking drivers use such a scheme pretty much across the
board.

The DMA API documentation is wrong, it must be fixed to allow partial
syncs of arbitrary offsets and sizes.

The issue of cache line boundaries and such are the domain of the DMA
API implementation, and has absolutely no business in the definition
of these interfaces.  Nor should it be something driver authors have
to be knowledgable about, that would be completely unreasonable.
