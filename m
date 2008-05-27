Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYE0GRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYE0GRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYE0GRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:17:11 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:56597 "EHLO
	smtp-69.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYE0GRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:17:10 -0400
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 02:17:10 EDT
Date: Tue, 27 May 2008 08:49:32 +0300
From: Mika Kukkonen <mikukkon@srv1-m700-lanp.koti>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, arjan@linux.intel.com
Subject: [PATCH 2.6.26-rc4] Fix nesting error checking in
	arch/x86/mm/ioremap.c
Message-ID: <20080527054930.GA2488@srv1-m700-lanp.koti>
Reply-To: mikukkon@iki.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The discussion about latest -rc reminded me of this patch (probably
unrelated but anyway). With "-Wextra" I get following warning:

  CC      arch/x86/mm/ioremap.o
arch/x86/mm/ioremap.c: In function 'early_iounmap':
arch/x86/mm/ioremap.c:599: warning: comparison of unsigned expression < 0 is always false

Following patch avoids potential underflow and actually does the WARN().

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>

---

 arch/x86/mm/ioremap.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 71bb315..78667f4 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -595,8 +595,12 @@ void __init early_iounmap(void *addr, unsigned long size)
 	enum fixed_addresses idx;
 	unsigned int nesting;
 
-	nesting = --early_ioremap_nested;
-	WARN_ON(nesting < 0);
+	if (early_ioremap_nested)
+		nesting = --early_ioremap_nested;
+	else { 
+		nesting = 0;
+		WARN_ON(1);
+	}
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
