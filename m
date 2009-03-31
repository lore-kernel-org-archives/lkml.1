Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZCaXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZCaXZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbZCaXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:33 -0400
Received: from sous-sol.org ([216.99.217.87]:33145 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760529AbZCaXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:29 -0400
Message-Id: <20090331231345.676991377@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 04/45] bridge: bad error handling when adding invalid ether address
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=bridge-bad-error-handling-when-adding-invalid-ether-address.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit cda6d377ec6b2ee2e58d563d0bd7eb313e0165df ]

This fixes an crash when empty bond device is added to a bridge.
If an interface with invalid ethernet address (all zero) is added
to a bridge, then bridge code detects it when setting up the forward
databas entry. But the error unwind is broken, the bridge port object
can get freed twice: once when ref count went to zeo, and once by kfree.
Since object is never really accessible, just free it.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/bridge/br_if.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -426,7 +426,6 @@ err2:
 err1:
 	kobject_del(&p->kobj);
 err0:
-	kobject_put(&p->kobj);
 	dev_set_promiscuity(dev, -1);
 put_back:
 	dev_put(dev);

