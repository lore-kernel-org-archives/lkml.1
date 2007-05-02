Return-Path: <linux-kernel-owner+w=401wt.eu-S1766904AbXEBUFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766904AbXEBUFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766898AbXEBUFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:05:53 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:9876 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766904AbXEBUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:05:51 -0400
Message-ID: <4638EF0B.9050701@interia.pl>
Date: Wed, 02 May 2007 22:05:31 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Tim Hockin <thockin@hockin.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <20070501084639.GA528@sirena.org.uk>	 <20070501180830.GA31630@sirena.org.uk> <46379A7E.3000109@interia.pl>	 <20070501212750.GC31630@sirena.org.uk>	 <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>	 <46382798.2090709@interia.pl>	 <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com>	 <463830E1.8080107@interia.pl>	 <b3ece790705012351g5c0ff8a6g9f2f350ff86f3319@mail.gmail.com>	 <20070502082211.GD31630@sirena.org.uk> <b3ece790705020744p2e73bb5fo2c0acad947a5de15@mail.gmail.com>
In-Reply-To: <b3ece790705020744p2e73bb5fo2c0acad947a5de15@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-EMID: 1fb86acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > I'm not sure what the right answer is.  The code was designed to do
>> > the right thing, and yet in your case it's broken.  Does it need to be
>> > a build option to work around broken hardware?  Yuck.
>>
>> Without a system that really needs the original problem that was being
>> worked around it's going to be hard to see if the workaround still does
>> the job.  Given the nature of the failure I wouldn't be surprised if it
>> broke different things on every board that has problems.
> 
> I'm sure if you were to revert that code today, you'd find people who
> had problems :)
> 
>> How about a sysfs tuneable?  It's not nice but at least it's runtime.
> 
> Fine by me - but I have very little time to do the work.
What about module option?

---
 drivers/net/natsemi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 349b96a..933e106 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -90,6 +90,10 @@ static int rx_copybreak;
 static int options[MAX_UNITS];
 static int full_duplex[MAX_UNITS];
 
+/* Used to disable "is PHY alive" check for compatibility with broken
+ * designs using rev. C chips. */
+static int disable_phy_check;
+
 /* Operational parameters that are set at compile time. */
 
 /* Keep the ring sizes a power of two for compile efficiency.
@@ -141,6 +145,7 @@ module_param(debug, int, 0);
 module_param(rx_copybreak, int, 0);
 module_param_array(options, int, NULL, 0);
 module_param_array(full_duplex, int, NULL, 0);
+module_param(disable_phy_check, int, 0);
 MODULE_PARM_DESC(mtu, "DP8381x MTU (all boards)");
 MODULE_PARM_DESC(debug, "DP8381x default debug level");
 MODULE_PARM_DESC(rx_copybreak,
@@ -148,6 +153,8 @@ MODULE_PARM_DESC(rx_copybreak,
 MODULE_PARM_DESC(options,
 	"DP8381x: Bits 0-3: media type, bit 17: full duplex");
 MODULE_PARM_DESC(full_duplex, "DP8381x full duplex setting(s) (1)");
+MODULE_PARM_DESC(disable_phy_check, "DP8381[56]: PHY lockup check disable"
+	" (all boards)");
 
 /*
 				Theory of Operation
@@ -1753,7 +1760,7 @@ static void netdev_timer(unsigned long data)
 		writew(1, ioaddr+PGSEL);
 		dspcfg = readw(ioaddr+DSPCFG);
 		writew(0, ioaddr+PGSEL);
-		if (dspcfg != np->dspcfg) {
+		if (!disable_phy_check && dspcfg != np->dspcfg) {
 			if (!netif_queue_stopped(dev)) {
 				spin_unlock_irq(&np->lock);
 				if (netif_msg_hw(np))
-- 
1.5.0.6

 


----------------------------------------------------------------------
Zrob numer kumplom >> http://link.interia.pl/f1a5d

