Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZBITey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZBITey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZBITeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:34:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:38620 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbZBITeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NafPqmVENYblDZ/0axL6HYv/1l9kv4XOcPEMEhBDqoXTln5qRNLFPbgvqWgqAbJEol
         bi5orHV+DZBTTAfavYAW74ObBdQkn1FeSv3QpPcTBwDD33Ni1tYqY7XcQjynf59K+bWl
         zkpA/u4nu3iKUS0p67LUBe+9M1fF8LLwsW+6Q=
Date: Mon, 9 Feb 2009 20:34:40 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>
Cc: Ira Snyder <iws@ovro.caltech.edu>, Peter Korsgaard <jacmet@sunsite.dk>,
       Dai Haruki <dai.haruki@freescale.com>,
       Andy Fleming <afleming@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH net] gianfar: Fix boot hangs while bringing up gianfar
	ethernet
Message-ID: <20090209193440.GA2537@ami.dom.local>
References: <20090129194145.GA4647@ovro.caltech.edu> <20090207225555.GA2680@ami.dom.local> <20090209172216.GA11312@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209172216.GA11312@ovro.caltech.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 09:22:17AM -0800, Ira Snyder wrote:
...
> It works fine for me, the board now boots up normally.
> 
> Thanks for the patch,
> Ira

Very nice! Here is the same plus a comment. 

Many thanks,
Jarek P.

PS: Ira, your mta config is a bit unusual here wrt. reply; I hope you
will forgive me adding you to CC anyway.

PS#2: Andy, this changelog is really a lot harder than the patch...

------------------->
gianfar: Fix boot hangs while bringing up gianfar ethernet

Ira Snyder found that commit 8c7396aebb68994c0519e438eecdf4d5fa9c7844
"gianfar: Merge Tx and Rx interrupt for scheduling clean up ring" can
cause hangs. It's because there was removed clearing of interrupts in
gfar_schedule_cleanup() (which is called by an interrupt handler) in
case when netif scheduling has been disabled. This patch brings back
this action and a comment.

Reported-by: Ira Snyder <iws@ovro.caltech.edu>
Reported-by: Peter Korsgaard <jacmet@sunsite.dk>
Bisected-by: Ira Snyder <iws@ovro.caltech.edu>
Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
Tested-by: Ira Snyder <iws@ovro.caltech.edu>
Signed-by: Jarek Poplawski <jarkao2@gmail.com>

---

 drivers/net/gianfar.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index acae2d8..9b12a13 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1629,6 +1629,12 @@ static void gfar_schedule_cleanup(struct net_device *dev)
 	if (netif_rx_schedule_prep(&priv->napi)) {
 		gfar_write(&priv->regs->imask, IMASK_RTX_DISABLED);
 		__netif_rx_schedule(&priv->napi);
+	} else {
+		/*
+		 * Clear IEVENT, so interrupts aren't called again
+		 * because of the packets that have already arrived.
+		 */
+		gfar_write(&priv->regs->ievent, IEVENT_RTX_MASK);
 	}
 
 	spin_unlock(&priv->rxlock);
