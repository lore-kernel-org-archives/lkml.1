Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYFTSLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYFTSLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYFTSLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:11:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47031 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYFTSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:11:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
	<20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com>
	<m1d4mdksau.fsf@frodo.ebiederm.org> <20080620151650.GA5606@sgi.com>
Date: Fri, 20 Jun 2008 11:01:34 -0700
In-Reply-To: <20080620151650.GA5606@sgi.com> (Cliff Wickman's message of "Fri,
	20 Jun 2008 10:16:50 -0500")
Message-ID: <m1wskkt281.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cliff Wickman <cpw@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0107]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] X86: reboot-notify additions
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:

>> 
>> Cool.  Someone who wants this kind of functionality and has code in
>> the kernel.  Perhaps we can have a reasonable discussion about this.
>> The last time this came up people wanted a hook so they could support
>> their out of tree blobs in an enterprise kernel.
>> 
>> emergency_restart only happens or only should happen with explicit admin
>> request Sysreq-r.  Or when a watchdog detects the system is borked.
>> By design it is not expected to call drivers.  The kexec on panic
>> case is similar.
>
> I suppose one could trust that someone with superuser permission would
> not stop one partition of a multi-partitioned system in a cavalier manner.
> I'm inclined to think we should run the reboot_notifier_list even in those
> situations.

NACK  emergency_restart is for when calling a normal reboot doesn't
work i.e. calling the reboot_notifier_list is broken.

emergency_restart is by definition a hack.

Also now that I think about it now that we have the device tree
notifications the last few users of the reboot_notifier_list should
be updated and the reboot_notifier_list should just be removed.

> But definitely on some watchdog timeout event.  Some kind of mechanism
> should be invoked to communicate the stoppage.

I'm not certain why this is important if you have a hardware partition
that looks like real hardware.  In that case the firmware should
easily be able to detect this because we reboot the partition.

>> As far as this being a generic problem I half agree.  It seems to depend
>> on your platform if you need something like this.
>> 
>> With that said.  I suggest we have a single platform specific function 
>> that can be called.  Possibly something like pm_power_off.  It is
>> insanely important that we be able to audit all of the code on these
>> code paths, and that a random loadable driver not be able to get in
>> and mess things up.
>
> The panic() function has the panic_notifier_list for those cases where
> crash_kexec() does not find a crash kernel to exec.
>
> That leaves holes for watchdog-type events and crash_kexec().
> Can you elborate on the problem with running a non-blocking scan of 
> the reboot_notifier_list in those situations?
>
> What do you have in mind as a platform specific function, that would
> be an improvement over the reboot_notifier_list?

In the general case it is WRONG to notify or run any function before
crash_kexec.  The assumption is that the current kernel is BROKEN.  So the
goal is to keep our exposure to kernel bugs to a minimum.  There is currently
too _much_ code being run on the crash_kexec path.

In the crash_kexec case we can call functions on the other side of the
kexec notifier.  So there is very much a hook there.

> My current (v2) proposed patch for using the reboot_notifier_list as
> this mechanism looks like this:
> (and I'm not sure if using atomic_notifier_call_chain() might be a better
>  alternative to raw_notifier_call_chain())

I am willing to look at performing actions in the crash_kexec path
on a case by case basis.  Which means essentially a hard coded function
call that compiles out on the hardware where it is meaningless.

As for emergency_restart.  That is for those times when doing a proper
reboot doesn't work and you just want to rest the hardware. 

So can we please start with what exactly you need to do on the xpc and
why?

Eric
