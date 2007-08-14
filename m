Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbXHNVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbXHNVO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXHNVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:14:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65130 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbXHNVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:14:49 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 17:14:49 EDT
In-Reply-To: <p73r6m5n90l.fsf@bingen.suse.de>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu>
Cc: cra@WPI.EDU, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Tue, 14 Aug 2007 16:52:54 -0400
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The corruption originally looked like a race condition.

Sometimes the EDID buffer would be all zeros.
Sometimes it would contain partial data, and then the rest of the  
buffer filled with zeros.
The amount of data transferred into the buffer before going to all  
zeros is non-deterministic.

When we put a known value in each byte of the buffer before making  
the vm86 call, the known data would always be overwritten either with  
EDID data or zeros.

-Bill

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

W92-176, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Aug 14, 2007, at 4:42 PM, Andi Kleen wrote:

> Chuck Anderson <cra@WPI.EDU> writes:
>>
>> If I'm reading correctly, it appears that the code above trashes the
>> %fs and %gs registers, or otherwise doesn't leave them at zero before
>> returning from the system call as the old code did.  Is this a  
>> correct
>> analysis?
>
> The kernel runs with defined fs -- saved and set at system call  
> entry/exit --
> and shouldn't touch gs (except on a context switch, but then it should
> be set back when you get scheduled again)
>
> It's in theory possible that something went wrong with the gs saving
> for the vm86 path, but this changed long 2.6.16. But I assume
> when you just remove the call in 2.6.16 it already works? If yes
> it cannot be that (2.6.16 didn't use either fs or gs in the kernel)
>
>> How should this be fixed?
>
> The problem first needs to be fully understood. Do you have more
> details on the corruption?
>
> One suspicious thing is that the audit code does mutex_lock 
> (&tty_mutex)
> and could sleep there. It's a long shot, but does the problem go
> away when you comment that out? [such a patch is incorrect in theory,
> but should be unlikely enough to crash for a quick test]
>
> But actually sleeping should be ok here and a preemptible kernel  
> could do
> it anyways.
>
> -Andi

