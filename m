Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXBIXdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXBIXdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXBIXdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:33:53 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:53942 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbXBIXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:33:52 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4479FB80-8703-4BCA-925E-DA25B65EE916@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: DMA mapping API for non-system memory pools
Date: Fri, 9 Feb 2007 17:33:01 -0600
To: Russell King <rmk@arm.linux.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've been having a discussion on the linuxppc-dev list about how to  
handle IO memory that exists on some PPC SoC devices.  These IO  
memories behave like system memory but are faster to the processor or  
device needed accessing for things like buffer descriptors.

Here's an example in which allocation is done either via system  
memory or a specialized allocator for MURAM from drivers/net/ucc_geth.c:

(Yes, the system memory should be moved to use the dma mapping api)

                 if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
                         u32 align = 4;
                         if (UCC_GETH_TX_BD_RING_ALIGNMENT > 4)
                                 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
                         ugeth->tx_bd_ring_offset[j] =
                                 kmalloc((u32) (length + align),  
GFP_KERNEL);

                         if (ugeth->tx_bd_ring_offset[j] != 0)
                                 ugeth->p_tx_bd_ring[j] =
                                         (void*)((ugeth- 
 >tx_bd_ring_offset[j] +
                                         align) & ~(align - 1));
                 } else if (uf_info->bd_mem_part == MEM_PART_MURAM) {
                         ugeth->tx_bd_ring_offset[j] =
                             qe_muram_alloc(length,
                                             
UCC_GETH_TX_BD_RING_ALIGNMENT);
                         if (!IS_MURAM_ERR(ugeth->tx_bd_ring_offset[j]))
                                 ugeth->p_tx_bd_ring[j] =
                                     (u8 *) qe_muram_addr(ugeth->
                                                           
tx_bd_ring_offset[j]);
                 }

ideally all this would be handled via the dma mapping API, the  
question is how to convey to the API to use the IO memory vs the  
system memory?  Should we look at adding a new GFP_IOMEM flag or do  
something based on struct device?

Any ideas on direction (or if this is a solved problem elsewhere)  
would be appreciated.

Thanks

- kumar
