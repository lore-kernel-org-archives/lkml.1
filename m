Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbYFTVlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbYFTVlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYFTVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:41:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55916 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYFTVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:41:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
	<20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com>
	<m1d4mdksau.fsf@frodo.ebiederm.org> <20080620151650.GA5606@sgi.com>
	<m1wskkt281.fsf@frodo.ebiederm.org> <20080620191826.GA9936@sgi.com>
Date: Fri, 20 Jun 2008 14:33:21 -0700
In-Reply-To: <20080620191826.GA9936@sgi.com> (Cliff Wickman's message of "Fri,
	20 Jun 2008 14:18:26 -0500")
Message-ID: <m13an7n65a.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cliff Wickman <cpw@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] X86: reboot-notify additions
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:

> On Fri, Jun 20, 2008 at 11:01:34AM -0700, Eric W. Biederman wrote:
>> Cliff Wickman <cpw@sgi.com> writes:
>
>>>  void emergency_restart(void)
>>>  {
>>> +     struct raw_notifier_head rh;
>>> +
>>> +     rh.head = reboot_notifier_list.head;
>>> +     raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);
>>>       machine_emergency_restart();
>>>  }
>
>> that's still not a good idea - a blocking notifier list is that: a list
>> that has stuff which might block. emergency_restart() might get called
>> by non-blocking codepaths as well and it expects the restart to occur.
>>
>>         Ingo
>
> Oh. I get it now.  I was just looking at how the types of lists protect
> against additions to the list.
>
> Seems an atomic list would do what we want.  By definition the functions
> on such a list should not block.
>  
>> >> 
>> >> Cool.  Someone who wants this kind of functionality and has code in
>> >> the kernel.  Perhaps we can have a reasonable discussion about this.
>> >> The last time this came up people wanted a hook so they could support
>> >> their out of tree blobs in an enterprise kernel.
>> >> 
>> >> emergency_restart only happens or only should happen with explicit admin
>> >> request Sysreq-r.  Or when a watchdog detects the system is borked.
>> >> By design it is not expected to call drivers.  The kexec on panic
>> >> case is similar.
>> >
>> > I suppose one could trust that someone with superuser permission would
>> > not stop one partition of a multi-partitioned system in a cavalier manner.
>> > I'm inclined to think we should run the reboot_notifier_list even in those
>> > situations.
>> 
>> NACK  emergency_restart is for when calling a normal reboot doesn't
>> work i.e. calling the reboot_notifier_list is broken.
>> 
>> emergency_restart is by definition a hack.
>
> Perhaps there should be a normal_restart() and an emergency_restart().
> Currently, on x86, emergency_restart() is called in both sane and error
> situations.

Simply because it is a proper subset of the sane situation.
kernel_restart is the normal situation.

>> Also now that I think about it now that we have the device tree
>> notifications the last few users of the reboot_notifier_list should
>> be updated and the reboot_notifier_list should just be removed.
>> 
>> > But definitely on some watchdog timeout event.  Some kind of mechanism
>> > should be invoked to communicate the stoppage.
>> 
>> I'm not certain why this is important if you have a hardware partition
>> that looks like real hardware.  In that case the firmware should
>> easily be able to detect this because we reboot the partition.
>
> I suppose the firmware could get involved.  It's true that the live
> partitions have no problem until the dead partition is rebooted and
> memory barriers are raised to the memory the live partitions are accessing.
> I suppose the rebooting partition could communicate to the firmware in
> the live partitions.  But to communicate to a driver in the OS, and then
> back again to the firmware in the dead partition might be pretty messy.

Fun shared memory between kernels.  Can the kernel that is accessing the
shared memory not just trap on the failure and handle it?

> We do have an atomic panic_notifier_list.  How about using that?
> The functions on the list are supposed to be non-blocking.
>
> (currently I only see 5 of them in use -- lguest_panic panic_event
> wdog_panic_handler panic_happened softlock_panic)
>
>> In the crash_kexec case we can call functions on the other side of the
>> kexec notifier.  So there is very much a hook there.
>
> Sorry, I'm not understanding that.  What is that hook?

In the kexec on panic case the hook is any random standalone executable
(typically another kernel) that you want to use.  It is arguably the
most powerful hook in the kernel.


> Perhaps a split of emergency_restart() into normal_restart() and
> emergency_restart() would reserve emergency_restart() for just those cases.
> Then we could use the emergency procedures only in the emergency
> cases.

That is where emergency_restart comes from.  Now if you think the
watchdog drivers are calling the wrong function it should be easy
to update them.

>> So can we please start with what exactly you need to do on the xpc and
>> why?
>
> See xpc_system_reboot() [drivers/misc/sgi-xp/xpc_main.c]
> It is called from the reboot_notifier_list when the system is being
> rebooted.
> The driver calls xpc_do_exit() go through its normal exit processing.  This
> involves some significant waiting.

Ok.  Looking at that code.  It is wholly inappropriate to be called in
a non-blocking emergency context as written.

>
> And xpc_system_die().
> It is called from the die_chain (on ia64).  But on x86 there are these
> couple of cases where no callback occurs from the reboot or panic
> lists.

Yes.  emergency_restart() came about because were explicitly skipping
doing a clean shutdown, in a nasty way.  So it is the a deliberate
hack.

crash_kexec is similar.  xpc_system_die is no where close to as
robust as the rest of the crash_kexec code path, and just calling
it looks like it might double or triple the amount of code on that
path, in general noticeably increasing the chances you won't get a core
dump when something goes wrong.

> The driver is to be called back when the kernel is restarted or halted due
> to some sort of failure. It calls xpc_die_disengage() to notify other
> partitions to disengage from all references to the dying partition's memory.
> There is some waiting for the other partitions.

And now I begin to see part of the issue.  The code is constructed as
a driver, as a loadable module in fact.  Yet it is grubbing down low
in the chipset, and is doing (to put it politely) highly non-standard
things.  Thus the need for more support for the kernel then a normal
driver needs.

Implemented as platform code, as a subarchitecture, I don't have much
problem with weird support code doing things that normally shouldn't
be done.  I think that is a maintainable situation.

Making it possible for any random driver to hook crash_kexec or
emergency_restart seems like a short recipe to remove reliability
from those code paths.

If you really want to stay a driver then I suggest making your driver
robust so when one member of your memory sharing group goes down it
doesn't bring the rest of the members down with it.

Eric
