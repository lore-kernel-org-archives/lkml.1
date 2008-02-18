Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYBRNoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYBRNoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBRNoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:44:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:35127 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbYBRNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:44:30 -0500
Date: Mon, 18 Feb 2008 14:44:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Laszlo Attila Toth <panther@balabit.hu>
cc: David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
In-Reply-To: <47B982C9.60207@balabit.hu>
Message-ID: <Pine.LNX.4.64.0802181441300.30955@jikos.suse.cz>
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>
 <Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz> <20080217.183621.110686685.davem@davemloft.net>
 <47B982C9.60207@balabit.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Laszlo Attila Toth wrote:

> Okay, but I can't figure out what's the problem with it. I don't have 
> wireless card on my linux box also I can't test it but everything else 
> works. Swap is mounted. The concurrency cannot be a problem because the 
> write operation is protected by a lock.

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

1) you are accessing dev->link_mode and tb[] outside the dev_base_lock 
2) there is obvious and immediate deadlock -- you acquire the 
   dev_base_lock twice, without any unlock, just look at the chunk above
3) even with this deadlock fixed, Rafael states that either NM or 
   wpa_supplicant (I don't recall from top of my head) still don't work

-- 
Jiri Kosina
SUSE Labs
