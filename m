Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXI1OMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXI1OMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXI1OLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:11:46 -0400
Received: from rtr.ca ([76.10.145.34]:3472 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbXI1OLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:11:45 -0400
Message-ID: <46FD0BA2.6030600@rtr.ca>
Date: Fri, 28 Sep 2007 10:11:46 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
Subject: Re: [PATCH] disable non-boot CPUs before poweroff
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl> <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca>
In-Reply-To: <46FD0724.5060009@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> We need to disable all CPUs other than the boot CPU (usually 0)
> before attempting to power-off modern SMP machines.
> This seems to fix the hang-on-poweroff issue
> that one of my SMP boxes exhibits.  More testing required.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> 
> --- linux/kernel/sys.c.orig    2007-09-13 09:49:11.000000000 -0400
> +++ linux/kernel/sys.c    2007-09-28 09:48:54.000000000 -0400
> @@ -32,6 +32,7 @@
> #include <linux/getcpu.h>
> #include <linux/task_io_accounting_ops.h>
> #include <linux/seccomp.h>
> +#include <linux/cpu.h>
> 
> #include <linux/compat.h>
> #include <linux/syscalls.h>
> @@ -879,6 +880,7 @@
>     if (pm_power_off_prepare)
>         pm_power_off_prepare();
>     sysdev_shutdown();
> +    disable_nonboot_cpus();
>     printk(KERN_EMERG "Power down.\n");
>     machine_power_off();
> }

Okay, verified now.  Prior to this patch, *both* CPUs were still up and running
when machine_power_off() got called, and there was no guarantee that CPU0 was
the one calling machine_power_off().   BUG.

The above patch guarantees that only the single boot CPU is running
and calling machine_power_off().

Hopefully this buries the SMP-power-off bogeyman for good!

Cheers
