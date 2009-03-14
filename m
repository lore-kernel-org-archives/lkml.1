Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZCNBX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZCNBX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZCNBTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:51 -0400
Received: from kroah.org ([198.145.64.141]:34805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752545AbZCNBTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:32 2009
Message-Id: <20090314011032.610697374@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:46 -0700
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
       alan@lxorguk.ukuu.org.uk, Ed Cashin <ecashin@coraid.com>,
       Alex Buell <alex.buell@munted.org.uk>
Subject: [patch 009/114] aoe: ignore vendor extension AoE responses
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=aoe-ignore-vendor-extension-aoe-responses.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ed Cashin <ecashin@coraid.com>

commit b6d6c5175809934e04a606d9193ef04924a7a7d9 upstream.

The Welland ME-747K-SI AoE target generates unsolicited AoE responses that
are marked as vendor extensions.  Instead of ignoring these packets, the
aoe driver was generating kernel messages for each unrecognized response
received.  This patch corrects the behavior.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reported-by: <karaluh@karaluh.pl>
Tested-by: <karaluh@karaluh.pl>
Cc: Alex Buell <alex.buell@munted.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoenet.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -18,6 +18,7 @@
 enum {
 	AOECMD_ATA,
 	AOECMD_CFG,
+	AOECMD_VEND_MIN = 0xf0,
 
 	AOEFL_RSP = (1<<3),
 	AOEFL_ERR = (1<<2),
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -153,6 +153,8 @@ aoenet_rcv(struct sk_buff *skb, struct n
 		aoecmd_cfg_rsp(skb);
 		break;
 	default:
+		if (h->cmd >= AOECMD_VEND_MIN)
+			break;	/* don't complain about vendor commands */
 		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
 	}
 exit:


