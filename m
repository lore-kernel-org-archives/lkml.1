Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbZKFWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbZKFWGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbZKFWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:06 -0500
Received: from kroah.org ([198.145.64.141]:39830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbZKFWGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.701406586@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [28/30] bonding: fix a race condition in calls to slave MII ioctls
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=bonding-fix-a-race-condition-in-calls-to-slave-mii-ioctls.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

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
@@ -686,7 +686,7 @@ static int bond_update_speed_duplex(stru
  */
 static int bond_check_dev_link(struct bonding *bond, struct net_device *slave_dev, int reporting)
 {
-	static int (* ioctl)(struct net_device *, struct ifreq *, int);
+	int (* ioctl)(struct net_device *, struct ifreq *, int);
 	struct ifreq ifr;
 	struct mii_ioctl_data *mii;
 


