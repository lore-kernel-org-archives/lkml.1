Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbXJAHWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbXJAHWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXJAHV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:21:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXJAHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:21:55 -0400
Subject: Re: [patch] MTD: fix cfi_interleave() build errors
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071001071437.GA15051@elte.hu>
References: <20071001045037.GA10564@elte.hu>
	 <20071001050145.GA12925@elte.hu>
	 <1191221671.2905.637.camel@pmac.infradead.org>
	 <20071001071437.GA15051@elte.hu>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 08:21:52 +0100
Message-Id: <1191223312.9188.3.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 09:14 +0200, Ingo Molnar wrote:
> MTD is the only code in the tree at the moment that breaks "make 
> randconfig" tests (after ~2000 random rebuilds) - and those tests _are_ 
> immensely useful, they catch a lot of build breakage in the scheduler 
> git tree for example, before i push it out. So if possible it would be 
> nice to have this in .23.

I did send it, a number of weeks ago. Linus didn't take it, so I just
put it in the git tree for 2.6.24. Now I think it's too late, but here
it is again in case Linus has changed his mind...

commit 241651d04d672fb685b2874707016cbbf95931e5
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Thu Sep 6 09:40:21 2007 +0100

[MTD] Fix CFI build error when no map width or interleave supported
    
When building NOR flash support, you have compile-time options for the
bus width and the number of individual chips which are interleaved
together onto that bus. The code to deal with arbitrary geometry is a
bit convoluted, and people want to just configure it for the specific
hardware they have, to avoid the runtime overhead.
    
Selecting _none_ of the available options doesn't make any sense. You
should have at least one. This makes it build though, since people
persist in trying.
    
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index 123948b..e17c534 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -57,6 +57,15 @@
 #define cfi_interleave_is_8(cfi) (0)
 #endif
 
+#ifndef cfi_interleave
+#warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.
+static inline int cfi_interleave(void *cfi)
+{
+	BUG();
+	return 0;
+}
+#endif
+
 static inline int cfi_interleave_supported(int i)
 {
 	switch (i) {
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 81f3a31..a9fae03 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -125,7 +125,15 @@
 #endif
 
 #ifndef map_bankwidth
-#error "No bus width supported. What's the point?"
+#warning "No CONFIG_MTD_MAP_BANK_WIDTH_xx selected. No NOR chip support can work"
+static inline int map_bankwidth(void *map)
+{
+	BUG();
+	return 0;
+}
+#define map_bankwidth_is_large(map) (0)
+#define map_words(map) (0)
+#define MAX_MAP_BANKWIDTH 1
 #endif
 
 static inline int map_bankwidth_supported(int w)

-- 
dwmw2

