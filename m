Return-Path: <linux-kernel-owner+w=401wt.eu-S1422971AbXCGRuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971AbXCGRuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422976AbXCGRuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:50:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:43768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422779AbXCGROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:53 -0500
Message-Id: <20070307171315.811879861@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de, Jiri Bohac <jbohac@suse.cz>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 036/101] Fix IPX module unload
Content-Disposition: inline; filename=fix-ipx-module-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

[IPX]: Fix NULL pointer dereference on ipx unload

Fixes a null pointer dereference when unloading the ipx module.

On initialization of the ipx module, registering certain packet
types can fail. When this happens, unloading the module later
dereferences NULL pointers.  This patch fixes that. Please apply.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipx/af_ipx.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- linux-2.6.20.1.orig/net/ipx/af_ipx.c
+++ linux-2.6.20.1/net/ipx/af_ipx.c
@@ -2035,19 +2035,27 @@ static void __exit ipx_proto_finito(void
 
 	ipxitf_cleanup();
 
-	unregister_snap_client(pSNAP_datalink);
-	pSNAP_datalink = NULL;
-
-	unregister_8022_client(p8022_datalink);
-	p8022_datalink = NULL;
+	if (pSNAP_datalink) {
+		unregister_snap_client(pSNAP_datalink);
+		pSNAP_datalink = NULL;
+	}
+
+	if (p8022_datalink) {
+		unregister_8022_client(p8022_datalink);
+		p8022_datalink = NULL;
+	}
 
 	dev_remove_pack(&ipx_8023_packet_type);
-	destroy_8023_client(p8023_datalink);
-	p8023_datalink = NULL;
+	if (p8023_datalink) {
+		destroy_8023_client(p8023_datalink);
+		p8023_datalink = NULL;
+	}
 
 	dev_remove_pack(&ipx_dix_packet_type);
-	destroy_EII_client(pEII_datalink);
-	pEII_datalink = NULL;
+	if (pEII_datalink) {
+		destroy_EII_client(pEII_datalink);
+		pEII_datalink = NULL;
+	}
 
 	proto_unregister(&ipx_proto);
 	sock_unregister(ipx_family_ops.family);

--
