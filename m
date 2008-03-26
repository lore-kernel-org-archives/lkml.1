Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbYCZRaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbYCZRaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYCZR34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:29:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbYCZR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:29:54 -0400
Date: Wed, 26 Mar 2008 10:29:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcus Better <marcus@better.se>
Cc: stefanr@s5r6.in-berlin.de, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10327] New: keyboard stops responding after
 "ifdown eth0"
Message-Id: <20080326102931.484285f3.akpm@linux-foundation.org>
In-Reply-To: <47EA152C.6000008@better.se>
References: <bug-10327-10286@http.bugzilla.kernel.org/>
	<20080325143941.300d415f.akpm@linux-foundation.org>
	<47E9721C.2000306@better.se>
	<47E99258.3060005@s5r6.in-berlin.de>
	<20080325171608.509f4ca7.akpm@linux-foundation.org>
	<47EA152C.6000008@better.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 10:19:40 +0100
Marcus Better <marcus@better.se> wrote:

> Andrew Morton wrote:
> > 	( sleep 10 ; echo t > /proc/sysrq-trigger ) &
> > 	ifdown eth0
> > 
> > 
> > - See if the sysrq-t output made it to /var/log/messages
> 
> No, not a word. It hung after printing this:
> 
> ...
> DHCPRELEASE ...
> send_packet: Network is unreachable
> send_packet: please consult README ...
> sky2 eth0: disabling interface
> ~# sky2 eth0: enabling interface
> 
> I'm running ifplugd, but this time there was no network cable connected. 
> Also ran from virtual console this time, the keyboard locked up like before.
> 
> SysRq keys work, so I could do sysrq-s, sysrq-b. Also pressed sysrq-t 
> before rebooting.

It certainy does sound like networking has gummed up the keventd queue(s).

> Any use trying netconsole? Can I run it over the wireless interface?

I don't think many (or any?) wireless drivers support netconsole.

I'd suggest running (and perhaps suitably modifying) this:

diff -puN drivers/net/sky2.c~a drivers/net/sky2.c
--- a/drivers/net/sky2.c~a
+++ a/drivers/net/sky2.c
@@ -50,6 +50,8 @@
 
 #include "sky2.h"
 
+#define D() printk("%s:%d\n", __FILE__, __LINE__)
+
 #define DRV_NAME		"sky2"
 #define DRV_VERSION		"1.21"
 #define PFX			DRV_NAME " "
@@ -2931,32 +2933,42 @@ static void sky2_restart(struct work_str
 	struct net_device *dev;
 	int i, err;
 
+	D();
 	rtnl_lock();
+	D();
 	for (i = 0; i < hw->ports; i++) {
+		D();
 		dev = hw->dev[i];
 		if (netif_running(dev))
 			sky2_down(dev);
 	}
-
+	D();
 	napi_disable(&hw->napi);
+	D();
 	sky2_write32(hw, B0_IMSK, 0);
 	sky2_reset(hw);
 	sky2_write32(hw, B0_IMSK, Y2_IS_BASE);
 	napi_enable(&hw->napi);
-
+	D();
 	for (i = 0; i < hw->ports; i++) {
+		D();
 		dev = hw->dev[i];
 		if (netif_running(dev)) {
+			D();
 			err = sky2_up(dev);
+			D();
 			if (err) {
+				D();
 				printk(KERN_INFO PFX "%s: could not restart %d\n",
 				       dev->name, err);
 				dev_close(dev);
+			D();
 			}
 		}
 	}
-
+	D();
 	rtnl_unlock();
+	D();
 }
 
 static inline u8 sky2_wol_supported(const struct sky2_hw *hw)
_

to see if things are getting stuck and if so, where.
