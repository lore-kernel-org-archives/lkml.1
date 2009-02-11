Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbZBKAlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbZBKAlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZBKA2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:42 -0500
Received: from kroah.org ([198.145.64.141]:51434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757827AbZBKA2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:40 -0500
Date: Tue, 10 Feb 2009 16:25:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tom Tucker <tom@opengridcomputing.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, Neil Brown <neilb@suse.de>
Subject: [patch 38/56] Add a reference to sunrpc in svc_addsock
Message-ID: <20090211002534.GM14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-a-reference-to-sunrpc-in-svc_addsock.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Tom Tucker <tom@opengridcomputing.com>

commit 2da2c21d7508d34bc6d600df665d84871b65d2b9 upstream.

The svc_addsock function adds transport instances without taking a
reference on the sunrpc.ko module, however, the generic transport
destruction code drops a reference when a transport instance
is destroyed.

Add a try_module_get call to the svc_addsock function for transport
instances added by this function.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svcsock.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1171,7 +1171,11 @@ int svc_addsock(struct svc_serv *serv,
 	else if (so->state > SS_UNCONNECTED)
 		err = -EISCONN;
 	else {
-		svsk = svc_setup_socket(serv, so, &err, SVC_SOCK_DEFAULTS);
+		if (!try_module_get(THIS_MODULE))
+			err = -ENOENT;
+		else
+			svsk = svc_setup_socket(serv, so, &err,
+						SVC_SOCK_DEFAULTS);
 		if (svsk) {
 			struct sockaddr_storage addr;
 			struct sockaddr *sin = (struct sockaddr *)&addr;
@@ -1184,7 +1188,8 @@ int svc_addsock(struct svc_serv *serv,
 			spin_unlock_bh(&serv->sv_lock);
 			svc_xprt_received(&svsk->sk_xprt);
 			err = 0;
-		}
+		} else
+			module_put(THIS_MODULE);
 	}
 	if (err) {
 		sockfd_put(so);

