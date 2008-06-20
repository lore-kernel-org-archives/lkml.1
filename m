Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYFTPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYFTPoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYFTPoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:44:03 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbYFTPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:44:01 -0400
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080620152748.GA21245@elte.hu>
References: <1213739834.3803.137.camel@johannes.berg>
	 <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
	 <1213774177.3803.164.camel@johannes.berg> <20080620134637.GA8135@elte.hu>
	 <20080620152748.GA21245@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0SdCdCUkxjQiOI3UAXo2"
Date: Fri, 20 Jun 2008 17:43:39 +0200
Message-Id: <1213976619.8967.204.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0SdCdCUkxjQiOI3UAXo2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-20 at 17:27 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>=20
> > > Subject: clean up and comment local_bh_enable code
> > >=20
> > > There's no need to use local_irq_save() over local_irq_disable() in=20
> > > the local_bh_enable code since it is a bug to call it with irqs=20
> > > disabled and do_softirq will enable irqs if there is any pending=20
> > > work. Consolidate the code from local_bh_enable and ..._ip to avoid=20
> > > having a disconnect between them in the warnings they trigger that=20
> > > is currently there. Also always trigger the warning on in_irq(), not=20
> > > just in the trace-irqflags case.
> >=20
> > applied to tip/core/softirq for testing, thanks Johannes.
>=20
> ok, -tip testing found that your patch triggers a new warning on an old=20
> testbox that uses 3c59x vortex and netlogging:
>=20
> ----->
> calling  vortex_init+0x0/0xb0
> PCI: Found IRQ 10 for device 0000:00:0b.0
> PCI: Sharing IRQ 10 with 0000:00:0a.0
> PCI: Sharing IRQ 10 with 0000:00:0b.1
> 3c59x: Donald Becker and others.
> 0000:00:0b.0: 3Com PCI 3c556 Laptop Tornado at e0800400.
> PCI: Enabling bus mastering for device 0000:00:0b.0
> initcall vortex_init+0x0/0xb0 returned 0 after 47 msecs
> ...
> calling  init_netconsole+0x0/0x1b0
> netconsole: local port 4444
> netconsole: local IP 10.0.1.9
> netconsole: interface eth0
> netconsole: remote port 4444
> netconsole: remote IP 10.0.1.16
> netconsole: remote ethernet address 00:19:xx:xx:xx:xx
> netconsole: device eth0 not up yet, forcing it
> eth0:  setting half-duplex.
> eth0:  setting full-duplex.
> ------------[ cut here ]------------
> WARNING: at kernel/softirq.c:137 local_bh_enable_ip+0xd1/0xe0()
> Pid: 1, comm: swapper Not tainted 2.6.26-rc6-tip #2091
>  [<c0125ecf>] warn_on_slowpath+0x4f/0x70
>  [<c0126834>] ? release_console_sem+0x1b4/0x1d0
>  [<c0126d00>] ? vprintk+0x2a0/0x450

Now you can't printk in irq context any more?

vprintk:
        /*
         * Try to acquire and then immediately release the
         * console semaphore. The release will do all the=20
         * actual magic (print out buffers, wake up klogd,
         * etc).=20
         *
         * The acquire_console_semaphore_for_printk() function
         * will release 'logbuf_lock' regardless of whether it
         * actually gets the semaphore or not.
         */
        if (acquire_console_semaphore_for_printk(this_cpu))
                release_console_sem();


johannes

--=-0SdCdCUkxjQiOI3UAXo2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW9AnAAoJEKVg1VMiehFY0+gQAIDY1FztxL0kciz79I8N4dq9
YucTwXilNtsIFSCEWW2VzyMDOQU3anKiTYi+NPEdPXGgB6WrY3j9BjRVxJPbzeuv
29TtkPUzUQBv9kB7C1XAp1UPhEJi5kkMMov8908qQPURg0UX1OElyF0x7nBqyhTh
+xl2681BTEHP8uoTpHgVqGJ+3IVsIUino/XbNdOiUoPwl6+V8mpkCB4lvU81zIDO
Ul5JTgYeJdVPZG+bll1g+rskMoO5198PzzcjP4glNib3uvndGqnkRfMXFlUJegek
mt/CZrLYIAf3XajT8NPlXjqRaVVIag3btjk5VnbqWid1I8jqcL1Ymk/aGlzrpW17
JnH0WSijtvQ49yYNmaMemRZHhf43+lAY2247C8aOV6rdRbiywxKHNuMphiHqSHk+
viCA5OkbZsNGYKvsC7PfgtIXt5C34txxrsza9cjtKIUAIp/H3riuW4sEOzGWLDs5
zyCO40S82LWrjfydmvyWWCvzdpQvwGt4xkOwVtOYC2oIJbElRsuL3fqLy0n8go87
j2z2bjedUsmb5HzilquYNU2VCk2Do0a5Mtn9TcPLvfioBQou+ka/+ybifyNh4CpL
2ntZeAKSwBR75zb5eFF27eYXNBQ3IYEcuaUleODGzEgQZ8ciXeqoqTKX/PTIilu7
Da8Cwp5clRvb2CkFaunW
=2QLx
-----END PGP SIGNATURE-----

--=-0SdCdCUkxjQiOI3UAXo2--

