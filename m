Return-Path: <linux-kernel-owner+w=401wt.eu-S1767276AbXECAIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767276AbXECAIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767277AbXECAIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:08:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42095 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767276AbXECAIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:08:12 -0400
Message-ID: <46392756.2030309@vmware.com>
Date: Wed, 02 May 2007 17:05:42 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Marcos Pinto <markybob@gmail.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: Mysterious RTC hangs on x86_64 - fixed, sort of
References: <46391253.30201@vmware.com> <46391716.9040001@redhat.com>
In-Reply-To: <46391716.9040001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

Well, turns out this is a heisenbug.  Which is good, since it means the 
nop patch didn't change anything.

> Try leaving the spinlocks and just disabling the callbacks. And maybe
> enable spinlock debugging...
>   

I tried removing all the spinlocks inside the interrupt handler.  Seemed 
to work fine for a while, but still hung (at worst, it looks missing 
locks means we might screw up and read / write the wrong CMOS register, 
not hang or crash).

So I took down 2nd CPU with hotplug (did not yet try UP kernel though).  
It took a longer time, but still hung.  Seems not to be a spinlock 
problem, but I'll turn on debugging anyway.

>   
>> CONFIG_HPET_EMULATE_RTC=y
>>     
>
> Did you try without that?
>   

Will do.  That looks much more suspicious like.  I thought I killed it 
already, but had only got this:

# CONFIG_HPET_RTC_IRQ is not set

If that still crashes, I'll try running cmos access in a loop in userspace to see if maybe the port I/O is tickling a chipset bug (the only other report I know of is on same chipset, nVidia MCP51).  Maybe SMM handler is accessing CMOS or something wacked out.  <laughs hysterical... stops laughing when the theory actually sounds plausible>.  Stuck in SMM is not good for CPU thermal throttling ... hopefully Turion's don't reach nuclear emission point.

Would also explain maybe why NMI watchdog doesn't seem to notice anything wrong.


Thanks,
Zach
