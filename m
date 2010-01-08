Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304Ab0AHRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0AHRqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465Ab0AHRqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:46:21 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51114 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0AHRqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:46:20 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bonding: potential null dereference?
In-reply-to: <4B470606.7090409@gmail.com>
References: <4B470606.7090409@gmail.com>
Comments: In-reply-to Jiri Slaby <jirislaby@gmail.com>
   message dated "Fri, 08 Jan 2010 11:16:38 +0100."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
Date: Fri, 08 Jan 2010 09:46:00 -0800
Message-ID: <16196.1262972760@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> wrote:

>I'm looking at Stanse errors and it detected a suspected behaviour in
>bonding. In bond_slave_netdev_event, bond_dev is passed down to
>netdev_priv, but due to 'if (bond_dev)' test later, it deduced it can be
>also NULL.
>
>I can see, that passing NULL to netdev_priv is OK nowadays, as it just
>returns NULL + some offset. But what if this changes in the future?
>
>I would bake a patch, but I don't know if bond_dev may be NULL at all
>(i.e. superfluous test) or may not (wrong netdev_priv(bond_dev)).
>
>static int (unsigned long event,
>                                   struct net_device *slave_dev)
>{
>        struct net_device *bond_dev = slave_dev->master;
>        struct bonding *bond = netdev_priv(bond_dev);
>
>        switch (event) {
>        case NETDEV_UNREGISTER:
>                if (bond_dev) {
>                        if (bond->setup_by_slave)
>                                bond_release_and_destroy(bond_dev,
>slave_dev);
>                        else
>                                bond_release(bond_dev, slave_dev);
>                }
>                break;

	I don't believe bond_dev will ever actually be NULL here,
because bond_netdev_event (the only caller of bond_slave_netdev_event)
checks that the device is, in fact, a bonding slave before the call.

	Just from looking at the code, I don't see any issues with
removing the "if (bond_dev)" test.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
