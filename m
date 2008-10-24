Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYJXHsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYJXHsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJXHs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:48:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43481 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJXHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:48:26 -0400
Date: Fri, 24 Oct 2008 10:48:23 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: zanussi@comcast.net, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: [PATCH] relayfs: fix infinite loop with splice()
Message-ID: <Pine.LNX.4.64.0810241046240.16432@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <zanussi@comcast.net>

Running kmemtraced, which uses splice() on relayfs, causes a hard lock on
x86-64 SMP. As described by Tom Zanussi:

  It looks like you hit the same problem as described here:

  commit 8191ecd1d14c6914c660dfa007154860a7908857

      splice: fix infinite loop in generic_file_splice_read()

  relay uses the same loop but it never got noticed or fixed.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/relay.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..6a4d439 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1318,12 +1318,9 @@ static ssize_t relay_file_splice_read(struct file *in,
 		if (ret < 0)
 			break;
 		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
+			if (flags & SPLICE_F_NONBLOCK)
 				ret = -EAGAIN;
-				break;
-			}
+			break;
 		}
 
 		*ppos += ret;
-- 
1.5.4.3

