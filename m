Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYEOBQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYEOBQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYEOBQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:16:19 -0400
Received: from mail.vyatta.com ([216.93.170.194]:50096 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYEOBQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:16:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.503
Date: Wed, 14 May 2008 18:15:43 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       fubar@us.ibm.com
Cc: netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: handle errors from device_rename
Message-ID: <20080514181543.744b8286@extreme>
In-Reply-To: <20080514170316.672f809d@extreme>
References: <20080514170316.672f809d@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_rename can fail with -EEXIST or -ENOMEM, so handle any problems.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/core/dev.c	2008-05-14 17:49:37.000000000 -0700
+++ b/net/core/dev.c	2008-05-14 17:51:21.000000000 -0700
@@ -903,7 +903,11 @@ int dev_change_name(struct net_device *d
 		strlcpy(dev->name, newname, IFNAMSIZ);
 
 rollback:
-	device_rename(&dev->dev, dev->name);
+	err = device_rename(&dev->dev, dev->name);
+	if (err) {
+		memcpy(dev->name, oldname, IFNAMSIZ);
+		return err;
+	}
 
 	write_lock_bh(&dev_base_lock);
 	hlist_del(&dev->name_hlist);
