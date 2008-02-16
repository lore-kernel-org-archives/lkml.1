Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbYBPCLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbYBPCLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764450AbYBPCKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:10:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764363AbYBPCKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:10:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc2
Date: Sat, 16 Feb 2008 03:08:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laszlo Attila Toth <panther@balabit.hu>,
       David Miller <davem@davemloft.net>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802160308.52294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 of February 2008, Linus Torvalds wrote:
> 
> Ok,
>  this kernel is a winner.
> 
> Just to show how _much_ of a winner it is, it's been awarded a coveted 
> "weasel" series name, which should tell you just how good it's going to 
> be. It's a name revered in Linux kernel history, and as such this brings 
> back the good old days where if you find a bug, you're almost certainly 
> simply mistaken, and you probably just did something wrong.
> 
> But hey, you can try to prove me wrong.  I dare you.

Here you go.

commit 45b503548210fe6f23e92b856421c2a3f05fd034
Author: Laszlo Attila Toth <panther@balabit.hu>
Date:   Tue Feb 12 22:42:09 2008 -0800

    [RTNETLINK]: Send a single notification on device state changes.

contains the following gem:

        if (tb[IFLA_LINKMODE]) {
-               write_lock_bh(&dev_base_lock);
-               dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
-               write_unlock_bh(&dev_base_lock);
+               if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
+                       write_lock_bh(&dev_base_lock);
+                       dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
+                       write_lock_bh(&dev_base_lock);
+                       modified = 1;
+               }
        }

and even with that fixed it breaks NetworkManager (on my test box it apparently
can't get the IP address using DHCP).  Reverting this commit makes things
work again.

Well, it looks like this patch went to you untested and unreviewed, so may I
gently request that it be reverted from your tree, pretty please?

Thanks,
Rafael
