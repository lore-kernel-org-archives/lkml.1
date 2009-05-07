Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbZEGR5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbZEGR5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZEGR5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:57:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZEGR5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:57:14 -0400
Message-ID: <4A03209E.4070603@garzik.org>
Date: Thu, 07 May 2009 13:55:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>	<1241560625.8665.17.camel@alok-dev1>	<alpine.DEB.1.10.0905071010170.24528@qirst.com>	<20090507161440.5b9c067d@lxorguk.ukuu.org.uk>	<4A02FE91.8070006@zytor.com>	<4A031269.3000603@garzik.org> <20090507180909.4b0a8672@lxorguk.ukuu.org.uk>
In-Reply-To: <20090507180909.4b0a8672@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 07 May 2009 12:55:05 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> H. Peter Anvin wrote:
>>> Alan Cox wrote:
>>>> Hooray - finally someone admits the *real* problem here, and for power
>>>> management too. Otherwise known as "referencing jiffies as a variable must
>>>> die"
>>> Amen.  Also, "using HZ as a unit of measurement must die, too."
>> Love to -- now, what will it be replaced with?
>>
>> grep for 'deadline' in drivers/ata/libata* to find an example not so 
>> easily converted away from jiffies.
> 
> I don't see any.
> 
> I do see a complicated interface that appears to actually really want to
> implement
> 
> 		add_timer(&foo->expiry_timer);
> 
> and checks against the timer completing. In fact it looks as if all the
> stuff in there is really down to
> 
> 		add a timer
> 		check if it expired
> 		check how long until it expires
> 		delete it

This is why I mentioned this example... because it's not as easy as you 
seem to think it is :)

We care only about a decreasing time interval.  This interval is passed 
to register polling functions (bitbang no longer than <this> amount of 
time), as well as _cumulatively_ affecting the entire EH [sub-]process.

A timer-based solution, in addition to being an ugly hack, would imply 
replacing a simple variable with _at least_ two spinlocks, plus a timer 
callback function that simply says "I expired".  With loops such as

	max_msecs = calc_deadline(overall_deadline, ...)
	while (!(register & bit))
		msleep(1)
		max_msecs--
		register = readl(...)

must be converted to the more-complex timer-based solution.		

libata would be happy to use milliseconds rather than jiffies; the unit 
does not matter.  What matters is calculating our progress versus the 
clock tick, as spread across multiple functions, multiple contexts, and 
register polling loops.

The current code is a -lot- more simple than checking "is timer 
expired?" all over the code, given that any sort of timer-based function 
implies dealing with additional concurrency issues -- a complication the 
libata EH does not need.

	Jeff



