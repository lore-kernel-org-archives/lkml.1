Return-Path: <linux-kernel-owner+w=401wt.eu-S932542AbYBFXRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbYBFXRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764265AbYBFXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:12:57 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58990 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764252AbYBFXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:12:53 -0500
To: davem@davemloft.net
Cc: tomof@acm.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: more iommu sg merging fallout
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080205.204138.107606929.davem@davemloft.net>
References: <20080205.204138.107606929.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080207081236V.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 07 Feb 2008 08:12:36 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 20:41:38 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> 
> The sparc64 change:
> 
>     commit fde6a3c82d67f592eb587be4d12222b0ae6d4321
>     Author: FUJITA Tomonori <tomof@acm.org>
>     Date:   Mon Feb 4 22:28:02 2008 -0800
> 
>     iommu sg merging: sparc64: make iommu respect the segment size limits
>     
>     This patch makes iommu respect segment size limits when merging sg
>     lists.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: Jeff Garzik <jeff@garzik.org>
>     Cc: James Bottomley <James.Bottomley@steeleye.com>
>     Acked-by: Jens Axboe <jens.axboe@oracle.com>
>     Cc: "David S. Miller" <davem@davemloft.net>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> has significant errors and is going to eat people's disks, as it just
> nearly did to mine.

Really sorry about it.


> Typically what you'll see are NULL pointer derefernces in
> dma_4v_map_sg() and dma_4u_map_sg() and then the kernel usually craps
> on your superblock very shortly thereafter.
> 
> The changeset above modified only prepare_sg() but that is only the
> first pass of the SG mapping algorithm of the sparc64 IOMMU layer.
> 
> The second pass that fills in the entries depends upon how the first
> pass does things.  So if you change the first pass decision making you
> have to update the second pass's as well.
>
> That second pass is implemented in fill_sg() (there is a version in
> both arch/sparc64/kernel/iommu.c and arch/sparc64/kernel/pci_sun4v.c),
> which probably needs new logic as was added to prepare_sg() to handle
> dma_get_max_seg_size().

PARISC, Alpha, and IA64 IOMMUs use the two-pass algorithm like SPARC
but their first pass decides how to merge sg entires (and stores that
information in the sg entries), then the second pass simpliy follows
it (Hopefully I understand these IOMMUs correctly, or else I break
them too).

I'll try this work again for 2.6.26. The SPARC IOMMUs are the most
complicated and seems that few people tests the -mm SPARC code. So I
guess that I need to find a SPARC box...

Thanks,
