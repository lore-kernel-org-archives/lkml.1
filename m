Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687Ab0ANWjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0ANWjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510Ab0ANWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:39:40 -0500
Received: from kroah.org ([198.145.64.141]:60518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0ANW2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Xiaotian Feng <dfeng@redhat.com>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "David S. Miller" <davem@davemloft.net>,
       Nikola Ciprich <extmaillist@linuxbox.cz>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/52] sunrpc: fix peername failed on closed listener
Date: Thu, 14 Jan 2010 14:26:47 -0800
Message-Id: <1263508051-7868-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-7-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

commit b292cf9ce70d221c3f04ff62db5ab13d9a249ca8 upstream.

There're some warnings of "nfsd: peername failed (err 107)!"
socket error -107 means Transport endpoint is not connected.
This warning message was outputed by svc_tcp_accept() [net/sunrpc/svcsock.c],
when kernel_getpeername returns -107. This means socket might be CLOSED.

And svc_tcp_accept was called by svc_recv() [net/sunrpc/svc_xprt.c]

        if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
        <snip>
                newxpt = xprt->xpt_ops->xpo_accept(xprt);
        <snip>

So this might happen when xprt->xpt_flags has both XPT_LISTENER and XPT_CLOSE.

Let's take a look at commit b0401d72, this commit has moved the close
processing after do recvfrom method, but this commit also introduces this
warnings, if the xpt_flags has both XPT_LISTENER and XPT_CLOSED, we should
close it, not accpet then close.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/svc_xprt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index df124f7..0266cca 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -711,7 +711,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 	spin_unlock_bh(&pool->sp_lock);
 
 	len = 0;
-	if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
+	if (test_bit(XPT_LISTENER, &xprt->xpt_flags) &&
+	    !test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
 		struct svc_xprt *newxpt;
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
-- 
1.6.6

