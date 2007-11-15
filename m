Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbXKOKwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbXKOKwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXKOKwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:52:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758155AbXKOKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:51:59 -0500
Date: Thu, 15 Nov 2007 02:51:58 -0800 (PST)
Message-Id: <20071115.025158.254212538.davem@davemloft.net>
To: mingo@elte.hu
Cc: mpm@selenic.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071115104331.GA11390@elte.hu>
References: <20071114233713.GW19691@waste.org>
	<20071114.154143.112110604.davem@davemloft.net>
	<20071115104331.GA11390@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Nov 2007 11:43:32 +0100

> The crash logs contain this:
> 
>  VFS: Mounted root (ext3 filesystem) readonly.
>  Freeing unused kernel memory: 396k freed
>  Write protecting the kernel read-only data: 2056k
>  udev: renamed network interface eth1 to eth0
>  udev: renamed network interface eth0_rename to eth1
>  eth0: link down
>  ADDRCONF(NETDEV_UP): eth0: link is not ready
>  EXT3 FS on sda6, internal journal
>  kjournald starting.  Commit interval 5 seconds
> 
> followed by the crash shortly afterwards (but not immediately). With the 
> non-crashing kernel i dont get those "renamed network interface" 
> messages.
> 
> network interface renaming has been a historic source of pain for me so 
> i frequently have to 'twiddle' the networking config to make it work 
> again on new kernels. Perhaps because i'm using bzImage kernels. 
> User-space is Fedora 8, so fairly recent.

Yeah I wish udev would just leave the damn devices alone.

It even does things like try to rename a network device to the same
name it already has, and other strange stuff.

But that log difference is a good clue.

Because udev can try to rename a network device stupidly to a name the
device already has we added a patch to just short circuit this case in
the networking.  We did this because otherwise the generic device
layer gives an ugly stack backtrace via dev_rename().

Therefore, you might want to see if reverting that patch (attached
below) has some effect, once you are able to trigger it again.

Thanks Ingo.

commit c8d90dca3211966ba5189e0f3d4bccd558d9ae08
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Fri Oct 26 03:53:42 2007 -0700

    [NET] dev_change_name: ignore changes to same name
    
    Prevent error/backtrace from dev_rename() when changing
    name of network device to the same name. This is a common
    situation with udev and other scripts that bind addr to device.
    
    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/dev.c b/net/core/dev.c
index f1647d7..ddfef3b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -883,6 +883,9 @@ int dev_change_name(struct net_device *dev, char *newname)
 	if (!dev_valid_name(newname))
 		return -EINVAL;
 
+	if (strncmp(newname, dev->name, IFNAMSIZ) == 0)
+		return 0;
+
 	memcpy(oldname, dev->name, IFNAMSIZ);
 
 	if (strchr(newname, '%')) {
