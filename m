Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbXKOUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbXKOUb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759756AbXKOUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:31:52 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:57545 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbXKOUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:31:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.199
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18okExE63BM47JMU0bj45mM
Message-ID: <473CACA9.2090702@reed.com>
Date: Thu, 15 Nov 2007 15:31:37 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Allessandro Zummo <a.zummo@towertech.it>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] x86: on x86_64, correct reading of PC RTC when update
 in progress in time_64.c
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <473B9D8A.5000006@reed.com> <alpine.LFD.0.9999.0711152021270.3112@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711152021270.3112@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of things I don't understand on this one.  And I 
presume you thought the other two bug fixing patches I sent before this 
were OK to go, since on my system

Thomas Gleixner wrote:

> Still whitespace wreckage in your patches. I guess the kernel tree you
> made your patches against is already white space wrecked.
>
> I fixed that up manually, but please be more careful about that next
> time.

Um ... I fixed the whitespaces I detected from the first round with 
checkpatch.pl.  Then for good measure
I ran checkpatch.pl on the patches, then pasted the files directly into 
the emails.  No problems detected.
And I also just tried checkpatch.pl on the "sent" folder copy.  No 
problems detected there.
Where was the whitespace?  Was it in the patches? Would you mind showing 
me the output so I can do a better job in the future?
>   
>> Correct potentially unstable PC RTC time register reading in time_64.c
>>
>> Stop the use of an incorrect technique for reading the standard PC RTC
>> timer, which is documented to "disconnect" time registers from the bus
>> while updates are in progress.  The use of UIP flag while interrupts
>> are disabled to protect a 244 microsecond window is one of the
>> Motorola spec sheet's documented ways to read the RTC time registers
>> reliably.
>>
>> The patch updates the misleading comments and also minimizes the amount of
>> time that the kernel disables interrupts during the reading.
>>     
>
> While I think that the UIP change is correct and a must have, the
> locking change is not really useful. read_persistent_clock is called
> from exactly three places:
>   
What locking change?  I didn't change how locking works in 
read_persistent_clock at all.
I did introduce cpu_relax() because if anyone else ever calls from a hot 
path, that would be good practice and its' one line.
> Right after boot, right before suspend and right after resume. None of
> those places is a hot path, where we really care about the interrupt
> enable/disable. IIRC, this is even called with interrupts disabled
> most of the time, so no real gain here.
>
> Another reason not to do the locking change is the paravirt stuff
> which is coming for 64bit. I looked into the existing 32bit code and
> doing the same lock thing would introduce a real nasty hackery, which
> is definitely not worth the trouble.
>   
I presume time_64.c and time_32.c will be unified at some point, 
discarding time_64.c.  There's no arch-specific reason to be separate.  
The current time_32.c depends on a different nmi path (that does some 
weird stuff saving and restoring the CMOS index register!), and I didn't 
dare usurp your long-term plan to unify architectures.  But a simple 
cleanup here makes sense, lest someone copy the bad technique as if it 
were good.
> Thanks,
>
> 	tglx
>
>   
>> Signed-off-by: David P. Reed <dpreed@reed.com>
>> ---
>> Index: linux-2.6/arch/x86/kernel/time_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/time_64.c
>> +++ linux-2.6/arch/x86/kernel/time_64.c
>> @@ -160,22 +160,30 @@ unsigned long read_persistent_clock(void
>>  	unsigned long flags;
>>  	unsigned century = 0;
>>
>> -	spin_lock_irqsave(&rtc_lock, flags);
>> + retry:	spin_lock_irqsave(&rtc_lock, flags);
>> +	/* if UIP is clear, then we have >= 244 microseconds before RTC
>> +	 * registers will be updated.  Spec sheet says that this is the
>> +	 * reliable way to read RTC - registers invalid (off bus) during
>> update
>> +	 */
>> +	if ((CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP)) {
>> +	  spin_unlock_irqrestore(&rtc_lock, flags);
>> +	  cpu_relax();
>> +	  goto retry;
>> +	}
>>
>> -	do {
>> -		sec = CMOS_READ(RTC_SECONDS);
>> -		min = CMOS_READ(RTC_MINUTES);
>> -		hour = CMOS_READ(RTC_HOURS);
>> -		day = CMOS_READ(RTC_DAY_OF_MONTH);
>> -		mon = CMOS_READ(RTC_MONTH);
>> -		year = CMOS_READ(RTC_YEAR);
>> +	/* now read all RTC registers while stable with interrupts disabled */
>> +
>> +	sec = CMOS_READ(RTC_SECONDS);
>> +	min = CMOS_READ(RTC_MINUTES);
>> +	hour = CMOS_READ(RTC_HOURS);
>> +	day = CMOS_READ(RTC_DAY_OF_MONTH);
>> +	mon = CMOS_READ(RTC_MONTH);
>> +	year = CMOS_READ(RTC_YEAR);
>>  #ifdef CONFIG_ACPI
>> -		if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
>> -					acpi_gbl_FADT.century)
>> -			century = CMOS_READ(acpi_gbl_FADT.century);
>> +	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
>> +				acpi_gbl_FADT.century)
>> +		century = CMOS_READ(acpi_gbl_FADT.century);
>>  #endif
>> -	} while (sec != CMOS_READ(RTC_SECONDS));
>> -
>>  	spin_unlock_irqrestore(&rtc_lock, flags);
>>
>>  	/*
>>
>>
>>     
>
>   
