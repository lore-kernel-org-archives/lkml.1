Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZCKSUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZCKSUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCKSUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:20:02 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:61468 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZCKSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:20:01 -0400
Message-ID: <49B80081.5060703@freescale.com>
Date: Wed, 11 Mar 2009 13:18:41 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
References: <1236699004-1863-1-git-send-email-timur@freescale.com>	<20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>	<1236729711.7086.28.camel@pasglop>	<20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>	<ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com> <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
In-Reply-To: <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Are you talking about the udelay() inside the loop?  If so, I agree
>> that this is bad and have removed it in the PowerPC-specific version:
> 
> The behaviour you want there is system specific - 10uS is a minimum
> politeness value for x86 PCI bus for example.

So we need to allow for delays between successive rights?  We can
provide that with a third parameter to the macro.

>> rdtsc instruction.  In this case, we're not adding arbitrary delays
>> into the loop, and we're not using jiffies, but we are
>> architecture-dependent.
> 
> and not useful

Is there an architecture-independent method for reading a timebase
register that's not jiffies?

> A macro of this form really needs to be able to look like
> 
> 	spin_until_timeout(readb(foo) & 0x80, 30 * HZ) {
> 		udelay(10);
> 		/* Maybe do other stuff */
> 	}
> 
> to be more generally useful

You mean something like this:

#define spin_until_timeout(condition, timeout) 		\
	for (unsigned long __timeout = jiffies + (timeout);	\
		(!(condition) && time_after(jiffies, __timeout)); )

How do I return a value indicating whether a timeout occurred or
condition came true?

-- 
Timur Tabi
Linux kernel developer at Freescale
