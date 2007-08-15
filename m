Return-Path: <linux-kernel-owner+w=401wt.eu-S936968AbXHOXcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936968AbXHOXcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761783AbXHOXbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:31:53 -0400
Received: from outbound.mailhop.org ([63.208.196.171]:4411 "EHLO
	outbound.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbXHOXbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:31:52 -0400
X-Greylist: delayed 14946 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 19:31:52 EDT
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sLrz8eBz2HCF3jBg1E1/U
Message-ID: <46C35284.1080003@reed.com>
Date: Wed, 15 Aug 2007 15:22:44 -0400
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070719 Fedora/2.0.0.5-1.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RFC: do get_rtc_time() correctly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In trying to track down a bug related to hwclock hanging my x86_64 
machine, I found myself reading include/asm-generic/rtc.h carefully with 
a chipset spec for several RTC chips (in particular, the granddaddy, the 
MC146818A) in my hand.

I found that the code in get_rtc_time() is very, very odd, and IMO very 
wrong.

The idea in the comment at the top seems to suggest that the author 
thought that the UIP flag indicates an update is in progress at that 
very instant, so one needs to synchronize with the "falling edge" of 
that flag to ensure that one can read the RTC state without instability 
in its buffered value.   That is not the way the UIP flag is defined to 
work.  

The UIP flag is =1 during a period PRIOR to the actual update, starting 
224 usec before the update, and ending when the update is complete.   It 
is done that way (which might seem odd) so that if you read UIP=0, you 
have a 224 usec window, EVEN IF the UIP were to become =1 just after you 
read it.

So the proper way to read the RTC contents is to read the UIP flag, and 
if zero, read all the RTC registers with interrupts masked completely, 
so all reads happen in the 224 usec window.  (NMI can still be a 
problem, but you can have NMI's set a flag that forces a retry).

If the UIP flag is one, you need to try again.  Pseudo-code is as follows:

retry:
    spin_lock_irq(&rtc_lock);
    if (UIP_flag !=0 )  { spin_unlock_irq(&rtc_lock); cpu_relax(); goto 
retry; }
    ... read RTC registers ...
    spin_unlock_irq(&rtc_lock);

This should work for all RTC's compatible with the MC146818A, and is 
also somewhat faster and less masked than the code in the current Linux 
(not that reading RTC's is crucial for performance, but the current code 
occasionally *loops with all interrupts masked for 10 msec!*  Why anyone 
thought this necessary, I have no clue.)

I'm happy to code and test a patch.   Rather than just submit a patch, I 
thought I'd request others' comments on this, since it affects so many 
architectures.  cc me, if you will, as I don't subscribe to LKML, just 
check it periodically.

As noted in the comment, it *is* true that setting the RTC clock needs 
additional synchronization, which can be done in the drivers, as it 
seems to be.  (though I would use an API that is designed so that any 
delay during the set period actually adds to the value being stored, so 
that delaying during the set_rtc operation would not cause the value 
stored to be "old")

- David

PS: I wrote code for 8088 versions of various PC DOS apps back in the 
'80's, such as VisiCalc and Lotus 1-2-3, and hacked many timing-related 
drivers back in the day - so I know this chip spec cold, and figured out 
this odd stuff back then.  That's why the weirdness jumped out at me.  
I'm still an assembly language coder at heart.

