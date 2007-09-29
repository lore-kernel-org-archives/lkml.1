Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXI2BO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXI2BO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXI2BOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:14:19 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40447 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbXI2BOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:14:18 -0400
In-Reply-To: <46FDA325.8000602@goop.org>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <46FDA325.8000602@goop.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Fri, 28 Sep 2007 21:13:11 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Mailer: Apple Mail (2.752.2)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your fix seems to have remedied a problem we are having with EDID  
fetches through vm86.c.  At the present moment, we're trying to  
understand your cleanup so as to back port it to an earlier rev of  
the kernel (2.6.18).

3 questions for you:

1. Are we correct in understanding that your cleanup only touched  
vm86.c and vm86.h?

2. Do you remember your changes well enough from back when you made  
them in December 2006 to be able to point out the changes solely made  
to the audit calls?

3. Does correct operation of vm86.c in the 2.6 kernel require all of  
your changes, or just the subset that affects the audit calls?

Thanks in advance,

-Bill Cattey

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

N42-040M, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Sep 28, 2007, at 8:58 PM, Jeremy Fitzhardinge wrote:

> William Cattey wrote:
>> Andi,
>>
>> Sorry to have taken so long to take another step with this problem.
>> Once my customers had a work-around, other priorities crowded out  
>> this
>> project.  Today Chuck and I did a little more work.  We'd heard  
>> that a
>> more recent kernel alleged to fix this stuff.  Doing some digging, we
>> came across this:
>
> Hi,
>
> I cleaned up some completely bogus code in vm86.c.  I don't have any
> context for your mail though:  is my change causing you problems, or
> does it fix something for you?
>
> Thanks,
>     J
>
>>
>> (http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20)
>>
>> commit 49d26b6eaa8e970c8cf6e299e6ccba2474191bf5
>> Author: Jeremy Fitzhardinge <jeremy@goop.org>
>> Date:    Thu Dec 7 02:14:03 2006 +0100
>>
>>     [PATCH] i386: Update sys_vm86 to cope with changed pt_regs and  
>> %gs
>> usage
>>
>>     sys_vm86 uses a struct kernel_vm86_regs, which is identical to
>> pt_regs, but
>>     adds an extra space for all the segment registers.    Previously
>> this structure
>>     was completely independent, so changes in pt_regs had to be
>> reflected in
>>     kernel_vm86_regs.  This changes just embeds pt_regs in
>> kernel_vm86_regs, and
>>     makes the appropriate changes to vm86.c to deal with the new  
>> naming.
>>
>>     Also, since %gs is dealt with differently in the kernel, this
>> change adjusts
>>     vm86.c to reflect this.
>>
>>     While making these changes, I also cleaned up some frankly  
>> bizarre
>> code which
>>     was added when auditing was added to sys_vm86.
>>
>>     Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>>     Signed-off-by: Andi Kleen <ak@suse.de>
>>     Cc: Chuck Ebbert <76306.1226@compuserve.com>
>>     Cc: Zachary Amsden <zach@vmware.com>
>>     Cc: Jan Beulich <jbeulich@novell.com>
>>     Cc: Andi Kleen <ak@suse.de>
>>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>>     Cc: Jason Baron <jbaron@redhat.com>
>>     Cc: Chris Wright <chrisw@sous-sol.org>
>>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>>
>> Chuck and I took a stab at extracting what we thought was the  
>> relevant
>> change to the audit_syscall_exit code, but we must have gotten it
>> wrong.  The EDID transfer always comes up zeros with our extract of
>> Fitzhardinge's patch.
>>
>>
>> At this point Chuck and I are trying to decide what will get us the
>> best testing with the least effort.  (We keep planning to test with a
>> stock kernel, but last time that was on our TODO list, the project
>> languished for a month.)
>>
>> Do you have a specific stock kernel revision to recommend we try on
>> our test system currently running Red Hat's 2.6.18?  Are we right to
>> presume it would be 2.6.18-0 to demonstrate failure and 2.6.20.0 to
>> attempt to demonstrate success?
>>
>> Are you the Andi Kleen who signed off on Fitzhardinge's patch, and if
>> so do you have some insight for Chuck and I about what pieces are
>> required to test and see if the bug really got fixed with his  
>> cleanup?
>>
>> I'd feel a lot more confident we were on the right track if I could
>> just correctly patch Fitzhardinge's cleanup into the test setup I  
>> have
>> now.
>>
>> -Bill
>>
>> ----
>>
>> William Cattey
>> Linux Platform Coordinator
>> MIT Information Services & Technology
>>
>> N42-040M, 617-253-0140, wdc@mit.edu
>> http://web.mit.edu/wdc/www/
>>
>>
>> On Aug 14, 2007, at 6:19 PM, Andi Kleen wrote:
>>
>>> On Tue, Aug 14, 2007 at 06:14:40PM -0400, William Cattey wrote:
>>>> In fact, I had begun the process of assuring myself that I could
>>>> indeed take a main line kernel, and install it in place of a Red  
>>>> Hat
>>>> Kernel.
>>>
>>> Should normally work. Sometimes there are incompatibilities
>>> with udev -- it is safest to just compile in the drivers you
>>> need to avoid that -- but likely it would work even without
>>> that on a modern distro.
>>>
>>>> Shall I check back with you after we've re-run the test after  
>>>> putting
>>>> the stock kernel on the machine?  It will be a couple weeks because
>>>> they're moving my office on Thursday, I'm away on vacation the
>>>> following week, and I'm still unsure of the procedure to follow to
>>>> build a totally stock totally mainline kernel and put it into place
>>>> instead of what Red Hat has made.
>>>
>>> Better report to the list again in case others want to chime in.
>>> But you can put me into cc because I would need to merge
>>> any resulting patch anyways.
>>>
>>> -Andi
>>
>

