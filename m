Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYCVNfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYCVNfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 09:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYCVNe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 09:34:59 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:54131 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYCVNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 09:34:59 -0400
Message-ID: <47E50AF9.5070801@frugalware.org>
Date: Sat, 22 Mar 2008 14:34:49 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Thomas Gleixner wrote:
>>> | 1.78 us, TSC-warps:0 | 19.27 us, TOD-warps:0 | 19.37 us, CLOCK-warps:0
>> Ok. So the watchdog trigger is a false positive. 
>>
>> Thinking more about it, it looks like Andi's change triggers some
>> hidden bug in the combination of NO_HZ and add_timer_on(), where the
>> CPU on which the timer is added is likely in a long idle sleep. I look
>> into this tomorrow.
> 
> Ok. Here is what's happening:
> 
> CPU0 runs the watchdog timer and schedules it on CPU1.
> 
> With NO_HZ enabled CPU1 is in a long idle sleep. At this point of the
> boot process there is probably no timer pending on CPU1, which means
> the idle sleep is infinite.
> 
> Now some time later CPU1 gets woken by an interrupt/IPI and runs the
> timer wheel. At this point the pm_timer which is the reference clock
> has already wrapped around, so the watchdog thinks that there is a
> huge time difference and marks the TSC unstable.
> 
> Aside of that watchdog issue this also affects the other users of
> add_timer_on(): e.g. queue_delayed_work_on().
> 
> Can you please apply the patch below and verify it with Andi's
> watchdog patch applied ? 


Did that , git head , Andi's + your patch but TSC is still marked unstable.

> 
> Thanks,
> 
> 	tglx
> 


Gabriel
