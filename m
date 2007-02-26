Return-Path: <linux-kernel-owner+w=401wt.eu-S1161305AbXBZWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305AbXBZWwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161304AbXBZWwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:52:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58787 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161305AbXBZWwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:52:14 -0500
Date: Mon, 26 Feb 2007 23:52:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] fix section mismatch warning in lockdep
Message-ID: <20070226225247.GA17437@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep_init() is marked __init but used in several places
outside __init code. This causes following warnings:
$ scripts/mod/modpost kernel/lockdep.o
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_init_map after 'lockdep_init_map' (at offset 0x105)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.lockdep_reset_lock after 'lockdep_reset_lock' (at offset 0x35)
WARNING: kernel/built-in.o - Section mismatch: reference to .init.text:lockdep_init from .text.__lock_acquire after '__lock_acquire' (at offset 0xb2)

The warnings are less obviously due to heavy inlining
by gcc - this is not altered.

Fix the section mismatch warnings by removing the __init marking,
which seems obviously wrong.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a08a172..8dc24c9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2602,7 +2602,7 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
-void __init lockdep_init(void)
+void lockdep_init(void)
 {
 	int i;
 

