Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab0BDRZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:25:14 -0500
Received: from kroah.org ([198.145.64.141]:34959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab0BDRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:30 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:27 2010
Message-Id: <20100204171526.557191760@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [68/74] starfire: clean up properly if firmware loading fails
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit c928febf4bc703ea542340e5a208e0445d998839 upstream.

netdev_open() will return without cleaning up net device or hardware state
if firmware loading fails.  This results in a BUG() on a second attempt to
bring the interface up, reported in
<http://bugzilla.kernel.org/show_bug.cgi?id=15091>, and probably has even
worse effects if the driver is removed afterwards.

Call netdev_close() to clean up on failure.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15091

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Reported-by: Michael Moffatt <michael@moffatt.org.nz>
Tested-by: Michael Moffatt <michael@moffatt.org.nz>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/starfire.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -1063,7 +1063,7 @@ static int netdev_open(struct net_device
 	if (retval) {
 		printk(KERN_ERR "starfire: Failed to load firmware \"%s\"\n",
 		       FIRMWARE_RX);
-		return retval;
+		goto out_init;
 	}
 	if (fw_rx->size % 4) {
 		printk(KERN_ERR "starfire: bogus length %zu in \"%s\"\n",
@@ -1108,6 +1108,9 @@ out_tx:
 	release_firmware(fw_tx);
 out_rx:
 	release_firmware(fw_rx);
+out_init:
+	if (retval)
+		netdev_close(dev);
 	return retval;
 }
 


