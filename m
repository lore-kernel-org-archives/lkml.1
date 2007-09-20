Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbXITTv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbXITTv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXITTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:51:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:34810 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbXITTvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:51:50 -0400
Date: Thu, 20 Sep 2007 15:51:46 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       Neil Brown <neilb@suse.de>, Trond Myklebust <trond@netapp.com>,
       stable@kernel.org
Subject: [PATCH] rpc: fix garbage in printk in svc_tcp_accept()
Message-ID: <20070920195146.GC23287@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

we upgraded the kernel of a nfs-server from 2.6.17.11 to 2.6.22.6. Since
then we get the message

lockd: too many open TCP sockets, consider increasing the number of nfsd threads
lockd: last TCP connect from ^\\236^\É^D

These random characters in the second line are caused by a bug in
svc_tcp_accept.

(Note: there are two previous __svc_print_addr(sin, buf, sizeof(buf))
calls in this function, either of which would initialize buf correctly;
but both are inside "if"'s and are not necessarily executed.  This is
less obvious in the second case, which is inside a dprintk(), which is a
macro which expands to an if statement.)

Signed-off-by: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 net/sunrpc/svcsock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

We're printk'ing random uninitialized memory here, which I assume makes
it appropriate for both 2.6.23 and 2.6.22.x.--b.

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 1a89992..036ab52 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1110,7 +1110,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 						   serv->sv_name);
 				printk(KERN_NOTICE
 				       "%s: last TCP connect from %s\n",
-				       serv->sv_name, buf);
+				       serv->sv_name, __svc_print_addr(sin,
+							buf, sizeof(buf)));
 			}
 			/*
 			 * Always select the oldest socket. It's not fair,
-- 
1.5.3.1.139.g9346b

