Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZFTSrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZFTSrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbZFTSqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48070 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbZFTSqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 09/25] Blackfin: fix accidental reset in some boot modes
Date: Sat, 20 Jun 2009 14:44:32 -0400
Message-Id: <1245523488-26536-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

We read the SWRST (Software Reset) register to get at the last reset
state, and then we may configure the DOUBLE_FAULT bit to control behavior
when a double fault occurs.  But if the lower bits of the register is
already set (like UART boot mode on a BF54x), we inadvertently make the
system reset by writing to the SYSTEM_RESET field at the same time.  So
make sure the lower 4 bits are always cleared.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6454bab..b2782ea 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -837,7 +837,8 @@ void __init setup_arch(char **cmdline_p)
     defined(CONFIG_BF538) || defined(CONFIG_BF539)
 	_bfin_swrst = bfin_read_SWRST();
 #else
-	_bfin_swrst = bfin_read_SYSCR();
+	/* Clear boot mode field */
+	_bfin_swrst = bfin_read_SYSCR() & ~0xf;
 #endif
 
 #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT
-- 
1.6.3.1

