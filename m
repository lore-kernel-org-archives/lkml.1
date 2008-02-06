Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYBFElV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYBFElV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 23:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbYBFElK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 23:41:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59047
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbYBFElJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 23:41:09 -0500
Date: Tue, 05 Feb 2008 20:41:38 -0800 (PST)
Message-Id: <20080205.204138.107606929.davem@davemloft.net>
To: tomof@acm.org
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: more iommu sg merging fallout
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sparc64 change:

    commit fde6a3c82d67f592eb587be4d12222b0ae6d4321
    Author: FUJITA Tomonori <tomof@acm.org>
    Date:   Mon Feb 4 22:28:02 2008 -0800

    iommu sg merging: sparc64: make iommu respect the segment size limits
    
    This patch makes iommu respect segment size limits when merging sg
    lists.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Cc: Jeff Garzik <jeff@garzik.org>
    Cc: James Bottomley <James.Bottomley@steeleye.com>
    Acked-by: Jens Axboe <jens.axboe@oracle.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

has significant errors and is going to eat people's disks, as it just
nearly did to mine.

Typically what you'll see are NULL pointer derefernces in
dma_4v_map_sg() and dma_4u_map_sg() and then the kernel usually craps
on your superblock very shortly thereafter.

The changeset above modified only prepare_sg() but that is only the
first pass of the SG mapping algorithm of the sparc64 IOMMU layer.

The second pass that fills in the entries depends upon how the first
pass does things.  So if you change the first pass decision making you
have to update the second pass's as well.

That second pass is implemented in fill_sg() (there is a version in
both arch/sparc64/kernel/iommu.c and arch/sparc64/kernel/pci_sun4v.c),
which probably needs new logic as was added to prepare_sg() to handle
dma_get_max_seg_size().
