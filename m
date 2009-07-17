Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZGQUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZGQUTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZGQUTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:41 -0400
Received: from kroah.org ([198.145.64.141]:43078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZGQUTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:29 2009
Message-Id: <20090717201229.279762270@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sonic Zhang <sonic.zhang@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [patch 05/24] Blackfin: fix accidental reset in some boot modes
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=blackfin-fix-accidental-reset-in-some-boot-modes.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sonic Zhang <sonic.zhang@analog.com>

commit 0de4adfb8c9674fa1572b0ff1371acc94b0be901 upstream.

We read the SWRST (Software Reset) register to get at the last reset
state, and then we may configure the DOUBLE_FAULT bit to control behavior
when a double fault occurs.  But if the lower bits of the register is
already set (like UART boot mode on a BF54x), we inadvertently make the
system reset by writing to the SYSTEM_RESET field at the same time.  So
make sure the lower 4 bits are always cleared.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/kernel/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -831,7 +831,8 @@ void __init setup_arch(char **cmdline_p)
     defined(CONFIG_BF538) || defined(CONFIG_BF539)
 	_bfin_swrst = bfin_read_SWRST();
 #else
-	_bfin_swrst = bfin_read_SYSCR();
+	/* Clear boot mode field */
+	_bfin_swrst = bfin_read_SYSCR() & ~0xf;
 #endif
 
 #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT


