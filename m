Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXHPA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXHPA12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbXHPA0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:26:45 -0400
Received: from outbound.mailhop.org ([63.208.196.171]:2627 "EHLO
	outbound.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbXHPA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:26:42 -0400
X-MHO-User: U2FsdGVkX19/r7cAi//OlH0iqFCNgp40
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ZdgGCBVRKtM/rMAcm6b3o
Message-ID: <46C399C1.9000502@reed.com>
Date: Wed, 15 Aug 2007 20:26:41 -0400
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070719 Fedora/2.0.0.5-1.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: do get_rtc_time() correctly
References: <46C35284.1080003@reed.com> <20070816005151.56176a04@the-village.bc.nu>
In-Reply-To: <20070816005151.56176a04@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan:

Thanks for the comment. I will code a patch, and include a sanity check 
as you suggested, and send it for review. Just to clarify one concern 
your note raised:

I understand that SMM/SMI servicing can take a long time, but SMM/SMI 
shouldn't  happen while interrupts are masked using local_irq_disable() 
[included in spin_lock_irq()], at least on x86-architectures.  If 
SMM/SMI can happen even then, the NMI fix below could be generalized.

My mention of NMI (which by definition can't be masked) is because NMI 
can happen even while interrupts are masked.  This is a timing problem 
that can't be dealt with by masking interrupts, and NMI's are used for 
watchdogs, etc these days.   It seems like just a general good thing to 
be able to ask if an NMI has happened.   A per-cpu NMI eventcount that 
is incremented every NMI would allow one to detect NMI's that happen 
during an otherwise masked code sequence by reading it at the beginning 
and end of the code sequence.   Don't know if NMIs are common on other 
architectures, or if this is an architecture dependent concern.

Perhaps I'm really talking about two patches here.  One for a mechanism 
to detect NMIs that happen during a critical piece of code (so it can be 
retried), and one that depends on that to be really proper in reading 
the RTC reliably.

Alan Cox wrote:
>> So the proper way to read the RTC contents is to read the UIP flag, and 
>> if zero, read all the RTC registers with interrupts masked completely, 
>> so all reads happen in the 224 usec window.  (NMI can still be a 
>> problem, but you can have NMI's set a flag that forces a retry).
>>     
>
> SMM/SMI is more likely to be what bumps you 224usec or more.
>
>   
>> I'm happy to code and test a patch.   Rather than just submit a patch, I 
>> thought I'd request others' comments on this, since it affects so many 
>> architectures.  cc me, if you will, as I don't subscribe to LKML, just 
>> check it periodically.
>>     
>
> Go for it. The other architectures generally inherit it by inheriting
> similar bridge chips or in more modern times the RTC macrocell. It should
> also be possible to debug by putting in an optional sanity check
> initially which checks the read made sense compared to a few more
>
>   
