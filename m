Return-Path: <linux-kernel-owner+w=401wt.eu-S1764890AbXLMHS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764890AbXLMHS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762704AbXLMG6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55721 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762690AbXLMG6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:34 -0500
Date: Wed, 12 Dec 2007 22:53:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 55/60] NETFILTER: fix forgotten module release in
	xt_CONNMARK and xt_CONNSECMARK
Message-ID: <20071213065338.GE6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-fix-forgotten-module-release-in-xt_connmark-and-xt_connsecmark.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jan Engelhardt <jengelh@computergmbh.de>

[NETFILTER]: fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

[ Upstream commit: 67b4af297033f5f65999885542f95ba7b562848a ]

Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

When xt_CONNMARK is used outside the mangle table and the user specified
"--restore-mark", the connmark_tg_check() function will (correctly)
error out, but (incorrectly) forgets to release the L3 conntrack module.
Same for xt_CONNSECMARK.

Fix is to move the call to acquire the L3 module after the basic
constraint checks.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_CONNMARK.c    |   10 +++++-----
 net/netfilter/xt_CONNSECMARK.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -85,11 +85,6 @@ checkentry(const char *tablename,
 {
 	const struct xt_connmark_target_info *matchinfo = targinfo;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
-		return false;
-	}
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 		if (strcmp(tablename, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
@@ -102,6 +97,11 @@ checkentry(const char *tablename,
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return false;
 	}
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
 	return true;
 }
 
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -91,11 +91,6 @@ static bool checkentry(const char *table
 {
 	const struct xt_connsecmark_target_info *info = targinfo;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
-		return false;
-	}
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
 	case CONNSECMARK_RESTORE:
@@ -106,6 +101,11 @@ static bool checkentry(const char *table
 		return false;
 	}
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
 	return true;
 }
 

-- 
