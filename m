Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZBIKdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZBIKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZBIKdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:33:25 -0500
Received: from www.tglx.de ([62.245.132.106]:41903 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbZBIKdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:33:24 -0500
Date: Mon, 9 Feb 2009 11:32:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Collins <paul@burly.ondioline.org>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
In-Reply-To: <sWhNs83kKPE.A.p4D.L20jJB@chimera>
Message-ID: <alpine.LFD.2.00.0902091000230.415@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.p4D.L20jJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
> Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
> Submitter	: Paul Collins <paul@burly.ondioline.org>
> Date		: 2009-01-21 7:15 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496

First bad commit ? The commit adds a WARN_ON to getnstimeofday() when
it is called while timekeeping is suspended. So instead of pointing to
that commit can we please figure out WTF this happens?

Looking at the call stack this is pretty obvious:

[ee4fdc80] [c0053b10] do_gettimeofday+0x1c/0x58
[ee4fdcb0] [c0348868] evdev_event+0x28/0x158
[ee4fdce0] [c0340ce4] input_pass_event+0xac/0xb0
[ee4fdd00] [c0343a44] input_event+0x80/0x98
[ee4fdd20] [c02f6d24] via_pmu_event+0x88/0x8c
[ee4fdd30] [c02f4f60] via_pmu_interrupt+0x6e0/0xb2c
[ee4fdd90] [c02f5664] pmu_wait_complete+0x50/0x84
[ee4fddb0] [c02f6764] powerbook_sleep+0x9f0/0xb24
[ee4fde40] [c00607f8] suspend_devices_and_enter+0x10c/0x180
[ee4fde60] [c0060a1c] enter_state+0x11c/0x160
[ee4fde80] [c02f4404] pmu_ioctl+0x15c/0x24c
[ee4fde90] [c00bab04] vfs_ioctl+0x8c/0x90
[ee4fdea0] [c00babb8] do_vfs_ioctl+0x8c/0x70c
[ee4fdf10] [c00bb2d4] sys_ioctl+0x9c/0xa4
[ee4fdf40] [c0012eb8] ret_from_syscall+0x0/0x38

powerbook_sleep() calls into the event interface which calls
gettimeofday() _AFTER_ timekeeping was suspended already so the
WARN_ON triggers.

Thanks,

	tglx
