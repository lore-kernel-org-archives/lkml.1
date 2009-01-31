Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZAaUX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZAaUX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZAaUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:23:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55202 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZAaUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:23:48 -0500
Date: Sat, 31 Jan 2009 21:23:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-rt-users@vger.kernel.org
Cc: Frank Rowand <frank.rowand@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>, avorontsov@ru.mvista.com,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: 2.6.28-rt on ARM [Was: 2.6.28-rt on PowerPC]
Message-ID: <20090131202323.GA26891@pengutronix.de>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233270043.3833.57.camel@localhost.localdomain> <49823A13.50703@am.sony.com> <20090130230633.GG32026@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090130230633.GG32026@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed linuxppc-dev from Cc: and put linux-arm-kernel there instead.]

Hello,

On Sat, Jan 31, 2009 at 12:06:33AM +0100, Robert Schwebel wrote:
> On Thu, Jan 29, 2009 at 03:21:55PM -0800, Frank Rowand wrote:
> > > Thanks! I have not yet had the chance to apply any arch patches yet. I
> > > do plan on doing so after getting the code mostly working on x86.
> > 
> > Your email can at an opportune time for me...  I was starting to try
> > 2.6.28-rt on ARM and quickly came to the conclusion that the arch
> > patches weren't the focus yet.  But I'm currently side-tracked with
> > getting my board to even boot a vanilla 2.6.28 kernel first.  Do
> > you expect to get to the arches in the next week or two?  If not,
> > I may head down that path for ARM myself.
> 
> Uwe has collected some patches for ARM here:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/52108/focus=787937
> 
> You might want to try them before starting, in order to avoid duplicate
> work.
I take this as a motivation to give a status of my current work.

My git repo[1] has a branch rt-master that is regularily rebased on
Steven's linux-rt/master branch.  This is my working branch.  Currently
all ARM defconfigs but clps7500, msm and omap_2430sdp can be build
without error after enabling PREEMPT_RT.  (I have a script to build all
these configs.  If someone wants it, just ask for it.)

That branch has some netx related patches as this is my current
platform.

Currently booting my machine results in two BUGs:

	...
	BUG: swapper:0 task might have lost a preemption check!
	[<c0242b48>] (dump_stack+0x0/0x18) from [<c0030304>] (preempt_enable_no_resched+0x54/0x60)
	[<c00302b0>] (preempt_enable_no_resched+0x0/0x60) from [<c0023f48>] (cpu_idle+0x50/0x68)
	[<c0023ef8>] (cpu_idle+0x0/0x68) from [<c02421e4>] (rest_init+0x6c/0x80)
	 r7:c02ee69c r6:c001cd90 r5:c031b950 r4:c06d7e5c
	[<c0242178>] (rest_init+0x0/0x80) from [<c0008bb4>] (start_kernel+0x234/0x28c)
	[<c0008980>] (start_kernel+0x0/0x28c) from [<80008034>] (0x80008034)
	 r6:c001d194 r5:c031b9ec r4:00053175
	...

and

	Freeing init memory: 104K
	BUG: sleeping function called from invalid context at .../linux-2.6-rt/kernel/rtmutex.c:711
	in_atomic(): 1 [00000001], irqs_disabled(): 0, pid: 1, name: init
	1 lock held by init/1:
	  from [<c002eed4>] (__might_sleep+0x100/0x120)
	[<c002edd4>] (__might_sleep+0x0/0x120) from [<c0244c70>] (rt_spin_lock+0x40/0x9c)
	 r5:c0244c44 r4:c06d7990
	[<c0244c30>] (rt_spin_lock+0x0/0x9c) from [<c007a2a4>] (free_hot_cold_page+0x208/0x394)
	 r5:c0714ca0 r4:c1c1c000
	[<c007a09c>] (free_hot_cold_page+0x0/0x394) from [<c007a4a4>] (free_hot_page+0x18/0x1c)
	 r8:c1516fb8 r7:bf000000 r6:bf000000 r5:c1516fb8 r4:bf000000
	[<c007a48c>] (free_hot_page+0x0/0x1c) from [<c007a4ec>] (__free_pages+0x44/0x50)
	[<c007a4a8>] (__free_pages+0x0/0x50) from [<c00882a4>] (free_pgd_range+0x16c/0x190)
	[<c0088138>] (free_pgd_range+0x0/0x190) from [<c00a30cc>] (setup_arg_pages+0x1f4/0x2d0)
	[<c00a2ed8>] (setup_arg_pages+0x0/0x2d0) from [<c00d327c>] (load_elf_binary+0x458/0x1184)
	[<c00d2e24>] (load_elf_binary+0x0/0x1184) from [<c00a219c>] (search_binary_handler+0x100/0x2d0)
	[<c00a209c>] (search_binary_handler+0x0/0x2d0) from [<c00a349c>] (do_execve+0x1b4/0x250)
	[<c00a32e8>] (do_execve+0x0/0x250) from [<c0025cfc>] (kernel_execve+0x44/0x8c)
	[<c0025cb8>] (kernel_execve+0x0/0x8c) from [<c0022590>] (init_post+0xf4/0x17c)
	 r7:00000000 r6:00000000 r5:c001bdf4 r4:c02ee46c
	[<c002249c>] (init_post+0x0/0x17c) from [<c0008670>] (kernel_init+0x160/0x1d0)
	 r4:c031b958
	[<c0008510>] (kernel_init+0x0/0x1d0) from [<c0038040>] (do_exit+0x0/0x7c0)
	 r5:00000000 r4:00000000
	Kernel panic - not syncing: Attempted to kill init!
	Dumping ftrace buffer:
	   (ftrace buffer empty)

I havn't looked into these issues yet, but will do now.

If someone has questions (or even can and wants to help) you can reach
me by mail or on #linux-rt when online.

Best regards
Uwe

[1] git://git.pengutronix.de/git/ukl/linux-2.6.git
    http://git.pengutronix.de/?p=ukl/linux-2.6.git;a=summary
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
