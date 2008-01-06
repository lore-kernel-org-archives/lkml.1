Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYAFUgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYAFUgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYAFUgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:36:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46572 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYAFUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:36:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
References: <20080106150722.GA15887@elte.hu>
Date: Sun, 06 Jan 2008 13:35:14 -0700
In-Reply-To: <20080106150722.GA15887@elte.hu> (Ingo Molnar's message of "Sun,
	6 Jan 2008 16:07:22 +0100")
Message-ID: <m1tzlqlmkd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Eric,
>
> you added these warnings, right?

Yes, and the particular warning that is triggering this is
the first time I have seen it.  I didn't know we had any
sysctl users that were buggy in attempting to create the
same file twice.


This sounds like we have a leak or a reference counting bug that
is registering the sysctl field twice.

My hunch is something is going wrong when loading or unloading
the module.

I only see the single instance of the string "timeslice" in
the kernel.  So it doesn't look like there are multiple
modules registering the same sysctl just a logic bug.

I took a quick look at drivers/char/ppdev.c but I don't
recognize the idiom so I can't spot where we are doing something
wrong. 

Looking in drivers/parport/procfs.c
parport_proc_register and parport_proc_unregister look fine adding a
sysctl entry when registering and removing it when unregistering.

Similarly looking in drivers/parport/share.c
parport_register_device and parport_unregister_device look fine.

The logic in ppdev though looks odd.  But not so odd I can
say it is broken or immediately recommend a fix.

The net result where we only have a file in /proc/sys when
you have opened the parallel port and run the right ioctl
is most definitely weird.

I took a quick skim through the git logs and it doesn't look like
anyone has done anything significant to ppdev.c in years.  So I don't
expect there is anyone who knows what that code is doing off their
head.

Currently the error handling appears robust it should
not prevent the printer from being used.

So it looks like my warnings have uncovered yet another
ancient sysctl usage bug.

If someone else doesn't figure out what is going wrong before
I get to it.  I will try and take a look and see if I can figure
out what is going wrong in ppdev.c.

Short of two programs coming in and simultaneously trying to claim
the parallel port and there being not exclusion in ppdev.c I don't
have a clue what could cause the reported error.

Eric

> (Resending as there were no replies on my first post mid December; issue
> is still there with -rc6.)
>
> This is the first time I've seen this error. Last time I used the printer 
> was with 2.6.24-rc3 and that time this error did not occur.
> The error occurs when I start a print job, not when I turn the printer on.
>
> System is Pentium D x86_64 kernel running Debian unstable.
> Printer is a HP Photosmart P1100 connected via parallel port.
>
> Not sure who should be CCed on this.
>
> ppdev0: registered pardevice
> sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice Sysctl
> already exists
> Pid: 14491, comm: hpijs Not tainted 2.6.24-rc5 #1
>
> Call Trace:
>  [<ffffffff8024c0b0>] set_fail+0x3f/0x47
>  [<ffffffff8024c566>] sysctl_check_table+0x4ae/0x4fb
>  [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
>  [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
>  [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
>  [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
>  [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
>  [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
>  [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
>  [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
>  [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
>  [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
>  [<ffffffff8023ca15>] register_sysctl_table+0x52/0x9d
>  [<ffffffff881d97cb>] :parport:parport_device_proc_register+0xc3/0xe3
>  [<ffffffff881d7da7>] :parport:parport_register_device+0x206/0x267
>  [<ffffffff884171ae>] :ppdev:pp_irq+0x0/0x40
>  [<ffffffff8841774f>] :ppdev:pp_ioctl+0x13f/0x77c
>  [<ffffffff80296a11>] do_ioctl+0x55/0x6b
>  [<ffffffff80296c6a>] vfs_ioctl+0x243/0x25c
>  [<ffffffff80296cd4>] sys_ioctl+0x51/0x71
>  [<ffffffff8020beee>] system_call+0x7e/0x83
>
> Cheers,
> FJP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> ----------
