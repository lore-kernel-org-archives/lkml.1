Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYDXCKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYDXCKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYDXCKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:10:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39323 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDXCKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:10:44 -0400
Message-ID: <480FEC1B.6040102@garzik.org>
Date: Wed, 23 Apr 2008 22:10:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org> <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl>
In-Reply-To: <480F3ECC.1090809@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 23-04-08 02:16, Linus Torvalds wrote:
> 
>> On Wed, 23 Apr 2008, Adrian Bunk wrote:
>>> If it goes like the regs removal in one big patch around -rc1 into 
>>> your tree this shouldn't be a problem.
>>
>> Well, the regs removal had a real upside (it wasn't even sensible for 
>> all irq types), and really nobody used it apart from "system users" 
>> (ie Sysrq etc).
>>
>> I'm still waiting for anybody mentioning any upside at _all_ on 
>> removing "irq".
> 
> Saves another 4 bytes of stack? :-/ Seriously, Jeff can probably better 
> answer himself but when this was posted before:
> 
> http://lkml.org/lkml/2007/5/19/23
> 
> Eric Biederman said it fit nicely into his "nefarious plan of making 
> everything use a struct irq pointer". A later mention:
> 
> http://lkml.org/lkml/2007/10/19/66
> 
> got strong ACKs from Thomas Gleixner, Ingo Molnar and Greg KH. Remember 
> due to working on a local driver at the time and deleting the "irq" 
> argument usage from its handler (unneccesarily used in a debugging 
> printk) from it in response.

Thanks.  I was hoping that some of the people who expressed interest in 
prior threads would appear.

Answering Linus's question, the things I tend to think of are

* it's not used in overwhelming majority of cases

* irq number has morphed over time with MSI-X and APICs and such from a 
direct "reference" to a hardware line to a more abstract cookie value.

* the need for a struct [pci_]device everywhere means drivers have ready 
access to irq number _anyway_

* it has clearly led to many helpful cleanups and bug fixes, by both me 
and others [and yes, for the sake of argument I'm excluding those 
discussed in this thread]

* it helps clean up abuses like HPET where it is used to encode data 
(ignoring dev_id unnecessarily...  I posted a patch to fix this):

         if (rtc_int_flag) {
                 rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
                 if (irq_handler)
                         irq_handler(rtc_int_flag, dev_id);
         }

["irq_handler" is a function passed to request_irq, as well as being 
called here]

dev_id exists for passing various data to the irq_handler...  with some 
drivers abusing the 'irq' argument to pass data, that potential opens 
holes for bugs whenever the irq numbering (aka cookie) scheme is changed 
-- because changing the cookie scheme could potentially trigger code like

	if (irq == MAGIC_NUMBER)
		this is an internal self-call, do some polling
	else
		handle real hardware-raised interrupt

When drivers make assumptions about system irq numbering, particularly 
on x86, IMO the situation is fragile.

	Jeff



