Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935304Ab0CMA2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:28:24 -0500
Received: from kroah.org ([198.145.64.141]:32806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935045Ab0CMAVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:05 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.412919417@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tom Tucker <tom@opengridcomputing.com>, NeilBrown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 106/123] sunrpc: remove unnecessary svc_xprt_put
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Neil Brown <neilb@suse.de>

commit ab1b18f70a007ea6caeb007d269abb75b131a410 upstream.

The 'struct svc_deferred_req's on the xpt_deferred queue do not
own a reference to the owning xprt.  This is seen in svc_revisit
which is where things are added to this queue.  dr->xprt is set to
NULL and the reference to the xprt it put.

So when this list is cleaned up in svc_delete_xprt, we mustn't
put the reference.

Also, replace the 'for' with a 'while' which is arguably
simpler and more likely to compile efficiently.

Cc: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc_xprt.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -889,11 +889,8 @@ void svc_delete_xprt(struct svc_xprt *xp
 	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
 		serv->sv_tmpcnt--;
 
-	for (dr = svc_deferred_dequeue(xprt); dr;
-	     dr = svc_deferred_dequeue(xprt)) {
-		svc_xprt_put(xprt);
+	while ((dr = svc_deferred_dequeue(xprt)) != NULL)
 		kfree(dr);
-	}
 
 	svc_xprt_put(xprt);
 	spin_unlock_bh(&serv->sv_lock);


