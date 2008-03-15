Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbYCOL6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbYCOL6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 07:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYCOL6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 07:58:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33084 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYCOL6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 07:58:39 -0400
Date: Sat, 15 Mar 2008 15:03:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, mingo@elte.hu, xemul@openvz.org
Subject: Re: 2.6.25-rc5-mm1: "consolechars" hangs on boot
Message-ID: <20080315120324.GA76@tv-sign.ru>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D9A5A2.4000009@free.fr> <20080313153851.2023980c.akpm@linux-foundation.org> <20080314052606.GA226@tv-sign.ru> <47DAE8DB.4040606@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DAE8DB.4040606@free.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Laurent Riffard wrote:
>
> >>>With 2.6.25-rc5-mm1, my system (Ubuntu 7.10/Gutsy) reliably hangs on
> >>>boot. Sysrq-T shows 12 "consolechars" processes stuck in do_exit call.
> >>>
> >>>The bisection said "Sucker is
> >>>patches/signals-send_signal-factor-out-signal_group_exit-checks.patch"
> >>>
> consolechars ? de8925bc  3432 2795 1
> .
> .
> .
> Call Trace:
> 	do_exit+0x5dd/0x5e1
> 	do_group_exit+0x5e/0x86
> 	sys_exit_group+0xf/0x11
> 	sysenter_past_esp+0x5f/0xa5

Aha, the task doesn't hang, it has exited (as expected), please see below...

> >And. While doing this patch I forgot we should fix the bugs with init 
> >first!
> >(will try to make the patch soon).
> >
> >Laurent, any chance you can try 2.6.25-rc5-mm1 + the patch below?
> >Unlikely it can help, but would be great to be sure.
> 
> Yes it does help ! Thanks.
> 
> Despite a big ERR in dmesg, the system now runs fine.
> 
> [   26.780261] ERR!! init is killed by 10

Great. Thanks a lot Laurent!

So what happens is:

We have the very old bug (bugs, actually) with the global init && signals
which I tried to fix many times but can't find a simple solution. The fatal
signal sent to init doesn't really kill it (we have the check in
get_signal_to_deliver) but it sets SIGNAL_GROUP_EXIT. This is wrong, now
init can't exec, this has other bad implications, and this is just insane.

With the signals-send_signal-factor-out-signal_group_exit-checks.patch the
task with SIGNAL_GROUP_EXIT doesn't recieve the signals. While this change
itself is (I hope) correct, the "killed" /sbin/init now can't see SIGCHLD
and the system hangs on boot.

> [   26.781709]  [<c0120fa9>] complete_signal+0x163/0x1eb
> [   26.781719]  [<c01211d4>] send_signal+0x1a3/0x1cf
> [   26.781729]  [<c0121216>] __group_send_sig_info+0xa/0xc
> [   26.781737]  [<c01217cc>] group_send_sig_info+0x44/0x62
> [   26.781747]  [<c0121de4>] kill_pid_info+0x33/0x47
> [   26.781757]  [<c0122443>] sys_kill+0x73/0x145
> [   26.781767]  [<c014c655>] ? handle_mm_fault+0x21d/0x4f6
> [   26.781791]  [<c012af3c>] ? up_read+0x16/0x2a
> [   26.781803]  [<c011214c>] ? do_page_fault+0x25a/0x4da
> [   26.781815]  [<c0103906>] sysenter_past_esp+0x5f/0xa5

Not a kernel problem, but this looks a bit strange to me.

init has SIG_DFL for SIGUSR1, and someone does kill(1, SIGUSR1).
Note that init was explicitly targeted, the signal was not sent
to prgp or -1.

Most likely Ubuntu knows what it does, and I can't find any email
at ubuntu.com to cc...

Oleg.

