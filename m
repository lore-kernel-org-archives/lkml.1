Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbYEOUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbYEOUfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYEOUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:35:21 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:43005 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYEOUfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:35:20 -0400
Message-ID: <482C9E73.2040202@free.fr>
Date: Thu, 15 May 2008 22:34:59 +0200
From: Nicolas 2P <nicolas.2p.debian@free.fr>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch]  bondig - arp_interval with low value => Oops.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting arp_interval parameter to a very low value, delta_in_ticks 
for next arp might become 0, causing an infinite loop.

See http://bugzilla.kernel.org/show_bug.cgi?id=10680

Same problem for miimon parameter already fixed, but fix might be 
enhanced, by using msecs_to_jiffies() function.

Signed-off-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>

--- /usr/src/linux/drivers/net/bonding/bond_main_orig.c 2008-05-13 
02:00:01.000000000 +0200
+++ /usr/src/linux/drivers/net/bonding/bond_main.c      2008-05-14 
14:55:53.000000000 +0200
@@ -2391,7 +2391,7 @@
                 read_lock(&bond->lock);
         }

-       delay = ((bond->params.miimon * HZ) / 1000) ? : 1;
+       delay = msecs_to_jiffies(bond->params.miimon);
         read_unlock(&bond->lock);
         queue_delayed_work(bond->wq, &bond->mii_work, delay);
  }
@@ -2704,7 +2704,7 @@

         read_lock(&bond->lock);

-       delta_in_ticks = (bond->params.arp_interval * HZ) / 1000;
+       delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval);

         if (bond->kill_timers) {
                 goto out;
@@ -2837,7 +2837,7 @@

         read_lock(&bond->lock);

-       delta_in_ticks = (bond->params.arp_interval * HZ) / 1000;
+       delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval * HZ);

         if (bond->kill_timers) {
                 goto out;
