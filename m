Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYBRQmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYBRQmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYBRQmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:42:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYBRQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:42:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
Date: Mon, 18 Feb 2008 17:41:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Kosina <jkosina@suse.cz>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com> <Pine.LNX.4.64.0802181441300.30955@jikos.suse.cz> <47B9928A.60202@balabit.hu>
In-Reply-To: <47B9928A.60202@balabit.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181741.09046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
> Jiri Kosina wrote:
> > On Mon, 18 Feb 2008, Laszlo Attila Toth wrote:
> > 
> >> Okay, but I can't figure out what's the problem with it. I don't have 
> >> wireless card on my linux box also I can't test it but everything else 
> >> works. Swap is mounted. The concurrency cannot be a problem because the 
> >> write operation is protected by a lock.
> > 
> > -               write_lock_bh(&dev_base_lock);
> > -               dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
> > -               write_unlock_bh(&dev_base_lock);
> > +               if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
> > +                       write_lock_bh(&dev_base_lock);
> > +                       dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
> > +                       write_lock_bh(&dev_base_lock);
> > +                       modified = 1;
> > +               }
> >         }
> > 
> > 1) you are accessing dev->link_mode and tb[] outside the dev_base_lock 
> 
> yes, because tb[IFLA_LINKMODE] is not used by someone else in this case 
> only dev->link_mode. Although its value is unpredictable in case of a 
> concurrent access in the condition, it does not affect the final value 
> of dev->link_mode but the length of the critical section remains 
> minimal. The if statement may be inside the lock.
> 
> > 2) there is obvious and immediate deadlock -- you acquire the 
> >    dev_base_lock twice, without any unlock, just look at the chunk above
> 
> Indeed:
> "Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,"
> 
> I missed it. I copied the code from another patch which didn't contain 
> the two locking statements and when I copied them back it became a 
> copy-paste bug.
> 
> 
> > 3) even with this deadlock fixed, Rafael states that either NM or 
> >    wpa_supplicant (I don't recall from top of my head) still don't work
> 
> That's bad. Does my suggestion solve the problem? Again:
> 
> -      if (modified)
> -                 netdev_state_change(dev);
> +      if (modified && dev->flags & IFF_UP)
> +                 call_netdevice_notifiers(NETDEV_CHANGE, dev)

All in all, I gather you wanted me to test the patch below. :-)

Yes, that helps.

Thanks,
Rafael

---
Fix net/core/rtnetlink.c breakage caused by commit
45b503548210fe6f23e92b856421c2a3f05fd034
"[RTNETLINK]: Send a single notification on device state changes."

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 net/core/rtnetlink.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/net/core/rtnetlink.c
===================================================================
--- linux-2.6.orig/net/core/rtnetlink.c
+++ linux-2.6/net/core/rtnetlink.c
@@ -853,7 +853,7 @@ static int do_setlink(struct net_device 
 		if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
 			write_lock_bh(&dev_base_lock);
 			dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
-			write_lock_bh(&dev_base_lock);
+			write_unlock_bh(&dev_base_lock);
 			modified = 1;
 		}
 	}
@@ -870,8 +870,8 @@ errout:
 	if (send_addr_notify)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 
-	if (modified)
-		netdev_state_change(dev);
+	if (modified && dev->flags & IFF_UP)
+		call_netdevice_notifiers(NETDEV_CHANGE, dev);
 
 	return err;
 }
