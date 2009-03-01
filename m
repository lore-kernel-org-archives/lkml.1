Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZCAIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZCAIkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZCAIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:39:55 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:46057 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZCAIjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=onTBZLyaImf1PE13rV5mIRjjhKh/FbrxFv5UmmYWkivvTasIxBzshXs+2hp9J/sINQ
         pc5TUK8h5Ybmtd7OzuBa66t2Px/Vzk4vuSnTcQDfYM+2TweVBl32Ye0VcfBb7ciTrsVB
         kvh9bItor4VHqFogHMVrXMKVwnvSjULjhm6ps=
MIME-Version: 1.0
In-Reply-To: <20090301002758.GA23465@silver.sucs.org>
References: <20090301002758.GA23465@silver.sucs.org>
Date: Sun, 1 Mar 2009 09:39:50 +0100
Message-ID: <19f34abd0903010039t23d669bck476066e571a316e@mail.gmail.com>
Subject: Re: kmemcheck warnings (con_font_op, fuse_open_common)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/1 Sitsofe Wheeler <sitsofe@yahoo.com>:
> Hi,
>
> I've run kmemcheck with the latest -tip and most of the warnings I was
> getting have now died down. However dmesg seems to have warnings that
> look somewhat legitimate now (and there are quite a few). Further after
> a suspend to ram/resume one particular warning related to worker_thread
> started appearing over and over. For now I've attached a slightly
> modified dmesg below to see what you think:

You did suspend to ram/resume with kmemcheck!? And it worked? WOW! :-D

>
> [  311.763018] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f61a2000)
> [  311.764060] ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
> [  311.768152]  u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
> [  311.772241]  ^
> [  311.772526]
> [  311.772794] Pid: 952, comm: usplash Not tainted (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> [  311.773826] EIP: 0060:[<c022dd9c>] EFLAGS: 00013246 CPU: 0
> [  311.774550] EIP is at __copy_to_user_ll+0x3c/0x60
> [  311.779612]  [<c022e2ee>] copy_to_user+0x3e/0x60
> [  311.780335]  [<c028e1b0>] con_font_op+0x290/0x3f0

This one is very likely a real information leak, because it does a
copy to userspace (and the only way this can . On the other hand, the
memory _does_ look like it's been initialized (all 0xff). IIRC, I
tracked this one down to an overlong copy in vgacon before. But I'd
have to look at it again...

> [  312.284024] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6141020)
> [  312.284037] 0000000000000000000000000000000000000000000000000000000000000000
> [  312.284216]  u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
> [  312.284391]  ^
> [  312.284398]
> [  312.284408] Pid: 952, comm: usplash Not tainted (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> [  312.284418] EIP: 0060:[<c01336e7>] EFLAGS: 00013002 CPU: 0
> [  312.284433] EIP is at __dequeue_signal+0xb7/0x140

This is in general a false positive. This case looks a little
different from what I've seen here, though.

> [  312.507181] Clocksource tsc unstable (delta = -323547439 ns)
> [  693.961129] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
> [  810.827319] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
> [ 1180.591187] wlan0: authenticate with AP 00:1e:4a:07:5a:e0
> [ 1180.597257] wlan0: authenticated
> [ 1180.597308] wlan0: associate with AP 00:1e:4a:07:5a:e0
> [ 1180.603284] wlan0: RX AssocResp from 00:1e:4a:07:5a:e0 (capab=0x431 status=0 aid=230)
> [ 1180.603322] wlan0: associated
> [ 1285.719745] wlan0: deauthenticating by local choice (reason=3)
> [ 1621.988331] ath5k 0000:01:00.0: PCI INT A disabled
> [ 1795.445030] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f61b2800)
> [ 1795.445044] 0000000000000000000000000000000000000000000000000000000000000000
> [ 1795.445089]  u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
> [ 1795.445130]  ^
> [ 1795.445133]
> [ 1795.445139] Pid: 3898, comm: gvfs-fuse-daemo Not tainted (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> [ 1795.445146] EIP: 0060:[<c0200bd9>] EFLAGS: 00010246 CPU: 0
> [ 1795.445159] EIP is at fuse_file_alloc+0x69/0x90

Hm. This is a false positive too. RB_CLEAR_NODE() will do a read on
the uninitialized value before writing back the new parent pointer
(colour remains uninitialized, however). I suspect that we could get
away with changing RB_CLEAR_NODE() to just set the colour to 0 at the
same time.

> [ 1797.140033] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6141410)
> [ 1797.140048] 0000000080000000000000000000000001000000000000001700000000000000
> [ 1797.140092]  i i i i i i i i i i i i i i i i u u u u u u u u u u u u u u u u
> [ 1797.140132]                                  ^
> [ 1797.140136]
> [ 1797.140142] Pid: 4401, comm: gnome-screensav Not tainted (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> [ 1797.140148] EIP: 0060:[<c01336e7>] EFLAGS: 00013002 CPU: 0
> [ 1797.140161] EIP is at __dequeue_signal+0xb7/0x140

False positive, same as above. copy_signal() is doing an overlong copy-to-stack.

> [ 2095.496861] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
> [ 2095.607653] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
> [ 2095.607882] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 2095.608010] ath5k 0000:01:00.0: setting latency timer to 64
> [ 2095.610565] ath5k 0000:01:00.0: registered as 'phy1'
> [ 2095.966861] wmaster0 (ath5k): not using net_device_ops yet
> [ 2096.078220] phy1: Selected rate control algorithm 'minstrel'
> [ 2096.093008] wlan0 (ath5k): not using net_device_ops yet
> [ 2096.206424] ath5k phy1: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> [ 2592.398898] serio: i8042 KBD port at 0x60,0x64 irq 1
> [ 2592.399251] serio: i8042 AUX port at 0x60,0x64 irq 12
> [ 2592.488899] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio1/input/input6
> [ 2594.800009] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio2/input/input7
> <snip>
> [ 4217.224759] PM: resume devices took 190.893 seconds
> [ 4217.226777] PM: Finishing wakeup.
> [ 4217.226781] Restarting tasks ... done.
> [ 4242.001274] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6212b58)
> [ 4242.001288] 434327c000dc86f601e733f71ce733f71ce733f7323a25c030a113c05c170000
> [ 4242.001331]  i i i i i i i i i i i i i i i i i i i i i i i i u u u u u u u u
> [ 4242.001370]                                                  ^
> [ 4242.001375]
> [ 4242.001381] Pid: 131, comm: kacpid Tainted: G        W  (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> [ 4242.001387] EIP: 0060:[<c0139090>] EFLAGS: 00010087 CPU: 0
> [ 4242.001400] EIP is at run_workqueue+0xc0/0x210

Now this one is completely new to me. I will see if I can reproduce it here.

> [ 4242.001576] EIP is at run_workqueue+0xc6/0x210
> [ 4242.001743] EIP is at run_workqueue+0xcc/0x210
> [ 4243.495441] EIP is at __dequeue_signal+0xb7/0x140
> [ 4273.001347] EIP is at run_workqueue+0xc0/0x210
> [ 4273.001522] EIP is at run_workqueue+0xc6/0x210
> [ 4273.001689] EIP is at run_workqueue+0xcc/0x210

Thanks for the report! I will try to fix the false positives (by
annotating the code paths in question), and investigate the rest. It's
a bit sad to see that we (still) have such a high false-positive rate,
but it can't really be helped.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
