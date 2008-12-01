Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYLAATr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYLAATr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYLAATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:19:34 -0500
Received: from mx2.netapp.com ([216.240.18.37]:58314 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbYLAATc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:19:32 -0500
X-IronPort-AV: E=Sophos;i="4.33,691,1220252400"; 
   d="scan'208";a="93037901"
Subject: Re: [PATCH 2/3] SUNRPC: We only need to call svc_delete_xprt()
 once...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228090631.7112.11.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Sun, 30 Nov 2008 19:19:30 -0500
Message-Id: <1228090770.7112.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 01 Dec 2008 00:19:32.0238 (UTC) FILETIME=[7B8E52E0:01C9534A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use XPT_DEAD to ensure that we only call xpo_detach & friends once.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/svc_xprt.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index bf5b5cd..a417064 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -838,6 +838,10 @@ void svc_delete_xprt(struct svc_xprt *xprt)
 {
 	struct svc_serv	*serv = xprt->xpt_server;
 
+	/* Only do this once */
+	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags) != 0)
+		return;
+
 	dprintk("svc: svc_delete_xprt(%p)\n", xprt);
 	xprt->xpt_ops->xpo_detach(xprt);
 
@@ -851,13 +855,14 @@ void svc_delete_xprt(struct svc_xprt *xprt)
 	 * while still attached to a queue, the queue itself
 	 * is about to be destroyed (in svc_destroy).
 	 */
-	if (!test_and_set_bit(XPT_DEAD, &xprt->xpt_flags)) {
-		BUG_ON(atomic_read(&xprt->xpt_ref.refcount) < 2);
-		if (test_bit(XPT_TEMP, &xprt->xpt_flags))
-			serv->sv_tmpcnt--;
-		svc_xprt_put(xprt);
-	}
+	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
+		serv->sv_tmpcnt--;
 	spin_unlock_bh(&serv->sv_lock);
+
+	/* FIXME: Is this really needed here? */
+	BUG_ON(atomic_read(&xprt->xpt_ref.refcount) < 2);
+
+	svc_xprt_put(xprt);
 }
 
 void svc_close_xprt(struct svc_xprt *xprt)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
