Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZG1XHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZG1XHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZG1XH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:07:29 -0400
Received: from kroah.org ([198.145.64.141]:43008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbZG1XEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.015196951@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 21/37] SUNRPC: Avoid an unnecessary task reschedule on ENOTCONN
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=sunrpc-avoid-an-unnecessary-task-reschedule-on-enotconn.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 15f081ca8ddfe150fb639c591b18944a539da0fc upstream.

If the socket is unconnected, and xprt_transmit() returns ENOTCONN, we
currently give up the lock on the transport channel. Doing so means that
the lock automatically gets assigned to the next task in the xprt->sending
queue, and so that task needs to be woken up to do the actual connect.

The following patch aims to avoid that unnecessary task switch.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/clnt.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1089,14 +1089,24 @@ static void
 call_transmit_status(struct rpc_task *task)
 {
 	task->tk_action = call_status;
-	/*
-	 * Special case: if we've been waiting on the socket's write_space()
-	 * callback, then don't call xprt_end_transmit().
-	 */
-	if (task->tk_status == -EAGAIN)
-		return;
-	xprt_end_transmit(task);
-	rpc_task_force_reencode(task);
+	switch (task->tk_status) {
+	case -EAGAIN:
+		break;
+	default:
+		xprt_end_transmit(task);
+		/*
+		 * Special cases: if we've been waiting on the
+		 * socket's write_space() callback, or if the
+		 * socket just returned a connection error,
+		 * then hold onto the transport lock.
+		 */
+	case -ECONNREFUSED:
+	case -ENOTCONN:
+	case -EHOSTDOWN:
+	case -EHOSTUNREACH:
+	case -ENETUNREACH:
+		rpc_task_force_reencode(task);
+	}
 }
 
 /*


