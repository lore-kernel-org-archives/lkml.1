Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbYGaARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbYGaARy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763169AbYGaAQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:16:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:39038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763160AbYGaAQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:16:58 -0400
Date: Wed, 30 Jul 2008 16:59:06 -0700
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
       alan@lxorguk.ukuu.org.uk, Brice Goglin <brice@myri.com>
Subject: [patch 35/62] myri10ge: do not forget to setup the single slice
	pointers
Message-ID: <20080730235906.GI12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="myri10ge-do-not-forget-to-setup-the-single-slice-pointers.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Brice Goglin <brice@myri.com>

part of commit 0dcffac1a329be69bab0ac604bf7283737108e68 upstream
(the upstream multislice patch contains the same fix within
 myri10ge_alloc_slices() which does this for every slice)

Even if we don't have multiple slices in myri10ge in 2.6.26,
we already use some multislice-aware routines that need the
slice state pointers to mgp and dev to be valid.

This patch fixes a regression where configuring the interface up
would oops in myri10ge_allocate_rings() when using ss->mgp
(and later when using ss->dev).

Oops reported and patch tested by Lukas Hejtmanek at
http://lkml.org/lkml/2008/7/23/101

Signed-off-by: Brice Goglin <brice@myri.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/myri10ge/myri10ge.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3126,6 +3126,8 @@ static int myri10ge_probe(struct pci_dev
 
 	mgp = netdev_priv(netdev);
 	mgp->dev = netdev;
+	mgp->ss.mgp = mgp;
+	mgp->ss.dev = mgp->dev;
 	netif_napi_add(netdev, &mgp->ss.napi, myri10ge_poll, myri10ge_napi_weight);
 	mgp->pdev = pdev;
 	mgp->csum_flag = MXGEFW_FLAGS_CKSUM;

-- 
