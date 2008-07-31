Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYGaUAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYGaUAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYGaUAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:00:00 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:45889 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750938AbYGaT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:59:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=evPVd++3KUS6l8FVWPcQpZVqRIy+j5T8VGWtBqF9i+ceDREC2u3xSDkJ26c/IE5y7NfAj4pGVlAdEIotlN46km4IPV+jPhGAo/JDdBcpnzyg0XBbnrT9EBIFKvb6CFHrl1Fu8aCe1PwLeatlElMXcBG5Rwhm9L49j27zfOczFfI=  ;
X-YMail-OSG: pk.atTMVM1nZrNk3tcraNtHk1vkHSF4ANUb6ULzWjt_X0fyx.lemMWE2Nc1vwakHOaEVxqm0YYxooiv9Bi2Ruk8MuoPQa6m0OioShjQARPg0gyKf01U1Ze2hshxudmsL5zbqnddteL55hYtADcX5u6LQeEPGtXWR3w--
X-Yahoo-Newman-Property: ymail-5
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2.6.27-rc1] /dev/hpet - fixes and cleanup
Date: Thu, 31 Jul 2008 12:59:56 -0700
User-Agent: KMail/1.9.9
Cc: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>,
       bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <20080731164658.GG26393@elte.hu> <20080731165519.GA8631@elte.hu>
In-Reply-To: <20080731165519.GA8631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807311259.56870.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Ingo Molnar wrote:
>   drivers/built-in.o: In function `hpet_alloc':
>   : undefined reference to `__udivdi3'
>   drivers/built-in.o: In function `hpet_alloc':
>   : undefined reference to `__umoddi3'

Verified on 64 and 32 bit builds.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/char/hpet.c	2008-07-31 11:22:07.000000000 -0700
+++ b/drivers/char/hpet.c	2008-07-31 11:21:15.000000000 -0700
@@ -701,6 +701,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	static struct hpets *last = NULL;
 	unsigned long period;
 	unsigned long long temp;
+	u32 remainder;
 
 	/*
 	 * hpet_alloc can be called by platform dependent code.
@@ -764,12 +765,13 @@ int hpet_alloc(struct hpet_data *hdp)
 		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
 	printk("\n");
 
+	temp = hpetp->hp_tick_freq;
+	remainder = do_div(temp, 1000000);
 	printk(KERN_INFO
 		"hpet%u: %u comparators, %d-bit %u.%06u MHz counter\n",
 		hpetp->hp_which, hpetp->hp_ntimer,
 		cap & HPET_COUNTER_SIZE_MASK ? 64 : 32,
-		(unsigned) (hpetp->hp_tick_freq / 1000000),
-		(unsigned) (hpetp->hp_tick_freq % 1000000));
+		(unsigned) temp, remainder);
 
 	mcfg = readq(&hpet->hpet_config);
 	if ((mcfg & HPET_ENABLE_CNF_MASK) == 0) {

