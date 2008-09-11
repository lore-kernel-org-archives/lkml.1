Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYIKUlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYIKUlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIKUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:40:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35422 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbYIKUkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:40:51 -0400
Date: Thu, 11 Sep 2008 15:40:50 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Dean Nelson <dcn@sgi.com>
Subject: [Patch] Panic on ia64 when you modprobe -r xpc.
Message-ID: <20080911204050.GE8520@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are on ia64 and you modprobe xpc then modprobe -r xpc, you
immediately get a panic.  xpc depends on xp which depends on gru for
a symbol.  That symbol is only used when we are running on UV hardware.

Currently, the GRU driver detects we are not on UV hardware and does
no initializing.  It does not do the same check when unloading.  As a
result, the gru driver attempts to tear down stuff that was not setup.

This is a simple two-line workaround to get us through this release.
Once 2.6.28 is opened, we need to rework the symbols that xp is depending
on from gru so the gru driver can properly fail to load when hardware
is not available.

Signed-off-by: Robin Holt <holt@sgi.com>


Index: xpmem_v006_20080911/drivers/misc/sgi-gru/grufile.c
===================================================================
--- xpmem_v006_20080911.orig/drivers/misc/sgi-gru/grufile.c	2008-09-11 15:23:40.000000000 -0500
+++ xpmem_v006_20080911/drivers/misc/sgi-gru/grufile.c	2008-09-11 15:33:21.009814869 -0500
@@ -445,6 +445,9 @@ static void __exit gru_exit(void)
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
+	if (!IS_UV())
+		return;
+
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
 		free_irq(IRQ_GRU + i, NULL);
 
