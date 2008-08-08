Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYHHLzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYHHLzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYHHLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:55:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36246 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbYHHLz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:55:28 -0400
From: Julien Brunel <brunel@diku.dk>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] net/rxrpc: Use an IS_ERR test rather than a NULL test
Date: Fri, 8 Aug 2008 13:55:21 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081355.21787.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>

In case of error, the function rxrpc_get_transport returns an ERR
pointer, but never returns a NULL pointer. So after a call to this
function, a NULL test should be replaced by an IS_ERR test.

A simplified version of the semantic patch that makes this change is
as follows: 
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@correct_null_test@
expression x,E;
statement S1, S2;
@@
x =  rxrpc_get_transport(...)
<... when != x = E
if (
(
- x@p2 != NULL
+ ! IS_ERR ( x )
|
- x@p2 == NULL
+ IS_ERR( x )
)
 )
S1
else S2
...>
? x = E;
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 net/rxrpc/ar-accept.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/rxrpc/ar-accept.c b/net/rxrpc/ar-accept.c
--- a/net/rxrpc/ar-accept.c
+++ b/net/rxrpc/ar-accept.c
@@ -100,7 +100,7 @@ static int rxrpc_accept_incoming_call(st
 
 	trans = rxrpc_get_transport(local, peer, GFP_NOIO);
 	rxrpc_put_peer(peer);
-	if (!trans) {
+	if (IS_ERR(trans)) {
 		_debug("no trans");
 		ret = -EBUSY;
 		goto error;
