Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbZD2W0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbZD2W0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZD2WVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:20 -0400
Received: from kroah.org ([198.145.64.141]:40309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbZD2WVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:24 2009
Message-Id: <20090429220924.768577493@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:12 -0700
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
       alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/58] bridge: bad error handling when adding invalid ether address
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=bridge-bad-error-handling-when-adding-invalid-ether-address.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_if.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -419,7 +419,6 @@ err2:
 err1:
 	kobject_del(&p->kobj);
 err0:
-	kobject_put(&p->kobj);
 	dev_set_promiscuity(dev, -1);
 put_back:
 	dev_put(dev);


