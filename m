Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYEFNEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYEFNEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYEFNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:04:16 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:7467 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYEFNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:04:15 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       zdenek.kabelac@gmail.com
Subject: Re: [PATCH REPOST^3] Run IST traps from user mode preemptive on process stack
From: Andi Kleen <andi@firstfloor.org>
References: <20080502091948.GA26099@basil.nowhere.org>
	<alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de>
Date: Tue, 06 May 2008 15:03:37 +0200
In-Reply-To: <alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Tue, 6 May 2008 14:31:41 +0200 (CEST)")
Message-ID: <87skwvbn4m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 May 2008 12:56:40.0629 (UTC) FILETIME=[A0A6EE50:01C8AF78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Fri, 2 May 2008, Andi Kleen wrote:
>> [Fixes a bug originally introduced in 2.6.23 I think. Reposted many times
>> so far, but still not applied. Please apply.]
>
> The print_vma_addr() bug was introduced by commit 03252919 (by you) in
> the 2.6.25 merge window and we fixed it before 25-rc2 via commit e8bff74a.

Well it was worked around, not properly fixed. This patch fixes it properly.
The problem of the original workaround is that it wouldn't print the vma
now in many cases because it couldn't take the semaphore.

The workaround was right back then because it was shortly before 
the release, but it was always a ward that needed fixing properly.

I believe it was a good idea anyways because there were always 
some possible problems with not being able to sleep in these 
exception handlers.

>
> This introduces two security bugs in one go:
>
> 1.) The IST stack pointer is elevated unconditionaly and with your
> change we can now schedule away in the handler. 

Yes, but that's fine.

> this same CPU triggers the same trap and elevates it again.

That's not possible generally. None of these interrupts can
nest in a normal kernel.

Do you refer to the DEBUG_STACK ist add/dec? That is not needed
for anything in tree to my knowledge. 

> 2.) The IST stack pointer is unbalanced in the other direction as well:
> it is incremented on CPUn then the handler is scheduled away and migrated
> to CPUm. After return from the handler the IST stacks of both CPUs are
> corrupted. Exploitable by unprivileged user-space code as well.

The IST is restored again after the handler. You're right that strictly
wouldn't be needed and could be avoided, but i don't think it's exploitable
in any ways.

Regarding user controlled pt_regs: I think you're forgetting that
x86-64 doesn't have vm86 mode and that we can always trust pt_regs
segment indexes. On i386 you would be right, but not here.

-Andi
