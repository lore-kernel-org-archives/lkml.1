Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZCLQWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZCLQWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZCLQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:21:56 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:39774 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbZCLQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:21:54 -0400
Message-ID: <49B93658.8050505@nortel.com>
Date: Thu, 12 Mar 2009 10:20:40 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: reason for delay in arch/x86/kernel/traps.c::io_check_error()?
References: <49B56F18.1050904@nortel.com> <20090310153242.GA23463@elte.hu>
In-Reply-To: <20090310153242.GA23463@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2009 16:20:42.0099 (UTC) FILETIME=[7D318430:01C9A32E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:
> 
>> Hi all,
>>
>> I was just wondering about the basis for the delay in 
>> io_check_error().  The ICH7 manual doesn't have any mention of 
>> a delay being required here--is it necessary for other 
>> hardware, something not mentioned in the manual, or just an 
>> accident?
> 
> That code has seriously bitrotten along the years. All those 
> port 61H accesses:
> 
> arch/x86/kernel/traps.c:                reason = get_nmi_reason();
> arch/x86/kernel/traps.c:        outb(reason, 0x61);
> arch/x86/kernel/traps.c:        outb(reason, 0x61);
> arch/x86/kernel/traps.c:        outb(reason, 0x61);
> 
> ... are often wrong on modern chipsets - including the logic in 
> io_check_error(). But we dont really have lowlevel chipset 
> drivers on this level in Linux, so there's nothing suitable to 
> replace it with and it never got fixed.
> 
> Can you see this trigger on a box perhaps? Or are you worried 
> about the potential unbound execution time of this function 
> which can be up to 2 seconds in NMI context?

This is in the context of an embedded highly available compute blade. 
As part of our enhanced error handling we've modified the memory parity 
error code to reenable rather than disable the error line.

Given that the memory and IO code paths are just different bits in the 
same register we originally added the delay to the memory parity path as 
well.  However, we subsequently hit the memory parity error path, and 
the 2sec delay triggered our hardware watchdog causing the board to reboot.

As you can imagine this is undesirable, so we were hoping to remove the 
delay from both paths.  From what you've said and the fact that no delay 
is mentioned in the chip manual, it seems like this should be fairly safe.

Thanks,
Chris
