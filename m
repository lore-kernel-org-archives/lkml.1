Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYFCUh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYFCUh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYFCUgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:36:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47062
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYFCUgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:36:51 -0400
Date: Tue, 03 Jun 2008 13:28:38 -0700 (PDT)
Message-Id: <20080603.132838.114305874.davem@davemloft.net>
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mokuno@sm.sony.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/12]: wext: Pull top-level ioctl dispatch logic into
 helper function.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/wireless/wext.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index b72cdd2..91cf548 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -1079,8 +1079,10 @@ static int wext_permission_check(unsigned int cmd)
 }
 
 /* entry point from dev ioctl */
-int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
-		      void __user *arg)
+static int wext_ioctl_dispatch(struct net *net, struct ifreq *ifr,
+			       unsigned int cmd,
+			       wext_ioctl_func standard,
+			       wext_ioctl_func private)
 {
 	int ret = wext_permission_check(cmd);
 
@@ -1089,12 +1091,24 @@ int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
 
 	dev_load(net, ifr->ifr_name);
 	rtnl_lock();
-	ret = wireless_process_ioctl(net, ifr, cmd,
-				     ioctl_standard_call,
-				     ioctl_private_call);
+	ret = wireless_process_ioctl(net, ifr, cmd, standard, private);
 	rtnl_unlock();
-	if (IW_IS_GET(cmd) && copy_to_user(arg, ifr, sizeof(struct iwreq)))
+
+	return ret;
+}
+
+int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
+		      void __user *arg)
+{
+	int ret = wext_ioctl_dispatch(net, ifr, cmd,
+				      ioctl_standard_call,
+				      ioctl_private_call);
+
+	if (ret >= 0 &&
+	    IW_IS_GET(cmd) &&
+	    copy_to_user(arg, ifr, sizeof(struct iwreq)))
 		return -EFAULT;
+
 	return ret;
 }
 
-- 
1.5.5.1.308.g1fbb5

