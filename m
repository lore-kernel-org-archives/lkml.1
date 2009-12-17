Return-Path: <linux-kernel-owner+w=401wt.eu-S936340AbZLQEMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340AbZLQEMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936326AbZLQEL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:11:59 -0500
Received: from kroah.org ([198.145.64.141]:56012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936184AbZLQEFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:00 2009
Message-Id: <20091217035700.235380354@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       David Miller <davem@davemloft.net>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, marcel@holtmann.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [133/151] net: Fix userspace RTM_NEWLINK notifications.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit d90a909e1f3e006a1d57fe11fd417173b6494701 upstream.

I received some bug reports about userspace programs having problems
because after RTM_NEWLINK was received they could not immeidate
access files under /proc/sys/net/ because they had not been
registered yet.

The problem was trivailly fixed by moving the userspace
notification from rtnetlink_event to the end of register_netdevice.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c       |   11 +++++++++++
 net/core/rtnetlink.c |    4 +---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4860,6 +4860,11 @@ int register_netdevice(struct net_device
 		rollback_registered(dev);
 		dev->reg_state = NETREG_UNREGISTERED;
 	}
+	/*
+	 *	Prevent userspace races by waiting until the network
+	 *	device is fully setup before sending notifications.
+	 */
+	rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U);
 
 out:
 	return ret;
@@ -5398,6 +5403,12 @@ int dev_change_net_namespace(struct net_
 	/* Notify protocols, that a new device appeared. */
 	call_netdevice_notifiers(NETDEV_REGISTER, dev);
 
+	/*
+	 *	Prevent userspace races by waiting until the network
+	 *	device is fully setup before sending notifications.
+	 */
+	rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U);
+
 	synchronize_net();
 	err = 0;
 out:
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1334,13 +1334,11 @@ static int rtnetlink_event(struct notifi
 	case NETDEV_UNREGISTER:
 		rtmsg_ifinfo(RTM_DELLINK, dev, ~0U);
 		break;
-	case NETDEV_REGISTER:
-		rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U);
-		break;
 	case NETDEV_UP:
 	case NETDEV_DOWN:
 		rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP|IFF_RUNNING);
 		break;
+	case NETDEV_REGISTER:
 	case NETDEV_CHANGE:
 	case NETDEV_GOING_DOWN:
 		break;


