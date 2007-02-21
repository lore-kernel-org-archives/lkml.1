Return-Path: <linux-kernel-owner+w=401wt.eu-S1945911AbXBUXZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911AbXBUXZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423248AbXBUXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:25:08 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49472 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945911AbXBUXZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:25:05 -0500
Message-ID: <45DCD4D0.2000101@vmware.com>
Date: Wed, 21 Feb 2007 15:25:04 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.osdl.org, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 17/24] Xen-paravirt_ops: avoid having
 a bad	selector in %gs during context switch
References: <20070221205254.169835700@goop.org>	<20070221205323.770169136@goop.org> <200702212310.02218.ak@suse.de>
In-Reply-To: <200702212310.02218.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>  	/*
>> +	 * Temporary hack: zero gs now that we've saved it so that Xen
>> +	 * doesn't try to reload the old value after changing the GDT
>> +	 * during the context switch.  This can go away once Xen has
>> +	 * been taught to only reload %gs when it absolutely must.
>> +	 */
>> +	loadsegment(gs, 0);
>>     
>
> Sorry, but i don't really want that unconditionally in the context switch.
> Adding a paravirt ops for it would be also ugly. Can Xen be fixed?
>   

I agree with that, but especially because this is not even the right 
place to save and clear gs; when userspace uses an LDT based %gs, you 
need to do this all the way back in mmu_context.h before you switch the 
LDT out.  We have the same bug, but I was loathe to try to fix it yet, 
since it could mean some strange code movement.  The awkward bit is that 
switch_mm doesn't have the pointer to the previous task, only it's mm, 
so there is no place to save gs.  Perhaps it is time to move the LDT 
switch into switch_to instead of switch_mm?  It's not like there are 
different per-process LDTs in the fixmap or something, which I could see 
as a valid reason to associate this with the mm switch.  But all process 
LDTs are global, so there isn't an issue.

And I noticed this martian hanging out in mmu_context.h:

#define deactivate_mm(tsk, mm)                  \
        asm("movl %0,%%gs": :"r" (0));

Zach
