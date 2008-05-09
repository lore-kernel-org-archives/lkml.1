Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbYEINBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbYEINBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYEINBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:01:12 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:24638 "HELO
	web32616.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750951AbYEINBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:01:11 -0400
X-YMail-OSG: iME2rVwVM1n3Nv3ZqaAs6gk7kgc9EbFQhQc_fwfeMAIuRglMCQGn3VhBrMs7SWcHoyUS_OitgcivRn7tX5EobpaXIk3k4LMeJKqzjZygyChUPuXkc56N02tBHCBbviWCr4vj_vaFEJF..1bFJV2Ob7Ed2MXx5dbia91mMds-
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 9 May 2008 06:01:10 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <264564.71707.qm@web32601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Thomas Gleixner <tglx@linutronix.de>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Gabriel C <nix.or.die@googlemail.com>; Bart Van Assche <bart.vanassche@gmail.com>; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Thursday, May 8, 2008 4:13:55 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> On Thu, 8 May 2008, Martin Knoblauch wrote:
> > on two different systems running 2.6.25.2:
> > 
> > ibm x3650(2xDualCore)
> > -------------------------------------
> > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm60 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > HP Proliant DL-380G4 (2xSingleCore)
> > ------------------------------------------------------------
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > and on the DL380G4 running 2.6.24:
> > ---------------------------------------------------------
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> > hpet acpi_pm jiffies tsc
> > [root@lpsdm52 ~]# cat 
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> > hpet
> 
> So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
> thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) ?
> 
> Thanks,
>     tglx

 hah. I love open source :-)

 Between 2.6.24 and 2.6.25 there was some patching in "kernel/printk.c". Especially this is interesting:


@@ -680,7 +742,7 @@
                                        loglev_char = default_message_loglevel
                                                + '0';
                                }
-                               t = printk_clock();
+                               t = cpu_clock(printk_cpu);
                                nanosec_rem = do_div(t, 1000000000);
                                tlen = sprintf(tbuf,
                                                "<%c>[%5lu.%06lu] ",


 Where "prink_clock()" basically translates into "sched_clock()" in 2.6.24. If I change the 2.6.25 version to directly call "sched_clock()", the timestamps are back to the expected values and are no longer jumping back and forth. So, something in "cpu_clock()" is fishy.

Cheers
Martin

