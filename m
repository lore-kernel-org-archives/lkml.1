Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZJLKNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZJLKNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZJLKN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:13:29 -0400
Received: from [193.210.47.2] ([193.210.47.2]:23069 "EHLO gw.exertus.fi"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZJLKN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:13:27 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 06:13:27 EDT
Message-ID: <4AD2FFF5.4050809@gmail.com>
Date: Mon, 12 Oct 2009 13:07:49 +0300
From: tike64@gmail.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: smc91x and ifplugd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2009 10:07:49.0893 (UTC) FILETIME=[DAB84B50:01CA4B23]
X-CT-RefID: str=0001.0A0B0209.4AD2FFF6.0025,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear linux-kernel,

I am configuring 2.6.27 kernel for a custom board with a LAN91C111 ethernet 
interface. I tried to manage the interface with ifplugd but encountered a 
problem: ifplugd works fine through the first event pair, one up event and then 
one down event but after that the interface is dead. In the driver the carrier 
presence knowledge is updated in the interrupt handler and, when the interface 
is brought down, no one updates the fact that the carrier is again present.

I implemented a driver specific 'get_link' method and commented out
smc_phy_powerdown call from smc_close. Now it seems to work for me but I'm far 
too uneducated to judge if this is a correct way to solve the problem or if 
there is going to be ill effects.

Right away I can say that I'm not comfortable with not powering down the PHY on 
interface down. Secondly this seems not to solve the problem if there is an 
external PHY, right?

So, what might be the correct solution which would have a chance to be included 
into the mainline?

My get_link implementation:

static u32 smc_get_link(struct net_device *dev)
{
	struct smc_local *lp = netdev_priv(dev);
	void __iomem *ioaddr = lp->base;
	u32 carrier;
	static u32 old = -1;

	spin_lock_irq(&lp->lock);
	SMC_SELECT_BANK(lp, 0);
	carrier = mii_link_ok(&lp->mii);
	SMC_SELECT_BANK(lp, 2);
	spin_unlock_irq(&lp->lock);
	if (old != carrier) {
		old = carrier;
		printk("smc_get_link carrier: %i\n", carrier); }
	return carrier;
}

--

Timo

