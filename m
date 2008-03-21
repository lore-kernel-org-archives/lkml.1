Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYCUJXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYCUJXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYCUJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:23:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51709 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYCUJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:23:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E37E04.3080303@s5r6.in-berlin.de>
Date: Fri, 21 Mar 2008 10:21:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
References: <20080316184349.GA28543@khazad-dum.debian.net>	<200803161246.23909.david-b@pacbell.net>	<20080318001429.896acf51.akpm@linux-foundation.org>	<20080320225612.GB20788@khazad-dum.debian.net>	<20080320164741.734e838c.akpm@linux-foundation.org>	<20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org>
In-Reply-To: <20080320180802.426ad2d1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ./drivers/ieee1394/ieee1394_transactions.c
> 
>   Possibly buggy: deadlockable

That's in hpsb_get_tlabel(), an exported symbol of the ieee1394 core.

The in_atomic() there didn't cause problems yet and is unlikely to do so 
in the future, because there are no plans for substantial changes to the 
whole drivers/ieee1394/ anymore (because of drivers/firewire/).

Nevertheless I shall look into replacing the in_atomic() by in_softirq() 
or something like that.  Touching this legacy code is dangerous though.


Some background:

This in_atomic() is just one symptom of one of the fundamental design 
flaws of the ieee1394 stack:  The "tlabels" (transaction labels, a 
limited resource) are acquired not only in process context but also in 
soft IRQ context --- but they are released only in process context. 
Unsurprisingly (in hindsight), the stack used to run out of tlabels 
simply because the tlabel consumers were scheduled more frequently than 
the tlabel recycler.  This resulted in IO failures in sbp2 and eth1394.

This is one of the design problems which inspired the submission of a 
new alternative driver stack.  (Though this particular one of the 
ieee1394 stack's problems could of course also be solved by a rework of 
the stack --- with a respective need of resources for testing and some 
danger of regressions.)

In the meantime (Linux 2.6.19 and 2.6.22) I added workarounds in sbp2 
and eth1394 to deal with temporary lack of of tlabels.  Alas I just 
recently received a report that eth1394's workaround is unsuccessful on 
non-preemptible uniprocessor kernels.  I suspect the same issue exists 
with sbp2's workaround, it just isn't as likely to happen there.

The new drivers/firewire/ recycle tlabels in bottom halves context and 
in timer context, which is the appropriate approach.  Alas 
drivers/firewire/ don't have an eth1394 equivalent yet...
-- 
Stefan Richter
-=====-==--- --== =-=-=
http://arcgraph.de/sr/
