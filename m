Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZL1Qza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZL1Qza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZL1Qz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:55:28 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35750 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZL1QzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=V8cGAsLkOQScUETBNGwtqoUNIok3zBu3HpT/0kMsKfTZB2gZPSJD6yzig56N4jZonP
         akVhW5DRXNzCq0P8rjxPYz/E6rvEDoxyhvgQVImvIs9zpvvOhPB+XB6+7qcI90TiD8zz
         ncIi1Xzk5uslxazE+LHhMsbPbezp5HaYJH7Rk=
Date: Mon, 28 Dec 2009 18:54:55 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] hamradio: avoid null deref v3
Message-ID: <20091228165455.GA17645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Miller <davem@davemloft.net>, jarkao2@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091223132550.GD17923@bicker> <4B3257C2.2050500@gmail.com> <20091226123812.GB6075@bicker> <20091226.201729.15225529.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226.201729.15225529.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should address the problems in version 1 (lazy) and version 2 (ugly).

Bump the stats on orig_dev not on the newly assigned NULL dev variable.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/hamradio/bpqether.c	2009-12-22 23:58:56.000000000 +0200
+++ devel/drivers/net/hamradio/bpqether.c	2009-12-28 00:12:48.000000000 +0200
@@ -248,6 +248,7 @@ static netdev_tx_t bpq_xmit(struct sk_bu
 {
 	unsigned char *ptr;
 	struct bpqdev *bpq;
+	struct net_device *orig_dev;
 	int size;
 
 	/*
@@ -282,8 +283,9 @@ static netdev_tx_t bpq_xmit(struct sk_bu
 
 	bpq = netdev_priv(dev);
 
+	orig_dev = dev;
 	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
-		dev->stats.tx_dropped++;
+		orig_dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
