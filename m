Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXEaFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXEaFrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 01:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXEaFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 01:47:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXEaFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 01:47:05 -0400
Date: Wed, 30 May 2007 22:46:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: floppy.c soft lockup
Message-Id: <20070530224650.04b33117.akpm@linux-foundation.org>
In-Reply-To: <465C6359.1020106@compro.net>
References: <465C6359.1020106@compro.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 13:31:05 -0400 Mark Hounschell <markh@compro.net> wrote:

> Changes in floppy.c from 2.6.17 and 2.6.18 have broken an application I have. I have tracked 
> it down to a single line of code. When the following patch is applied to the version in 2.6.18
> my application works.
> 
> --- linux-2.6.18/drivers/block/floppy.c 2006-09-19 23:42:06.000000000 -0400
> +++ linux-2.6.18-crt/drivers/block/floppy.c     2007-05-29 09:12:20.000000000 -0400
> @@ -893,7 +893,6 @@
>                 set_current_state(TASK_RUNNING);
>                 remove_wait_queue(&fdc_wait, &wait);
> 
> -               flush_scheduled_work();
>         }
>         command_status = FD_COMMAND_NONE;
> 
> I don't claim to understand the changes from 2.6.17 to 2.6.18 except for the devfs removal.
> All I can say is this one line of code kills the application. I have tried to write a short pgm
> that shows my problem but everything else I write seems to work. The application only runs
> on SMP machines and uses process and irq affinities with real-time scheduling. When I turn
> off process and irq affinities the application runs. 
> 
> I have tried kernels up through 2.6.21.1 with the same results. All kernels from 2.6.18 up
> require that I remove this one line of code or my application does not work?

Interesting.  I'd expect that the calling process is spinning, with realtime
policy and is expecting some other process to do something (ie: run a workqueue).

If you keep the process and irq affinities, and disable the realtime policy
does that also prevent the problem?

It would be interesting it you could capture a few task traces while it is stuck:
echo 1 > /proc/sys/kernel/sysrq then do ALT-SYSRQ-P a bunch of times and ALT-SYSRQ-T,
see if you can work out where the CPU is stuck.

ALso, 2.6.22-rc3 might have accidentally fixed this.
