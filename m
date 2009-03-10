Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZCJAhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZCJAhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 20:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZCJAho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 20:37:44 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46109 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZCJAhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 20:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=uwO6vBaBBilKaRbV7wXyGhUh9MgV2nW++1VKsp5O0MnU/oZEehoIP/As20mO7/OQvD
         M8Mv+4VX/6b3SHuVXDrU9BdH894EgUdO1Uo++ssmS2DziYoquBl9AqF2xqHu+m8jvQXB
         V380vMAy3+gxIVD30izkrwGOmBdpRJQCvGrxk=
Message-ID: <49B5B64D.2000603@gmail.com>
Date: Mon, 09 Mar 2009 18:37:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Timur Tabi <timur@freescale.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, peterz@infradead.org, will.newton@gmail.com
Subject: Re: [PATCH v3] add function spin_event_timeout()
References: <1236630740-22024-1-git-send-email-timur@freescale.com> <49B57F45.7040104@gmail.com> <49B581FB.7060506@freescale.com>
In-Reply-To: <49B581FB.7060506@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Jiri Slaby wrote:
>> On 9.3.2009 21:32, Timur Tabi wrote:
>>> +#define spin_event_timeout(condition, timeout)				\
>>> +({									\
>>> +	int __timeout = timeout;					\
>>> +	while (!(condition)&&  --__timeout) {				\
>>> +		udelay(1);						\
>>> +		cpu_relax();						\
>> So you don't need cpu_relax anymore...
> 
> I checked the udelay() code.  It varies per platform, but I didn't see
> how it always replicated the functionality of cpu_relax().  For example,
> in x86_64, cpu_relax is a "rep; nop;".  But I don't see that code
> sequence in arch/x86/lib/delay.c.
> 
> So I presume that something in the delay functions makes cpu_relax()
> unnecessary.  What exactly is the purpose of cpu_relax()?

On platforms where it's possible and matters, it tells the CPU that the 
thread that's executing isn't very important and to give more resources 
to other threads (typically this is on a CPU with hyperthreading where 
it's supposed to make the other sibling get more of the execution 
resources). On x86, "rep nop" is the magic otherwise do-nothing 
instruction that does this.

I'd suspect that the delay functions should use it, except that it may 
skew the delay timing longer than specified. On a hyperthreaded CPU, 
that's kind of unavoidable, however, since we don't know what may be 
running on the sibling thread. Normally usages of the delay functions 
don't care that they may sleep a bit longer than specified, they mainly 
care about a minimum delay..

> 
>> And I would make timeout UL like delay functions.
> 
> I made it an integer because I don't expect anyone to pass a value
> larger than 2^31, but I'll change it.
> 

