Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYBYPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYBYPvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYBYPux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:50:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbYBYPuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:50:52 -0500
Date: Mon, 25 Feb 2008 16:50:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] printk: fix possible printk overrun
Message-ID: <20080225155038.GA25423@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: printk: fix possible printk overrun
From: Tejun Heo <htejun@gmail.com>
Date: Thu, 14 Feb 2008 10:32:07 +0900

printk recursion detection prepends message to printk_buf and offsets 
printk_buf when actual message is printed but it forgets to trim buffer 
length accordingly. This can result in overrun in extreme cases. Fix it.

[ mingo@elte.hu:

  bug was introduced by me via:

   commit 32a76006683f7b28ae3cc491da37716e002f198e
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Fri Jan 25 21:07:58 2008 +0100

       printk: make printk more robust by not allowing recursion
]

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -666,7 +666,7 @@ asmlinkage int vprintk(const char *fmt, 
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf), fmt, args);
+				  sizeof(printk_buf) - printed_len, fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
