Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXHBM42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXHBM42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXHBM4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:56:18 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20739 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbXHBM4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:56:16 -0400
Message-ID: <46B1D46D.7080609@msgid.tls.msk.ru>
Date: Thu, 02 Aug 2007 16:56:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
References: <200708021056.l72Au722008603@wildsau.enemy.org> <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 2 2007 15:23, Michael Tokarev wrote:
>> Herbert Rosmanith wrote:
>>>> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>>>> There never *were* days when eth0 remained eth0 across such changes.
>> []
>>> of course, that's problem with gentoo, not with the kernel.
>> To me it'd be a problem, but I don't run udev (more, I hate udev ;)
>>
>> By the way, this very approach (renaming "new" eth0 interface to the next
>> "free" ethX) seems to be flawed.
> 
> It does not rename ethX to the "next free" one, but to a _persistent_ one.
> If it were a "next free" thing, then removing a card would shuffle all
> your eth around again (and invalidate your iptables rules at the same
> time, to note).

Note I said ``"new" eth0'' -- i.e, when udev sees new NIC (with new, yet
unknown to this system, MAC address), it assigns it a "next free" (from
it's persistent names list), now persistent, ethN.

Shuffling rest of the interfaces if eth0 is removed and no this persistent
naming present is obvious, including invalidating iptable rules and
breaking dhcp configuration and other stuff.  But I was referring to
something different -- below.

>> first of all, I'd turn this behaviour off by default, but only when the
>> user asked me to do so - say, when a new NIC is found, ask a user what's
>> the name he wants it to be known as.  *Or* choosed different "basename"
>> for the renamed devices.  So that in-kernel eth0 becomes, say, nicX
>> instead of ethX - to make things explicit.  Current way is just too
>> confusing, when eth0 quietly becomes eth2 or whatnot.
> 
> Remember that persistent names also need to provide means for
> hot-pluggable devices. Say your eth0 was a wireless, then you surely would
> _not ever_ want that on removal of eth0, all other cards step one down
> (eth1,eth2,ethN->eth0,eth1,ethN-1). Unfortuantely, I think it is hard (if
> not that, then it's a lot of code) to distinguish coldplugged vs
> hotplugged devices.

There's really no need to distinguish them (and by the way, wireless !=
hot-pluggable.  There are PCI wireless cards (non-hotplug), and there
are, say, PCMCIA or USB ethernet cards (hotplug)).

Well, I see your point here (I think) -- by assigning names to hotplug
devices from a different namespace (hpethN vs ethN for example) we will
stop shuffling *everything* (without persistent names like udev does) -
but that doesn't really help anyway because of module loading order for
example, and because non-hotplug devices (like PCI) can be missing
(and new added) too on next reboot.

What I mean is -- if I, as a user, care about interface (or other)
names when I replug my NICs (if I ever do that in the first place),
I can assign names to them explicitly (and some programs that are
running at system startup - like kudzu on redhat for example - may
just ask me when finding something new), and THOSE explicitly set
names should be persistent for sure.  Preferrable they will be in
different namespace (not named as ethX but, say, lan or isp or
segment12 - user chooses the name).  And nothing will break
(iptables or dhcp or whatnot) when using THOSE persistent names.

When I don't care, usually I don't have many interfaces to worry
about, either.  But in this case it's expectable that names of
existing interfaces after removing one may change.

Kernel uses SOME names for the interfaces anyway when it boots up
(more on this below).  If - in case I don't care or just didn't
know (which is more often I think) about renumbering, udev by
default MAY assign persistent names like it does (using nicX
scheme), but it'd be better (IMHO anyway) that those names will
be implemented as aliases, not as rename...

>> And second half, which is more important here, is to always keep kernel
>> names, and create aliases named by user (or automatic nicX scheme).  This
>> is fundamental -- applies to every device on the system.
> 
> This is easy. Edit /lib/udev/rename_netiface to always hand out "nicX"
> regardless of whether the input device was ethX, trX, raX, wlanX or
> whatever.

Again, the key point here in the "alias" thing.  Whatever basename will
be used is irrelevant, but I wanted to preserve BOTH names...

>> For example, if kernel says it has disk named "sda", it should be
>> accessible as /dev/sda (and /sys/block/sda, whatever),
> 
> Note that /dev/sda is not persistent either.

Yes it's not, but during kernel lifetime (from boot to shutdown) it
at least MAY be persistent, unless it's a removable device which gets
re-plugged.

>> and any alternative names ("boot disk", disk-serial-12345 etc yadda)
>> should be symlinks in /dev.  Ie, general rule is to remove *ALL* "NAME"
>> statements from udev.conf file and use "SYMLINK" instead.
> 
> See above - make rename_netiface use nicX. (Symlinks don't exist for
> netdevices.)

And this is what's needed for the scheme to work - to be able to have
symlinks.  Which name the alias will have is irrelevant, but the symlink
(alias) is important.

>> For network interfaces, ifconfig -a may omit the kernel names from the
>> listing (but in this case, say, ifconfig -aa should still show them), or
>> alternatively it may show something like
> 
> (ifconfig has been superseded by iproute2, please use it :)

I know, but for many people ifconfig is still much more familiar tool.

>> eth0      Link encap:Ethernet  HWaddr XX:XX:XX:XX:XX  Name nic10
>>                                                      ^^^^^^^^^^
>> and both
>>  ifconfig eth0 blablabla
>> and
>>  ifconfig nic10 blablabla
>> will work identically.
> 
> I prefer nic10 directly over having a dual. You'd be totally lost
> of syslog showed eth0 (from klog) and nic10 (from userspace).

Well, both userspace and kernelspace may log nic10(eth0) instead.

>> I already can see comments from udev/sysfs maintainers here: "naming
>> is a policy which does not belong to kernel".  It's a bullshit, because
>> kernel too has to use SOME way to name things,
> 
> (1) The kernel starts with ethX
> (2) udev renames it to something else
> (3) kernel uses new name too ("ni0: link down")

And now tell me please how can I connect two messages from dmesg:

eth0: Tigon3 [partno(BCM95721) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:14:5e:5d:18:26
nic10: Link is up at 100 Mbps, full duplex.

For example, I see the first line and notice the card isn't configured
properly somehow, and want to use ethtool to tweak it - I run ethtool
on eth0 and it obviously fails.

(logging renames from udev seems to be a good idea - with kern priority,
so that the two pieces will be in the same logfile, and it helps, but
only somewhat).

What I wanted to say (here with network devices, and with disk names
and everything else) is -- as long as the device is here (plugged in
but not yet unplugged), I want it to have the same "primary" name in
kernel and in userspace, so that everything - logging, sysfs, /dev,
/proc/partitions&whatnot, maybe configs - will match each other.

Once the device is replugged, it may become different kernnameN
(eth5, sdf, whatever), and again, from the point when it has been
plugged in, the "kernel" names match each other as above.  If
persistent naming is configured/in effect, aliases (nic10,
bootdrive etc) "connects" to the new in-kernel name, and
everything relying on those persistent names continues working.

Well, having two (or more) names for non-device nodes (like
network cards which don't have corresponding /dev/ethX) is
probably asking for too much because it's the kernel who
should provide infrastructure for that, unlike things
like /dev/sda vs /dev/bootdrive which is purely userspace
thing.  But it's not that difficult to do either and
isn't too bloated.

By the way, It'd be nice to be able to store list of names
a given device is known somewhere in /sys/device/foo/aliases
(in line with modalias, dev, and other attributes in that
directory), instead of the way udevd keeps them in
/dev/.udevdb (or somesuch -- don't remember offhand).
Just a little rw text attribute which has no meaning
for the kernel but which is settable and queriable from
userspace.  But that's a very-very minor thing.

/mjt
