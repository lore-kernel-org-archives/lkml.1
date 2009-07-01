Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbZGAE5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbZGAE5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZGAE5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:57:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34282 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZGAE5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:57:11 -0400
Date: Wed, 1 Jul 2009 14:57:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20090701145711.1c9c8935.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Today's linux-next merge of the kvm tree got a conflict in fs/eventfd.c
between commit 133890103b9de08904f909995973e4b5c08a780e ("eventfd:
revised interface and cleanups") from Linus' tree and commit
28ddf0aebbf546e56efd1951725d5457ce1ebf98 ("eventfd: Allow waiters to be
notified about the eventfd file* going away") from the kvm tree.

Overlapping changes.  I fixed it up (see below), but don't know if this
is the correct fix.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/eventfd.c
index 31d12de,72f5f8d..0000000
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@@ -105,8 -63,13 +105,13 @@@ static int eventfd_release(struct inod
  {
  	struct eventfd_ctx *ctx = file->private_data;
  
- 	wake_up_poll(&ctx->wqh, POLLHUP);
+ 	/*
+ 	 * No need to hold the lock here, since we are on the file cleanup
+ 	 * path and the ones still attached to the wait queue will be
+ 	 * serialized by wake_up_locked_poll().
+ 	 */
+ 	wake_up_locked_poll(&ctx->wqh, POLLHUP);
 -	kfree(ctx);
 +	eventfd_ctx_put(ctx);
  	return 0;
  }
  
