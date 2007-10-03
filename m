Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXJCDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXJCDKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXJCDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:10:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34340
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754705AbXJCDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:10:24 -0400
Date: Tue, 02 Oct 2007 20:10:23 -0700 (PDT)
Message-Id: <20071002.201023.85411373.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] infiniband: add "dmabarrier" argument to
 ib_umem_get()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071003024906.GI26752@sgi.com>
References: <20071003024906.GI26752@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:49:06 -0700

> 
> Pass a "dmabarrier" argument to ib_umem_get() and use the new 
> argument to control setting the DMA_BARRIER_ATTR attribute on 
> the memory that ib_umem_get() maps for DMA.
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>

Acked-by: David S. Miller <davem@davemloft.net>

However I'm a little unhappy with how IA64 achieves this.

The last argument for dma_map_foo() is an enum not an int,
every platform other than IA64 properly defines the last
argument as "enum dma_data_direction".  It can take one
of several distinct values, it is not a mask.

This hijacking of the DMA direction argument is hokey at
best, and at worst is type bypassing which is going to
explode subtly for someone in the future and result in
a long painful debugging session.

Adding another argument could be painful to do this cleanly, but at
least with inline functions and macros it could just evaluate to
nothing on platforms that don't need it.

Either that, or we should turn the thing into an integer "flags"
across the board and audit every DMA mapping implementation so that it
can handle multiple bits being set.  But that's really ugly and
invites mistakes as I detailed above.

