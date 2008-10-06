Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYJFXb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYJFXb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYJFX2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:28:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35332 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbYJFX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:28:40 -0400
Date: Tue, 7 Oct 2008 01:28:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       dipankar@in.ibm.com, paulmck@us.ibm.com
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081006232837.GA1157@basil.nowhere.org>
References: <20081006141220.GA14160@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006141220.GA14160@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[modifying subject]

On Mon, Oct 06, 2008 at 04:12:20PM +0200, Andi Kleen wrote:
> [Rafael, something for the regression list]
> 
> While testing cpu hotunplug/hotreplug (first 
> setting two CPUs to offline and then to online again) on a 16 thread machine
> with 2.6.27rc8 the first 
> 
> # echo 1 > ./devices/system/cpu/cpu14/online
> 
> after hotunplug deadlocked somewhere in the scheduler:

I let it run for longer and I ended up with more and more processes
stuck in synchronize_rcu(). No more backtraces because the system
has no console and is now not able to write to disk anymore.

So it seems like there's something broken with RCU & cpu hotplug
in 2.6.28rc8. cc Paul.

It's probably not the scheduler, sorry for blaming it earlier.

-Andi

> bash          D 00000000ffffcb5b     0  4683   4671
>  ffff8804bc583c68 0000000000000086 ffff8804bc9d8640 0000000000000296
>  ffff8804bdd34730 ffff8804be6fc090 ffff8804bdd34978 0000000c805a1e2a
>  ffff8804be4fd780 ffffffff802298b4 ffffffff808acd98 ffff88027d0b1168
> Call Trace:
>  [<ffffffff802298b4>] __dequeue_entity+0x25/0x68
>  [<ffffffff805a1b4b>] schedule_timeout+0x1e/0xad
>  [<ffffffff8022a11f>] __disable_runtime+0x57/0x155
>  [<ffffffff8025cc47>] cpupri_set+0xbe/0xcd
>  [<ffffffff805a19b3>] wait_for_common+0xcd/0x131
>  [<ffffffff8022c918>] default_wake_function+0x0/0xe
>  [<ffffffff80241f3a>] synchronize_rcu+0x30/0x36
>  [<ffffffff80241fac>] wakeme_after_rcu+0x0/0xc
>  [<ffffffff8022dab6>] partition_sched_domains+0x9b/0x1dd
>  [<ffffffff8022dc26>] update_sched_domains+0x2e/0x35
>  [<ffffffff805a5297>] notifier_call_chain+0x29/0x4c
>  [<ffffffff8059ef76>] _cpu_up+0xd0/0x10a
>  [<ffffffff8059f004>] cpu_up+0x54/0x61
>  [<ffffffff805837d5>] store_online+0x43/0x67
>  [<ffffffff802c51e9>] sysfs_write_file+0xd2/0x110
>  [<ffffffff8028656b>] vfs_write+0xad/0x136
>  [<ffffffff802869f3>] sys_write+0x45/0x6e
>  [<ffffffff8020b22b>] system_call_fastpath+0x16/0x1b
> 
> It just hung forever, but the machine was otherwise fully functional.
> 
> This was without frame pointers so the backtrace presumably has
> some garbage. Haven't looked too closely.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com

-- 
ak@linux.intel.com
