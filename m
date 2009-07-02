Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZGBVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZGBVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZGBVcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:32:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47542 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbZGBVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:32:02 -0400
Subject: Memory leak in iwlwifi or false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 02 Jul 2009 22:32:03 +0100
Message-Id: <1246570323.24044.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 21:32:04.0121 (UTC) FILETIME=[8ACFD890:01C9FB5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to get kmemleak more robust and with the latest patches (not
pushed yet) it seems to no longer show so many random leaks. However, I
get a lot of leaks reported in the iwlwifi code, about 4800 and they do
not disappear from any subsequent memory scanning (as is usually the
case with false positives). There are a lot of kmalloc's of < 512 bytes
and /proc/slabinfo seems to be in line with this:

kmalloc-512         5440   5481

This happens shortly after booting. Note that if an object is freed,
kmemleak no longer tracks it and therefore no reporting. But in this
case it looks like the iwlwifi code really allocated ~4800 blocks. Is it
normal for this code to keep so many blocks allocated? If yes, it is
probably kmemleak missing some root object in the references tree.

I'm not familiar with this code so any help is greatly appreciated.

The majority of kmemleak traces look like this:

unreferenced object 0xc1be3d40 (size 512):
  comm "iwlagn", pid 1571, jiffies 4294903229
  backtrace:
    [<c01e1f0b>] kmemleak_alloc+0x14b/0x290
    [<c01db2e5>] __kmalloc+0x125/0x1e0
    [<f95c77ef>] iwl_tx_queue_init+0x3f/0x310 [iwlcore]
    [<f95c9276>] iwl_txq_ctx_reset+0x206/0x5a0 [iwlcore]
    [<f95c199a>] iwl_hw_nic_init+0xba/0x110 [iwlcore]
    [<f9765263>] __iwl_up+0xb3/0x340 [iwlagn]
    [<f9765d72>] iwl_bg_up+0x32/0x50 [iwlagn]
    [<c0150d7d>] worker_thread+0x1ad/0x2d0
    [<c01555dc>] kthread+0x7c/0x90
    [<c0103cb7>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff

For a full kmemleak log and dmesg, see:

http://homepage.ntlworld.com/cmarinas/kmemleak-3
http://homepage.ntlworld.com/cmarinas/dmesg-3

Thanks.

-- 
Catalin

