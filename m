Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYGKSAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYGKSAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYGKSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:00:12 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:60510 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYGKSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HMPUsyi4iCnEntHZk3EmoB3WMX9haqeRQ1gV2einNrsHnuYiWQOtlXF4Gd8D4KoviX
         yuqKxfJR96wpY7oV/6Z2F/8woKt5KD8hg+2gmGM5WbU00eBogy3zSfglX8mCbeDoNZvJ
         uAkEhqrH2MKPai2MLnNO4WNBw1cQmJGlIX+Q4=
Message-ID: <19f34abd0807111100x301f469coe41e49d21cf26723@mail.gmail.com>
Date: Fri, 11 Jul 2008 20:00:08 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807111051q7b4a42b1l1f9ee05d45601ac3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
	 <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
	 <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
	 <19f34abd0807110404p5c588debu681aa466cc98ad08@mail.gmail.com>
	 <19f34abd0807111051q7b4a42b1l1f9ee05d45601ac3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 7:51 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Now I tested using serial console, but nothing new:
>
> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0-1
>  groups: 0 1
>  domain 1: span 0-1
>   groups: 0-1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1
>  groups: 1 0
>  domain 1: span 0-1
>   groups: 0-1
>  * [ 7 ] comm (ksoftirqd/1), orig_cpu (1), dst_cpu (1), cpu (1)
> CPU 1 is now offline
>  * [ 1228 ] comm (kjournald), orig_cpu (0), dst_cpu (0), cpu (0)
>  * [ 3113 ] comm (klogd), orig_cpu (0), dst_cpu (0), cpu (0)
> BUG: spinlock recursion on CPU#0, syslogd/3110
>
> and here the output stops. I find this REALLY strange, look at the
> spinlock recursion code:
>
>        printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
>                msg, raw_smp_processor_id(),
>                current->comm, task_pid_nr(current));
>        printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
>                        ".owner_cpu: %d\n",
>                lock, lock->magic,
>                owner ? owner->comm : "<none>",
>                owner ? task_pid_nr(owner) : -1,
>                lock->owner_cpu);
>
> why would it not be able to print the second line?

Enabling NMI watchdog gives us this additional info (whoa, what a huge
stacktrace):

BUG: spinlock recursion on CPU#0, bash/3832
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c010a5a1, registers:
Pid: 3832, comm: bash Not tainted (2.6.26-rc9-00103-g2702484 #18)
EIP: 0060:[<c010a5a1>] EFLAGS: 00200082 CPU: 0
EIP is at native_read_tsc+0x11/0x20
EAX: 4633e3b2 EBX: c06c6d00 ECX: 00000001 EDX: 00000086
ESI: 00000001 EDI: 00000000 EBP: f6307a68 ESP: f6307a68
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3832, ti=f6306000 task=f5b71fe0 task.ti=f6306000)
Stack: f6307a80 c027d6b2 00000000 c06c6d00 00360dc6 00000000 f6307a88 c027d5c9
       f6307ac0 c028b8ea c0148e0a c06da1a0 c1fd8180 c06da1a0 f6307aac 00000001
       b25fadf4 00000000 b25fadf4 c06c6d10 c06c6d00 00200092 f6307ae0 c0572cb3
