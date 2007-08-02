Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbXHBLXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbXHBLXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXHBLXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:23:40 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21744 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXHBLXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:23:39 -0400
Message-ID: <46B1BEB8.70104@msgid.tls.msk.ru>
Date: Thu, 02 Aug 2007 15:23:36 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
References: <200708021056.l72Au722008603@wildsau.enemy.org>
In-Reply-To: <200708021056.l72Au722008603@wildsau.enemy.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Rosmanith wrote:
>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>> There never *were* days when eth0 remained eth0 across such changes.
[]
> of course, that's problem with gentoo, not with the kernel.

Whenever it's a problem or not is questionable too.  I mean,
ethX order depends on module loading order, or on PCI slot
number, or whatnot.  So userspace (udev) tries to compensate
(sometimes its own design.. issues - module loading order
in this case).  It's worse if you'll have eth0 and eth1
swapped on every boot depending on tiny module loading
time differences.

To me it'd be a problem, but I don't run udev (more,
I hate udev ;)

By the way, this very approach (renaming "new" eth0
interface to the next "free" ethX) seems to be flawed.

If I'd were to implement this scheme, I'd do two things
instead of one currently done, and I'd do whatever is
currently done by udev a bit differently (but second
half requires (minor) kernel mods):

first of all, I'd turn this behaviour off by default,
but only when the user asked me to do so - say, when
a new NIC is found, ask a user what's the name he
wants it to be known as.  *Or* choosed different
"basename" for the renamed devices.  So that
in-kernel eth0 becomes, say, nicX instead of
ethX - to make things explicit.  Current way is just
too confusing, when eth0 quietly becomes eth2 or
whatnot.

And second half, which is more important here, is to
always keep kernel names, and create aliases named
by user (or automatic nicX scheme).  This is fundamental --
applies to every device on the system.  For example,
if kernel says it has disk named "sda", it should be
accessible as /dev/sda (and /sys/block/sda, whatever),
and any alternative names ("boot disk", disk-serial-12345
etc yadda) should be symlinks in /dev.  Ie, general rule
is to remove *ALL* "NAME" statements from udev.conf file
and use "SYMLINK" instead.

For network interfaces, ifconfig -a may omit the kernel
names from the listing (but in this case, say, ifconfig -aa
should still show them), or alternatively it may show
something like

eth0      Link encap:Ethernet  HWaddr XX:XX:XX:XX:XX  Name nic10
                                                      ^^^^^^^^^^
and both
  ifconfig eth0 blablabla
and
  ifconfig nic10 blablabla
will work identically.

I.e., the general rule is: kernel has some naming scheme,
because it has to name things in dmesg, in /sys, in /proc/partitions
etc *somehow*.  And those "kernel names" should always be accessible,
and stay here at least up to the next reboot.  All the rest are
"aliases", alternative names for "kernel names".

I already can see comments from udev/sysfs maintainers here: "naming
is a policy which does not belong to kernel".  It's a bullshit, because
kernel too has to use SOME way to name things, and either we should
teach it to use our names EVERYWHERE (including early-boot printk()),
or accept the fact that any userspace naming (the "policy") should
be implemented as aliases for kernel names, not as renames.

(And no, things like "I/O error on SCSI device 8:32 sector XXX" is even
worse - I don't want to care which numbers are used for the devices,
I want to see which sdX it is).

/mjt
