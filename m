Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXHBLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXHBLrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXHBLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:47:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33086 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXHBLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:47:24 -0400
Date: Thu, 2 Aug 2007 13:47:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev
 numbering]
In-Reply-To: <46B1BEB8.70104@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <46B1BEB8.70104@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 15:23, Michael Tokarev wrote:
>Herbert Rosmanith wrote:
>>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>>> There never *were* days when eth0 remained eth0 across such changes.
>[]
>> of course, that's problem with gentoo, not with the kernel.
>
>To me it'd be a problem, but I don't run udev (more, I hate udev ;)
>
>By the way, this very approach (renaming "new" eth0 interface to the next
>"free" ethX) seems to be flawed.

It does not rename ethX to the "next free" one, but to a _persistent_ one.
If it were a "next free" thing, then removing a card would shuffle all
your eth around again (and invalidate your iptables rules at the same
time, to note).

>first of all, I'd turn this behaviour off by default, but only when the
>user asked me to do so - say, when a new NIC is found, ask a user what's
>the name he wants it to be known as.  *Or* choosed different "basename"
>for the renamed devices.  So that in-kernel eth0 becomes, say, nicX
>instead of ethX - to make things explicit.  Current way is just too
>confusing, when eth0 quietly becomes eth2 or whatnot.

Remember that persistent names also need to provide means for
hot-pluggable devices. Say your eth0 was a wireless, then you surely would
_not ever_ want that on removal of eth0, all other cards step one down
(eth1,eth2,ethN->eth0,eth1,ethN-1). Unfortuantely, I think it is hard (if
not that, then it's a lot of code) to distinguish coldplugged vs
hotplugged devices.

>And second half, which is more important here, is to always keep kernel
>names, and create aliases named by user (or automatic nicX scheme).  This
>is fundamental -- applies to every device on the system.

This is easy. Edit /lib/udev/rename_netiface to always hand out "nicX"
regardless of whether the input device was ethX, trX, raX, wlanX or
whatever.

>For example, if kernel says it has disk named "sda", it should be
>accessible as /dev/sda (and /sys/block/sda, whatever),

Note that /dev/sda is not persistent either.

>and any alternative names ("boot disk", disk-serial-12345 etc yadda)
>should be symlinks in /dev.  Ie, general rule is to remove *ALL* "NAME"
>statements from udev.conf file and use "SYMLINK" instead.

See above - make rename_netiface use nicX. (Symlinks don't exist for
netdevices.)

>For network interfaces, ifconfig -a may omit the kernel names from the
>listing (but in this case, say, ifconfig -aa should still show them), or
>alternatively it may show something like

(ifconfig has been superseded by iproute2, please use it :)

>eth0      Link encap:Ethernet  HWaddr XX:XX:XX:XX:XX  Name nic10
>                                                      ^^^^^^^^^^
>and both
>  ifconfig eth0 blablabla
>and
>  ifconfig nic10 blablabla
>will work identically.

I prefer nic10 directly over having a dual. You'd be totally lost
of syslog showed eth0 (from klog) and nic10 (from userspace).

>I already can see comments from udev/sysfs maintainers here: "naming
>is a policy which does not belong to kernel".  It's a bullshit, because
>kernel too has to use SOME way to name things,

(1) The kernel starts with ethX
(2) udev renames it to something else
(3) kernel uses new name too ("ni0: link down")

> and either we should teach it to use our names EVERYWHERE (including
>early-boot printk()), or accept the fact that any userspace naming (the
>"policy") should be implemented as aliases for kernel names, not as
>renames.
>
>(And no, things like "I/O error on SCSI device 8:32 sector XXX" is even
>worse - I don't want to care which numbers are used for the devices,
>I want to see which sdX it is).

	Jan
-- 
