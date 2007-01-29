Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXA2Sgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXA2Sgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXA2Sgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:36:35 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:29151 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXA2Sge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W9ozXDH/cx2CR/AAR8ErinYzkNi6fcoH7XWbBwQJQGOgtPxmL2yVIcNh1xRv0T0yQlOFO5QvPmc7qAQ0XFfgAtBclpCqtoYWNBCyeQqa6nhV6FEM2chQkngNt6xZYLmJwp9CClcifoL5IPuhxk67nAhkz1xeZGTixf7OusCl1Ps=
Message-ID: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com>
Date: Mon, 29 Jan 2007 12:36:33 -0600
From: "Kevin Nicoll" <blort128@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Multiple ip= boot arguments?
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using kernel 2.6.18, and have been trying without success to set
up multiple network interfaces using kernel boot arguments.  It makes
sense to be able to specify multiple interface configurations on the
command line, but it has occurred to me that I may not be correctly
understanding the purpose of the "ip=" parameter.  My question is if
it is intended to be able to use more than one "ip=" parameter in the
kernel command line, or if I'm supposed to use a startup script
instead.

I have been testing this using a variety of different boot command
lines, and it appears to me that the only network interface that ever
gets brought up by the kernel is the one defined in the last "ip="
parameter.  Here is some example output with debugging messages
enabled (lines beginning with "IP-Config(me):" are lines I added to
help with my understanding):

LINUX started...
 UART clock set to 50000000
 Linux version 2.6.18-pmc (nicollke@mozart) (gcc version 3.4.5) #46
PREEMPT Fri Jan 26 14:36:58 CST 2007
…
(snip)
…
 Kernel command line: console=ttyS0,57600
ip=192.168.183.77:::::eth1:none:100fs
ip=192.168.183.76::::pmcgw:eth0:none:an
 IP-Config(me): Parsing 192.168.183.77:::::eth1:none:100fs
 IP-Config: Parameter #0: `192.168.183.77'
 IP-Config: Parameter #5: `eth1'
 IP-Config: Parameter #6: `none'
 IP-Config: Parameter #7: `100fs'
 IP-Config(me): Parsing 192.168.183.76::::pmcgw:eth0:none:an
 IP-Config: Parameter #0: `192.168.183.76'
 IP-Config: Parameter #4: `pmcgw'
 IP-Config: Parameter #5: `eth0'
 IP-Config: Parameter #6: `none'
 IP-Config: Parameter #7: `an'
…
(snip)
…
IP-Config: Entered.
IP-Config(me): Trying to bring up eth0
IP-Config(me): Got inside!
MSPETH (init_cmdline) eth0: boot = console=ttyS0,57600
ip=192.168.183.77:::::eth1, option = 00
MSPETH (init_cmdline) eth0: boot = console=ttyS0,57600
ip=192.168.183.77:::::eth1, option = 00
MSPETH (init_phyaddr): hwunit = 0, phystr prom = "0:5"
MSPETH (queue_init) eth0:FD_base = a11a6000
arc 0x4: 000700e0
arc 0x8: 04000007
MSPETH eth0: Auto Negotiation... done.
MSPETH eth0: Waiting for carrier ... carrier detected.
MSPETH eth0: Autoneg, Link up, linkspeed 100Mbps, Full Duplex
IP-Config: eth0 UP (able=1, xid=4d9cf06a)
IP-Config(me): Trying to bring up eth1
IP-Config(me): Trying to bring up lo
IP-Config(me): Trying to bring up dummy0
IP-Config: Guessing netmask 255.255.255.0
arc 0xc: 01005e00
arc 0x10: 0001e307
IP-Config: Complete:
      device=eth0, addr=192.168.183.76, mask=255.255.255.0, gw=255.255.255.255,
     host=pmcgw, domain=, nis-domain=(none),
     bootserver=255.255.255.255, rootserver=255.255.255.255, rootpath=
VFS: Mounted root (squashfs filesystem) readonly.
Freeing unused kernel memory: 156k freed

The problem seems to be in the ic_open_devs() function in ipconfig.c,
which is the function responsible for actually starting up the network
interfaces.  I have copied function out below for your convenience:

static int __init ic_open_devs(void)
{
	struct ic_device *d, **last;
	struct net_device *dev;
	unsigned short oflags;

	last = &ic_first_dev;
	rtnl_lock();

	/* bring loopback device up first */
	if (dev_change_flags(&loopback_dev, loopback_dev.flags | IFF_UP) < 0)
		printk(KERN_ERR "IP-Config: Failed to open %s\n", loopback_dev.name);

	for (dev = dev_base; dev; dev = dev->next) {
		printk(KERN_WARNING "IP-Config(me): Trying to bring up %s\n", dev->name);
		if (dev == &loopback_dev)
			continue;
		if (user_dev_name[0] ? !strcmp(dev->name, user_dev_name) :
		    (!(dev->flags & IFF_LOOPBACK) &&
		     (dev->flags & (IFF_POINTOPOINT|IFF_BROADCAST)) &&
		     strncmp(dev->name, "dummy", 5))) {
			printk(KERN_WARNING "IP-Config(me): Got inside!\n");
			int able = 0;
			if (dev->mtu >= 364)
				able |= IC_BOOTP;
			else
				printk(KERN_WARNING "DHCP/BOOTP: Ignoring device %s, MTU %d too
small", dev->name, dev->mtu);
			if (!(dev->flags & IFF_NOARP))
				able |= IC_RARP;
			able &= ic_proto_enabled;
			if (ic_proto_enabled && !able)
				continue;
			oflags = dev->flags;
			if (dev_change_flags(dev, oflags | IFF_UP) < 0) {
				printk(KERN_ERR "IP-Config: Failed to open %s\n", dev->name);
				continue;
			}
			if (!(d = kmalloc(sizeof(struct ic_device), GFP_KERNEL))) {
				rtnl_unlock();
				return -1;
			}
			d->dev = dev;
			*last = d;
			last = &d->next;
			d->flags = oflags;
			d->able = able;
			if (able & IC_BOOTP)
				get_random_bytes(&d->xid, sizeof(u32));
			else
				d->xid = 0;
			ic_proto_have_if |= able;
			DBG(("IP-Config: %s UP (able=%d, xid=%08x)\n",
				dev->name, able, d->xid));
		}
	}
	rtnl_unlock();

	*last = NULL;

	if (!ic_first_dev) {
		if (user_dev_name[0])
			printk(KERN_ERR "IP-Config: Device `%s' not found.\n", user_dev_name);
		else
			printk(KERN_ERR "IP-Config: No network devices available.\n");
		return -1;
	}
	return 0;
}

Given the looping structure, I would like to assume that multiple
"ip=" parameters are intended to be supported.  However, for some
reason, eth1 fails the if condition inside the loop, resulting in it
not being initialized.  This happens for any number of "ip="
parameters that I define:  the first few defined "ip=" parameters do
not meet the condition and are not brought online, but the last "ip="
parameter meets the condition and is brought online.

Please CC comments and replies to me.  Any replies or feedback for
this issue is greatly appreciated.

Kevin
