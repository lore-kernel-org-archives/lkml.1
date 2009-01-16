Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbZAPKnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbZAPKnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZAPKmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:42:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48907 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZAPKmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:42:47 -0500
Date: Fri, 16 Jan 2009 11:44:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090116104455.GA3283@elf.ucw.cz>
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl> <200901131342.44562.borntraeger@de.ibm.com> <20090113132805.GE30352@atrey.karlin.mff.cuni.cz> <b6a2187b0901130533m118e9401k8a7152d6f5982708@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0901130533m118e9401k8a7152d6f5982708@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Please let me know if that helped.
> >>
> >> I tested rc1+ these two reverts yesterday on my T61p. Doesnt work. There must
> >> be at least one more patch that broke S2R on my thinkpad. In fact, it is cpu
> >> hotplug that is broken (unplug works).
> >
> > I reproduced that: echo 0 > online works, echo 1 > online hangs. Will
> > compile SMP-less kernel to verify that there are no more problems...
> >                                                                        Pavel
> > --
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> I've a X61 running 32-bit and it's able to suspend-to-ram.
> 
> Please see "[Bug #12422] 2.6.28-git can't resume from str" if it's
> fixes your problem. Try to pull Linus' latest tree first and you need
> apply only Rafael's latest patch.

Which patch? 

Anyway, it is CPU hotplug vs. cpufreq interaction:

bash          D c024ed50     0  1780      1
 f71ae6b8 00000082 00000004 c024ed50 f71ae6b8 00000001 00000000
00000000
 c2010db4 f71ae6b8 f71166b8 f71ae910 c201b500 00000001 c0ab4500
f5d04dd0
 ffff8659 00000000 f71aeb68 00000000 00000046 00000000 c077b5c9
c2010da4
Call Trace:
 [<c024ed50>] __lock_acquire+0x240/0xac0
 [<c077b5c9>] rwsem_down_failed_common+0x29/0x170
 [<c077b615>] rwsem_down_failed_common+0x75/0x170
 [<c077b72a>] rwsem_down_write_failed+0x1a/0x30
 [<c077b7a2>] call_rwsem_down_write_failed+0x6/0x8
 [<c077abd5>] down_write+0x45/0x50
 [<c05c0f7c>] lock_policy_rwsem_write+0x2c/0x60
 [<c05c0f7c>] lock_policy_rwsem_write+0x2c/0x60
 [<c05c12ea>] cpufreq_add_dev+0x1ca/0x4f0
 [<c05c0988>] cpufreq_cpu_get+0xa8/0xb0
 [<c05c0fdf>] cpufreq_update_policy+0x2f/0xf0
 [<c0778b54>] coretemp_device_add+0xb4/0xd0
 [<c0778c9f>] cpufreq_cpu_callback+0x6f/0x80
 [<c02455ec>] notifier_call_chain+0x3c/0x80
 [<c0245677>] raw_notifier_call_chain+0x17/0x20
 [<c0776e8a>] _cpu_up+0x10a/0x110
 [<c0776edb>] cpu_up+0x4b/0x70
 [<c074b629>] store_online+0x59/0x80
 [<c074b5d0>] store_online+0x0/0x80
 [<c04220ad>] sysdev_store+0x2d/0x40
 [<c02cc6d6>] sysfs_write_file+0xa6/0x100
 [<c028a913>] vfs_write+0xa3/0x140
 [<c02cc630>] sysfs_write_file+0x0/0x100
 [<c028af61>] sys_write+0x41/0x70
 [<c020323e>] syscall_call+0x7/0xb




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
