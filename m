Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXDBOSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXDBOSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXDBOSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:18:08 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:61170 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXDBOSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:18:07 -0400
From: dasperry@comcast.net (dave_sperry@ieee.org)
To: Ingo Molnar <mingo@elte.hu>, Dave Sperry <dave_sperry@ieee.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Date: Mon, 02 Apr 2007 14:09:29 +0000
Message-Id: <040220071409.15202.46110E98000A743600003B622205886172979D9D0A9F9C0E0B@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: ZGFzcGVycnlAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all the input Ingo, Here's a list of all the permutations I've tried:

setup                    Thruput      CPU% from cyclesoak
2.6.21-rc5 vanilla       935          29%

2.6.21-rc5-rt5           711          50% //basically all of 1 cpu

2.6.21-rc5-rt8           733          52%

2.6.21-rc5-rt8           824          64%
   netperf @50        
   hardirq @50
   softirq @50

2.6.21-rc5-rt8           937          74%
   netperf @51
   hardirq @50
   softirq @50

2.6.21-rc5-rt8           106          8%
   netperf @51
   hardirq @49
   softirq @50

2.6.21-rc5-rt8           233          14%
   netperf @51
   hardirq @49
   softirq @48

2.6.21-rc5-rt8           67           5%
   netperf @batch
   hardirq @batch
   softirq @batch

2.6.21-rc5-rt8           331           OFF
   netperf @batch
   hardirq @batch
   softirq @batch
   cyclesoak off   


Any thoughts?

-Dave



 -------------- Original message ----------------------
From: Ingo Molnar <mingo@elte.hu>
> 
> * Dave Sperry <dave_sperry@ieee.org> wrote:
> 
> > I checked the clock source and in both the vanilla and rt cases and 
> > they were both acpi_pm
> 
> ok, thanks for double-checking that.
> 
> > Here's the oprofile for my vanilla case:
> 
> i tried your workload and i think i managed to optimize it some more: i 
> have uploaded the -rt8 kernel with these improvements included - could 
> you try it? Is there any measurable improvement relative to -rt5?
> 
> one more thing to improve netperf performance is to do this before 
> running it:
> 
>   chrt -f -p 50 $$
> 
> this will put netperf on the same priority level as the net hardirq and 
> the net softirq (which both default to SCHED_FIFO:50), and should result 
> in a (much) reduced context-switch rate.
> 
> Or, if networking is not latency-critical, then you could move the net 
> hardirq and softirq threads to SCHED_BATCH, and run netperf under 
> SCHED_BATCH as well, using:
> 
>   chrt -b -p 0 $$
> 
> and figuring out the active softirq hardirq thread PIDs and "chrt -b" 
> -ing them too.
> 
> 	Ingo