Call Trace:
 [<c027d6b2>] ? delay_tsc+0x22/0xa4
 [<c027d5c9>] ? __delay+0x9/0x10
 [<c028b8ea>] ? _raw_spin_lock+0xea/0x180
 [<c0148e0a>] ? atomic_notifier_call_chain+0x1a/0x20
 [<c0572cb3>] ? _spin_lock_irqsave+0x63/0x80
 [<c01236fb>] ? __wake_up+0x1b/0x50
 [<c01236fb>] ? __wake_up+0x1b/0x50
 [<c0130885>] ? release_console_sem+0x1b5/0x1e0
 [<c01306cb>] ? wake_up_klogd+0x3b/0x40
 [<c0130899>] ? release_console_sem+0x1c9/0x1e0
 [<c0130d5c>] ? vprintk+0x29c/0x410
 [<c01187e0>] ? nmi_watchdog_tick+0x90/0x160
 [<c01063e5>] ? do_nmi+0xb5/0x2c0
 [<c05734b3>] ? nmi_stack_correct+0x26/0x2b
 [<c0130eeb>] ? printk+0x1b/0x20
 [<c028b623>] ? spin_bug+0x63/0x100
 [<c028b96c>] ? _raw_spin_lock+0x16c/0x180
 [<c0148e0a>] ? atomic_notifier_call_chain+0x1a/0x20
 [<c01236fb>] ? __wake_up+0x1b/0x50
 [<c0572cb3>] ? _spin_lock_irqsave+0x63/0x80
 [<c01236fb>] ? __wake_up+0x1b/0x50
 [<c01236fb>] ? __wake_up+0x1b/0x50
 [<c0130885>] ? release_console_sem+0x1b5/0x1e0
 [<c01306cb>] ? wake_up_klogd+0x3b/0x40
 [<c0130899>] ? release_console_sem+0x1c9/0x1e0
 [<c0130d5c>] ? vprintk+0x29c/0x410
 [<c0123c20>] ? enqueue_entity+0x70/0x210
 [<c0124dc0>] ? enqueue_task_fair+0x40/0x50
 [<c0124830>] ? try_to_wake_up+0x120/0x2b0
 [<c0130eeb>] ? printk+0x1b/0x20
 [<c0124877>] ? try_to_wake_up+0x167/0x2b0
 [<c01249cb>] ? default_wake_function+0xb/0x10
 [<c0143fdb>] ? autoremove_wake_function+0x1b/0x50
 [<c01214d8>] ? __wake_up_common+0x48/0x70
 [<c0123717>] ? __wake_up+0x37/0x50
 [<c01306cb>] ? wake_up_klogd+0x3b/0x40
 [<c0130899>] ? release_console_sem+0x1c9/0x1e0
 [<c0130d5c>] ? vprintk+0x29c/0x410
 [<c0130dc9>] ? vprintk+0x309/0x410
 [<c0152bc5>] ? mark_held_locks+0x65/0x80
 [<c05710e5>] ? __mutex_unlock_slowpath+0xb5/0x150
 [<c0130eeb>] ? printk+0x1b/0x20
 [<c0109998>] ? alternatives_smp_switch+0x18/0x1b0
 [<c0130eeb>] ? printk+0x1b/0x20
 [<c01170a4>] ? __cpu_die+0x74/0x80
 [<c054f75a>] ? _cpu_down+0x13a/0x240
 [<c0158baf>] ? cpu_maps_update_begin+0xf/0x20
 [<c054f88b>] ? cpu_down+0x2b/0x40
 [<c0550aa9>] ? store_online+0x39/0x80
 [<c0550a70>] ? store_online+0x0/0x80
 [<c02f1e7b>] ? sysdev_store+0x2b/0x40
 [<c01d56f2>] ? sysfs_write_file+0xa2/0x100
 [<c01972e6>] ? vfs_write+0x96/0x130
 [<c01d5650>] ? sysfs_write_file+0x0/0x100
 [<c01979ad>] ? sys_write+0x3d/0x70
 [<c01042a1>] ? sysenter_past_esp+0x6a/0xb1
 =======================
Code: 56 30 17 00 5d c3 8d 74 26 00 e6 ed 5d c3 90 90 90 90 90 90 90 90 90 90 90
 90 55 89 e5 8d 76 00 0f ae e8 0f 31 8d 76 00 0f ae e8 <5d> c3 8d b6 00 00 00 00
 8d bc 27 00 00 00 00 55 89 e5 57 89 c7

I don't know if it helps too much, but I think it can't really be
anything but the printk()s from sched code...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
