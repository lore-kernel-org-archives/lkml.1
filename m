Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYJGP0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYJGP0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYJGP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:26:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35070 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYJGP0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:26:42 -0400
Date: Tue, 7 Oct 2008 08:26:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081007152629.GH6384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007071544.GC20740@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 09:15:44AM +0200, Andi Kleen wrote:
> > Could you please try the patch at the following URL (from Thomas
> > Gleixner)?
> > 
> > http://www.rdrop.com/users/paulmck/patches/2.6.27-rc7-tglx-timer-1.patch
> > 
> > This fixed some CPU hotplug hangs that I was seeing in 2.6.27-rc7 and
> > -rc8.  Alternatively, try 2.6.27-rc9, which seems to include Thomas's
> > patch.
> 
> Still happens with rc9.  This time with frame pointers:

Hmmm...  I chased out a number of these when doing rcutree.

This with classic RCU or preemptable RCU?

> bash          D 00000000ffff975e     0  4770   4757
>  ffff8804bcda3bf8 0000000000000082 ffff8804bcda3c18 0000000000000296
>  ffff8804bde4e6b0 ffff8804be6fc630 ffff8804bde4e8f8 0000000e00000296
>  ffff8804bcda3c18 ffffffff808cfd98 ffff880288064780 ffff88027d18ec98
> Call Trace:
>  [<ffffffff805c4915>] schedule_timeout+0x22/0xb4
>  [<ffffffff8020a009>] ? __switch_to+0x320/0x330
>  [<ffffffff802602ed>] ? cpupri_set+0xc5/0xd8
>  [<ffffffff805c476f>] wait_for_common+0xcd/0x131
>  [<ffffffff8022db87>] ? default_wake_function+0x0/0xf
>  [<ffffffff805c485d>] wait_for_completion+0x18/0x1a
>  [<ffffffff80243fbf>] synchronize_rcu+0x35/0x3c
>  [<ffffffff8024403e>] ? wakeme_after_rcu+0x0/0x12
>  [<ffffffff8022ed25>] partition_sched_domains+0x9b/0x1dd
>  [<ffffffff8022dbb3>] ? wake_up_process+0x10/0x12
>  [<ffffffff8022ee95>] update_sched_domains+0x2e/0x35
>  [<ffffffff805c8342>] notifier_call_chain+0x33/0x5b
>  [<ffffffff80249291>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff802492a2>] raw_notifier_call_chain+0xf/0x11
>  [<ffffffff805c1c3a>] _cpu_up+0xd3/0x10c
>  [<ffffffff805c1cca>] cpu_up+0x57/0x67
>  [<ffffffff805a5787>] store_online+0x4d/0x75
>  [<ffffffff803e67bb>] sysdev_store+0x1b/0x1d
>  [<ffffffff802cce10>] sysfs_write_file+0xe0/0x11c
>  [<ffffffff8028b661>] vfs_write+0xae/0x137
>  [<ffffffff8028bb0a>] sys_write+0x47/0x6f
>  [<ffffffff8020b34b>] system_call_fastpath+0x16/0x1b
> 
> BTW it also happens reliably every time. Reproduced it three times
> now. I just do
> 
> laut:~ # echo 0 > /sys/devices/system/cpu/cpu15/online 
> laut:~ # echo 0 > /sys/devices/system/cpu/cpu14/online 
> laut:~ # echo 1 > /sys/devices/system/cpu/cpu14/online 
> laut:~ # echo 1 > /sys/devices/system/cpu/cpu15/online 
> <hang>

Could you please send me your .config file?

							Thanx, Paul
