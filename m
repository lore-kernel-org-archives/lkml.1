Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbZICWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbZICWsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbZICWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:48:45 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59315 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbZICWso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lNfilGCJYRxOT7rokhdXrdmqgwYchIVvtmOTN5KasQhf1qM3gpFmpSvFNsn8pN0u7F
         IUm/KlYWmjsPijaiIV/dH+F8NhhH7sAGmGX1Cs2Q3nbAPsdBcsAf3eR7PAl1UauxcnlU
         Eah0rQRq0jH/vjjHYoJPnLsUe3k+ok7j0xwLs=
MIME-Version: 1.0
In-Reply-To: <20080808082930.ZZRA012@mailhub.coreip.homeip.net>
References: <c4e36d110807310241n512b01e4v898e883d740de879@mail.gmail.com>
	 <20080731145739.fe8923be.akpm@linux-foundation.org>
	 <20080801030444.GB18953@anvil.corenet.prv>
	 <1218192589.8625.88.camel@twins>
	 <20080808082930.ZZRA012@mailhub.coreip.homeip.net>
Date: Fri, 4 Sep 2009 00:48:45 +0200
Message-ID: <c4e36d110909031548y38276e0cjfc5eee7bfdba8e50@mail.gmail.com>
Subject: Re: INFO: possible recursive locking detected ps2_command
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Fri, Aug 08, 2008 at 12:49:49PM +0200, Peter Zijlstra wrote:
>> On Thu, 2008-07-31 at 23:04 -0400, Dmitry Torokhov wrote:
>> > On Thu, Jul 31, 2008 at 02:57:39PM -0700, Andrew Morton wrote:
>> > >
>> > > (cc linux-input)
>> > >
>> > > On Thu, 31 Jul 2008 11:41:25 +0200
>> > > "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
>> > >
>> > > > Hi
>> > > >
>> > > > During mouse unplugging from psaux connector from the laptops' docking
>> > > > station I've got attached INFO trace.
>> > > > (laptops still has synaptics device)
>> > > >
>> >
>> > Dell?
>> >
>> > > > Also for unknown reason to me  psaux mouse & synaptic device do not
>> > > > work somehow together - is it hw limitation
>> > > > of /dev/input/mice  interface?
>> > > > (USB mouse and synaptics do work quite well together)
>> > > >
>> > > > [ INFO: possible recursive locking detected ]
>> > > > 2.6.27-rc1 #48
>> > >
>> > > (it's 2.6.27-rc1)
>> > >
>> >
>> > Peter, here is the trace we talked about long time ago. For some reason
>> > lockdep annotation only works once. If reconnect is forced or psmouse
>> > module is reloaded lockdep starts complaining about passthrough port.
>>
>> Bit puzzling - and I don't have any ps2 hardware around to test with
>> (nor do I normally use modules - but that is fixable of course).
>>
>> Does Rabin's patch help?
>>
>>   http://lkml.org/lkml/2008/8/7/329
>>
>
> I doubt it resolves problem fully because it only takes care of module
> unload. I can easily trip lockdep by reconnecting the device. Just to
> give some more details about the problem:
>
>  - synaptics touchpads have a pass-through port that allows to connect
>   either external mouse or maybe a trackpoint device. Both devices
>   are represented by 'serio' structures and are handled by the same
>   driver (psmouse).
>
>  - as far as I know we have proper locking there and lockdep
>   annotatinos were added to lockdep to reflect the nesting of the
>   serio ports.
>
>  - if child port (pass-through port) is destroyed and recreated (due
>   to module unload, or because user requested reconnect through sysfs
>   or system-initiated reconnect) lockdep starts complaining although
>   the new child port should still have the same "depth" as the old
>   one.
>

Well just noticed this issue again in my log - during resume operation
- thus no external mouse connection in the game this time:

platform dock.2: completing resume
platform dock.1: completing resume
platform dock.0: completing resume
PM: Finishing wakeup.
Restarting tasks ... done.
PM: Removing info for No Bus:vcs63
PM: Removing info for No Bus:vcsa63
psmouse.c: Failed to enable mouse on isa0060/serio1
PM: Removing info for No Bus:mouse1
PM: Removing info for No Bus:event8
PM: Removing info for No Bus:input8

=============================================
[ INFO: possible recursive locking detected ]
2.6.31-rc8-00043-gf2332bf #30
---------------------------------------------
kseriod/207 is trying to acquire lock:
 (&ps2dev->cmd_mutex){+.+...}, at: [<ffffffff8132675b>] ps2_command+0x5b/0x470

but task is already holding lock:
 (&ps2dev->cmd_mutex){+.+...}, at: [<ffffffff8132675b>] ps2_command+0x5b/0x470

other info that might help us debug this:
4 locks held by kseriod/207:
 #0:  (serio_mutex){+.+.+.}, at: [<ffffffff8132453e>] serio_thread+0x3e/0x400
 #1:  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff81323b00>]
serio_connect_driver+0x30/0x60
 #2:  (psmouse_mutex){+.+.+.}, at: [<ffffffffa00c5f85>]
psmouse_connect+0x35/0x370 [psmouse]
 #3:  (&ps2dev->cmd_mutex){+.+...}, at: [<ffffffff8132675b>]
ps2_command+0x5b/0x470

stack backtrace:
Pid: 207, comm: kseriod Not tainted 2.6.31-rc8-00043-gf2332bf #30
Call Trace:
 [<ffffffff8107f0ba>] __lock_acquire+0xe6a/0x1090
 [<ffffffff8107f37a>] lock_acquire+0x9a/0x180
 [<ffffffff8132675b>] ? ps2_command+0x5b/0x470
 [<ffffffff813da81f>] __mutex_lock_common+0x5f/0x4a0
 [<ffffffff8132675b>] ? ps2_command+0x5b/0x470
 [<ffffffff8100f4b8>] ? dump_trace+0x118/0x2f0
 [<ffffffff8132675b>] ? ps2_command+0x5b/0x470
 [<ffffffff813dad41>] mutex_lock_nested+0x41/0x50
 [<ffffffff8132675b>] ps2_command+0x5b/0x470
 [<ffffffffa00c47b3>] psmouse_sliced_command+0x33/0x90 [psmouse]
 [<ffffffffa00c6a9c>] synaptics_pt_write+0x2c/0x60 [psmouse]
 [<ffffffff81326636>] ps2_sendbyte+0x66/0x130
 [<ffffffff8107d7ed>] ? trace_hardirqs_on_caller+0x15d/0x1a0
 [<ffffffff8107d83d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff813267f9>] ps2_command+0xf9/0x470
 [<ffffffff8107d83d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff813dcbbb>] ? _spin_unlock_irq+0x3b/0x60
 [<ffffffffa00c494c>] psmouse_probe+0x2c/0xa0 [psmouse]
 [<ffffffff81323d86>] ? serio_open+0x16/0x50
 [<ffffffffa00c6108>] psmouse_connect+0x1b8/0x370 [psmouse]
 [<ffffffff81323b0b>] serio_connect_driver+0x3b/0x60
 [<ffffffff81323b50>] serio_driver_probe+0x20/0x30
 [<ffffffff812d2379>] driver_probe_device+0x89/0x180
 [<ffffffff812d2520>] ? __device_attach+0x0/0x60
 [<ffffffff812d2573>] __device_attach+0x53/0x60
 [<ffffffff812d13dc>] bus_for_each_drv+0x6c/0xa0
 [<ffffffff812d2639>] device_attach+0x89/0x90
 [<ffffffff81323cbd>] serio_find_driver+0x1d/0x50
 [<ffffffff813240c7>] serio_reconnect_port+0x57/0x90
 [<ffffffff81324758>] serio_thread+0x258/0x400
 [<ffffffff81069540>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81324500>] ? serio_thread+0x0/0x400
 [<ffffffff810690e6>] kthread+0xa6/0xb0
 [<ffffffff8100d2da>] child_rip+0xa/0x20
 [<ffffffff8100cc40>] ? restore_args+0x0/0x30
 [<ffffffff81069040>] ? kthread+0x0/0xb0
 [<ffffffff8100d2d0>] ? child_rip+0x0/0x20
