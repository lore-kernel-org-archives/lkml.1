Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbYAYIpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbYAYIpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763689AbYAYIQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:16:25 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62264 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbYAYIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:16:20 -0500
Date: Fri, 25 Jan 2008 17:16:13 +0900 (JST)
Message-Id: <20080125.171613.41631926.usui@mxm.nes.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: magnus.damm@gmail.com
Subject: [PATCH] Fix NUMA emulation for x86_64
From: Minoru Usui <usui@mxm.nes.nec.co.jp>
X-fingerprint: 588C 0511 30A4 1BE0 551B  7210 8433 0B28 D5CC 723D
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a small bug of NUMA emulation code for x86_64. (CONFIG_NUMA_EMU)
If machine is non-NUMA, find_node_by_addr() should return
NUMA_NO_NODE, but current implementation code returns existent maximum
NUMA node number + 1. 
This is not existent NUMA node number.

However, this behaviour does not affect NUMA emulation fortunately, because
acpi_fake_nodes() that is caller of find_node_by_addr() gets pxm
(proximity domain) by node_to_pxm() from non-existent NUMA node number
that was returned by find_node_by_addr().
node_to_pxm() returns PXM_INVAL that means illegal or non-existent
NUMA node number.

Signed-off-by: Minoru Usui <usui@mxm.nes.nec.co.jp>
---
diff -ruNp linux-2.6.24-rc8/arch/x86/mm/srat_64.c dst/arch/x86/mm/srat_64.c 
--- linux-2.6.24-rc8/arch/x86/mm/srat_64.c      2008-01-16 14:22:15.000000000 +0900
+++ dst/arch/x86/mm/srat_64.c   2008-01-17 19:07:41.000000000 +0900
@@ -457,7 +457,7 @@ static int __init find_node_by_addr(unsi
                        break;
                }
        }
-       return i;
+       return ret;
 }
 
 /*
