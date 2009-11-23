Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZKWId3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZKWId3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZKWId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:33:28 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48825 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZKWId2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:33:28 -0500
Date: Mon, 23 Nov 2009 09:33:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Don Brace <brace@beardog.cce.hp.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: change Cmd_sg_list.sg_chain_dma type to
	dma_addr_t
Message-ID: <20091123083333.GU8742@kernel.dk>
References: <20091118032022.GA6648@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118032022.GA6648@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17 2009, Alex Chiang wrote:
> A recent commit broke the ia64 build:
> 
> 	Author: Don Brace <brace@beardog.cce.hp.com>
> 	Date:   Thu Nov 12 12:50:01 2009 -0600
> 
> 	cciss: Add enhanced scatter-gather support.
> 
> because of this hunk:
> 
> 	--- a/drivers/block/cciss.h
> 	+++ b/drivers/block/cciss.h
> 	+struct Cmd_sg_list {
> 	+       SGDescriptor_struct     *sgchain;
> 	+       dma64_addr_t            sg_chain_dma;
> 	+       int                     chain_block_size;
> 	+};
> 
> The issue is that dma64_addr_t isn't #define'd on ia64.
> 
> The way that we're using Cmd_sg_list.sg_chain_dma is to hold an
> address returned from pci_map_single().
> 
> 	+               temp64.val = pci_map_single(h->pdev,
> 	+                                 h->cmd_sg_list[c->cmdindex]->sgchain,
> 	+                                 len, dir);
> 	+
> 	+               h->cmd_sg_list[c->cmdindex]->sg_chain_dma = temp64.val;
> 
> pci_map_single() returns a dma_addr_t too.
> 
> This code will still work even on a 32-bit x86 build, where
> dma_addr_t is defined to be a u32 because it will simply be
> promoted to the __u64 that temp64.val is defined as.
> 
> Thus, declaring Cmd_sg_list.sg_chain_dma as dma_addr_t is safe.

Applied for 2.6.32.

-- 
Jens Axboe

