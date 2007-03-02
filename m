Return-Path: <linux-kernel-owner+w=401wt.eu-S1422694AbXCBBbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422694AbXCBBbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422683AbXCBBbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:31:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34288 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422694AbXCBBbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:31:35 -0500
Date: Thu, 1 Mar 2007 17:30:30 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: [RFC] Arp announce (for Xen)
Message-ID: <20070301173030.754514ec@freekitty>
In-Reply-To: <45E7764A.7000100@goop.org>
References: <20070301232443.195603797@goop.org>
	<20070301232529.648076372@goop.org>
	<20070301164214.4a40bc59@freekitty>
	<45E7764A.7000100@goop.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What about implementing the unused arp_announce flag on the inetdevice?
Something like the following.  Totally untested...

Looks like it either was there (and got removed) or was planned but
never implemented.

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e10794d..cefc339 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1089,6 +1089,16 @@ static int inetdev_event(struct notifier
 			}
 		}
 		ip_mc_up(in_dev);
+		/* fallthru */
+
+	case NETDEV_CHANGEADDR:
+		/* Send gratuitous ARP in case of address change or new device */
+		if (IN_DEV_ARP_ANNOUNCE(in_dev))
+			arp_send(ARPOP_REQUEST, ETH_P_ARP,
+				 in_dev->ifa_list->ifa_address, dev,
+				 in_dev->ifa_list->ifa_address, NULL, 
+				 dev->dev_addr, NULL);
+			
 		break;
 	case NETDEV_DOWN:
 		ip_mc_down(in_dev);

