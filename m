Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbXGSPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbXGSPrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGSPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:47:06 -0400
Received: from web56604.mail.re3.yahoo.com ([66.196.97.48]:31774 "HELO
	web56604.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759991AbXGSPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:47:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=z2raBXJVKY6Kob2yTRZDhEaqavPkBAWp3f1BTjnm/R5uh+Tb3FpCF7AsQWhyjyBeJm5uJtO86iwhTV94Dmt2z8dVdATF0XYNhor/HGzA1QvjRBXT8ozNolnHdJVl6af4f4JWfxuQ88hX42a5I6ACAwOYxE6sdCCB76hBhFWPBOI=;
X-YMail-OSG: 6kI8t9wVM1mllcTkwOzoxvM4YSZ3jWvOGRrcr4Wty3K0IbyG5vW7kJmEoliXM5O6mMfKNx2BUwGBrh74vFBMnzh.mP8wkmXP11kVwNJnamfz4ti12umKdI00PU_bzV_B5RgCgEcMzR.8IKNM4iijouBFQg--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Thu, 19 Jul 2007 08:47:01 -0700 (PDT)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Re: Linux, tcpdump and vlan
To: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <123837.78916.qm@web56604.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The consensus seems to be that skb's need to carry vlan accelerated tags in their cb's, on rx as well as tx. VLAN_TX_SKB_CB() is perfect for that.

> [Patrick] On the TX path, it could simply use the CB, but this is actually
also wrong (for both macvlan and real devices) since qdiscs have
ownership of the skb in between, and at least netem *does* modify
the CB, breaking VLAN.

Thanks for pointing that out... It appears to me that qdisc/netem already breaks the vlan implementation, in the path 

vlan_dev_hwaccel_hard_start_xmit(): sets accelerated vlan tag in skb->cb, calls
dev_queue_xmit(): may pass skb to qdisc/netem, which may mangle skb->cb before calling
dev->hard_start_xmit(), resulting in a tx frame without its vlan tag.

So netem needs to look for hw accelerated vlan metadata and insert it in the skb... Don't see any other way around this. 

> [Patrick] Your suggestion of disabling VLAN acceleration in promiscuous
mode sounds like a reasonable solution until then ..

I was rather thinking of keeping hw vlan acceleration in promiscuous mode. Upon becoming promisc, the driver will be changed to disable vlan filters - it will reenable them when leaving promisc mode.

My 2 cents on vlan hw acceleration: it does not save much in computing cycles, if software is written carefully. It is vlan filtering that saves computing time.

> [Ben] I think a better method would be to allow disabling VLAN HW accel for a NIC with ethtool.

This requires changes to ethtool and e1000 driver, +other drivers. It is a handy thing to have. I don't view it as a solution to tcpdump - or to the vlan bridging problem. One concern: if we're switching hw accel mode on the fly, we need to carefully protect tx frames that are just about going out and have already been set up for the opposite mode.

Any comments on what is the expected behavior of 'tcpdump -i eth0.2' vs. 'tcpdump -i eth0'?

Andrei Radulescu-Banu
Brix Networks





       
____________________________________________________________________________________
Need a vacation? Get great deals
to amazing places on Yahoo! Travel.
http://travel.yahoo.com/
