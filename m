Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZLWSET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZLWSET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZLWSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:04:18 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:40353 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752800AbZLWSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:04:17 -0500
Date: Wed, 23 Dec 2009 21:04:15 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: ucc_geth broken in 2.6.32 by
 864fdf884e82bacbe8ca5e93bd43393a61d2e2b4
Message-ID: <20091223180415.GA12987@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091223174019.GB762@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091223174019.GB762@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 12:40:19PM -0500, Lennart Sorensen wrote:
> We use the ucc_geth for 6 ports (4 100Mbit and 2 Gbit ports) on an
> mpc8360e.  Up to 2.6.31 this worked fine.  2.6.32 on the other hand
> crashes very quickly after boot.

Hm. Just curious, what CPU revision you use? So that I could try
to reproduce the issue... I have MPC8360E-MDS boards, rev 2.0 and
rev rev 2.1 CPUs, Marvell PHYs. I also have MPC8360E-RDK (rev 2.1).
And I didn't see any issues with this patch.

> I managed to see the same crash when I was selectively trying to add newer
> ucc_geth patches to the 2.6.31 kernel a couple of months ago, and the same
> patch that caused a crash then seems suspect.  If I revert the patch the
> system runs completely stable.  Amusingly, the excact error message the
> patch claims to fix is in fact the error it causes to happen in my case.
> 
> So preferably 864fdf884e82bacbe8ca5e93bd43393a61d2e2b4 could be reverted

I don't see any point in reverting, because it will surely break my boards.
So, we need to fix this, not just hide.

> unless someone can fix it.

Well, I'm ready to help you with debugging.

> Now I must add that I run with the xenomai/adeos-ipipe patches as well,
> which do change interrupt handling a little,

It could be that it takes too long to stop the UCC, and xenomai
makes the timings worse, so the watchdog triggers.

Can you try the following patch?

diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index afaf088..2f73e3f 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -1563,6 +1563,8 @@ static int ugeth_disable(struct ucc_geth_private *ugeth, enum comm_dir mode)
 
 static void ugeth_quiesce(struct ucc_geth_private *ugeth)
 {
+	netif_device_detach(ugeth->ndev);
+
 	/* Wait for and prevent any further xmits. */
 	netif_tx_disable(ugeth->ndev);
 
@@ -1577,7 +1579,7 @@ static void ugeth_activate(struct ucc_geth_private *ugeth)
 {
 	napi_enable(&ugeth->napi);
 	enable_irq(ugeth->ug_info->uf_info.irq);
-	netif_tx_wake_all_queues(ugeth->ndev);
+	netif_device_attach(ugeth->ndev);
 }
 
 /* Called every time the controller might need to be made
