Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXBJJjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXBJJjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXBJJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:39:46 -0500
Received: from rubidium.solidboot.com ([81.22.244.175]:34718 "EHLO
	mail.solidboot.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXBJJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:39:45 -0500
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 04:39:45 EST
Date: Sat, 10 Feb 2007 11:15:21 +0200
From: Imre Deak <imre.deak@solidboot.com>
To: linux-kernel@vger.kernel.org
Cc: rmk@arm.linux.org.uk
Subject: [PATCH] DEV: zero: use correct pgprot for zeromapping
Message-ID: <20070210091521.GA7350@bitbox.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of PAGE_COPY use the pgprot bits established already at
original mapping time of the VMA. This will also include any
architecture specific bits setup through protection_map.
zeromap_page_range will take care of COW'ing the passed pgprot.

This fixes at least one problem on ARM where reading /dev/zero
in one process created global PTE mappings thus - practically -
zeroing out memory ranges of all other processes.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
---
 drivers/char/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f5c160c..9a7264f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -646,7 +646,7 @@ static inline size_t read_zero_pagealigned(char __user * buf, size_t size)
 			count = size;
 
 		zap_page_range(vma, addr, count, NULL);
-        	if (zeromap_page_range(vma, addr, count, PAGE_COPY))
+        	if (zeromap_page_range(vma, addr, count, vma->vm_page_prot))
 			break;
 
 		size -= count;
-- 
1.4.4.3.GIT

