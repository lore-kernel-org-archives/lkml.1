Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYA0MmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYA0MmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbYA0Mlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:41:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995AbYA0Mlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:41:32 -0500
Date: Sun, 27 Jan 2008 13:41:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: X fails to start with latest Linus git
Message-ID: <20080127124120.GA23377@elte.hu>
References: <479BCE03.6070603@gmail.com> <479BD1D1.8020503@gmail.com> <20080127062703.GA23444@elte.hu> <20080127083129.c14452ca.kjwinchester@gmail.com> <20080127123702.GB21282@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127123702.GB21282@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> it seems you've got hpet active by default:
> 
>  /sys/devices/system/clocksource/clocksource0/current_clocksource:
>  hpet
>  /sys/devices/system/clocksource/clocksource0/available_clocksource:
>  hpet acpi_pm pit jiffies tsc

btw., it's quite mysterious how this can lock up. ktime_get() on a hpet 
clocksource does a very straightforward:

 static cycle_t read_hpet(void)
 {
         return (cycle_t)hpet_readl(HPET_COUNTER);
 }

which is a very simple thing:

c0119470 <hpet_readl>:
c0119470:       8b 15 b8 b4 ae c0       mov    0xc0aeb4b8,%edx
c0119476:       55                      push   %ebp
c0119477:       89 e5                   mov    %esp,%ebp
c0119479:       5d                      pop    %ebp
c011947a:       01 d0                   add    %edx,%eax
c011947c:       8b 00                   mov    (%eax),%eax
c011947e:       c3                      ret

basically just a memory access to an ioremap()-ed area.

hm, perhaps it's due to the xtime lock dependency:

        do {
                seq = read_seqbegin(&xtime_lock);
                getnstimeofday(ts);
                tomono = wall_to_monotonic;

        } while (read_seqretry(&xtime_lock, seq));

perhaps your system somehow generates a printk from within an xtime_lock 
locked section?

	Ingo
