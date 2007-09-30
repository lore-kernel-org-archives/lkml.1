Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXI3WxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXI3WxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXI3Ww4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:52:56 -0400
Received: from rtr.ca ([76.10.145.34]:4133 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbXI3Wwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:52:55 -0400
Message-ID: <470028C5.7020501@rtr.ca>
Date: Sun, 30 Sep 2007 18:52:53 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 32-bit Athlon X2 won't poweroff  (was:  Fix SMP poweroff hangs)
References: <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <46FFEF41.8010104@rtr.ca> <20070930200336.GA2441@pul.manty.net>
In-Reply-To: <20070930200336.GA2441@pul.manty.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Santiago Garcia Mantinan wrote:
> I booted into single mode, then umounted all unneeded stuff and put / to ro,
> stopped all unused raids, ... then did...
..
>>    strace /bin/halt -f -p
..
> rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
> rt_sigaction(SIGCHLD, NULL, {SIG_DFL}, 8) = 0
> rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> nanosleep({2, 0}, {2, 0})               = 0
> reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_RESTART|0x88888888) = 0
> kill(1, SIGTSTP)                        = 0
> reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_POWER_OFF <unfinished ... exit status 0>
> 
> Same output on the screen as I commented before, again I got to the shell
> and this time I even typed some commands like ps and amazingly they still
> worked, even though this was supposed to be halted.

Mmm.. okay, user space is doing the right things.

So next is inside the kernel itself, at linux/kernel/sys.c :: sys_reboot(),
where we see this code:

        /* Instead of trying to make the power_off code look like
         * halt when pm_power_off is not set do it the easy way.
         */
        if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
                cmd = LINUX_REBOOT_CMD_HALT;

This converts a "poweroff" into a "reboot" if no machine dependent
power off function has been bound in (pm_power_off() is a function pointer).

So for this to work, I believe that either ACPI or APM has to have been
configured into the kernel (and the modules loaded).  Your kernel .config
from earlier shows ACPI built-in to the kernel core, so it should be present.

Unless you booted with noacpi or some such parameter..
So let's have a look at the kernel boot logs,
and you could also try CONGIG_ACPI_DEBUG=y

Bizarre (and nothing to do with my patch).

