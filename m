Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZKFWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZKFWXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932681AbZKFWXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:37 -0500
Received: from kroah.org ([198.145.64.141]:57093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbZKFWX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:49 2009
Message-Id: <20091106221549.488867204@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [77/99] bonding: fix a race condition in calls to slave MII ioctls
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=bonding-fix-a-race-condition-in-calls-to-slave-mii-ioctls.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Bohac <jbohac@suse.cz>

commit d9d5283228d0c752f199c901fff6e1405dc91bcb upstream.

In mii monitor mode, bond_check_dev_link() calls the the ioctl
handler of slave devices. It stores the ndo_do_ioctl function
pointer to a static (!) ioctl variable and later uses it to call the
handler with the IOCTL macro.

If another thread executes bond_check_dev_link() at the same time
(even with a different bond, which none of the locks prevent), a
race condition occurs. If the two racing slaves have different
drivers, this may result in one driver's ioctl handler being
called with a pointer to a net_device controlled with a different
driver, resulting in unpredictable breakage.

Unless I am overlooking something, the "static" must be a
copy'n'paste error (?).

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -691,7 +691,7 @@ static int bond_check_dev_link(struct bo
 			       struct net_device *slave_dev, int reporting)
 {
 	const struct net_device_ops *slave_ops = slave_dev->netdev_ops;
-	static int (*ioctl)(struct net_device *, struct ifreq *, int);
+	int (*ioctl)(struct net_device *, struct ifreq *, int);
 	struct ifreq ifr;
 	struct mii_ioctl_data *mii;
 


