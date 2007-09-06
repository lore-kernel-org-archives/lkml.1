Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXIFPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXIFPC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXIFPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:02:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:48722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbXIFPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jeyn3bF0QsAJfHMzGlgro9TDe37EGwo615WTLWP5QRabnRikFGg7LSLL1GT2/gHaPavc3crjnhKCAIcYrWtzCAeqBVBibbxVUlyW2udfjpmaJz5/eQYMMi5EFJ4O2Jl4Fk8MJ+iPGWPsEJeAX8w3JGKv0B26/5hpyPU18s4vezY=
Message-ID: <6e7a378f0709060802r677b4a8emb9c8cb7530f8028b@mail.gmail.com>
Date: Thu, 6 Sep 2007 17:02:40 +0200
From: "davide rossetti" <davide.rossetti@gmail.com>
To: "Bill Nottingham" <notting@redhat.com>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or user-space
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070906133551.GA25155@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
	 <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr>
	 <20070906133551.GA25155@nostromo.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/07, Bill Nottingham <notting@redhat.com> wrote:
> Jan Engelhardt (jengelh@computergmbh.de) said:
> > >dear all,
> > >I'm trying to track down a problem on a Sun V40Z server with 4 network
> > >devices grabbing random ethX device names. now, trying to force the
> > >device names to what I want, I got a __tmpXXXXX form of device name,
> > >which I think is a half-configured device... but which piece of
> > >software is to blame ??? kernel, udev, hotplug
> >
> > Look into dmesg. If the device was once known as ethX or similar,
> > then it is userspace to blame.
>
> It's userspace.

while we are at it.... could you briefly help me describe the 'code
sequence' involved in the naming of an interface ? with it we could
write a small doc...

for instance I'm tracking tg3.c code as:
 alloc_etherdev()
 --> sets net_device->name="eth%d"

 register_netdev()
 --> register_netdevice()
      --> netdev_register_sysfs(struct net_device *net)
           struct device *dev = &(net->dev)
           dev->class = &net_class
           --> device_add(dev)

here I stopped... but I guess that device_add builds and event for udev.

anyway, on my system it produces such a sysfs device:

$> udevinfo  -p /sys/class/net/__tmp1930643048 -a
  looking at device '/class/net/__tmp1930643048':
    KERNEL=="__tmp1930643048"
    SUBSYSTEM=="net"
    SYSFS{weight}=="64"
    SYSFS{tx_queue_len}=="1000"
    SYSFS{flags}=="0x1002"
    SYSFS{mtu}=="1500"
    SYSFS{operstate}=="down"
    SYSFS{broadcast}=="ff:ff:ff:ff:ff:ff"
    SYSFS{address}=="00:04:23:ca:bc:cb"
    SYSFS{link_mode}=="0"
    SYSFS{type}=="1"
    SYSFS{features}=="0x113a9"
    SYSFS{ifindex}=="5"
    SYSFS{iflink}=="5"
    SYSFS{addr_len}=="6"

> <off-topic for l-k, but while I'm here...>
>
> I'm assuming you're running some sort of Fedora/RHEL/
> derivative; this is what you get when you have a device that starts
> out named ethX, but which needed to be renamed so that an already
> configured ethX could be changed to that name.

yes, it's FC6.

> For the new device, either add a HWADDR in a ifcfg-ethX file for
> that interface, add something to /etc/mactab, or add a udev rule.

seems like HWADDR is incompatible with bonding.... there is some
message using HWADDR as well as MASTER=bond0 and SLAVE=yes.

davide

-- 
davide.rossetti@gmail.com ICQ:290677265 SKYPE:d.rossetti
