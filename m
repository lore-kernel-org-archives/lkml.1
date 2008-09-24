Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYIXTSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYIXTSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYIXTSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:18:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:32867 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYIXTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cGrcv5JSQSrWXjDXvUkc0OmjKOuvwvY/GcLFbs+7YBufX4ffovQO9CqIYJAq1dTtfr
         c+a7QuopLZXW+tkYFHdBS+UslBnMEy8vfbL+YeGEyNyyijXD4cGGiz0NiHUCpyL/ckkV
         1a6TGKe0+dU/u+Q4bLvt9Ao0Qiz2NXX+dgZ38=
Date: Wed, 24 Sep 2008 22:17:58 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
Subject: possible recursive locking in ps2_command
Message-ID: <20080924191756.GA20149@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following on resume on my T60p, this might indicate
a potential deadlock I think.

[33491.050660] psmouse.c: Failed to enable mouse on isa0060/serio1
[33491.054938] PM: Removing info for No Bus:mouse1
[33491.064134] PM: Removing info for No Bus:event8
[33491.080154] PM: Removing info for No Bus:input8
[33491.089117]
[33491.089120] =============================================
[33491.089128] [ INFO: possible recursive locking detected ]
[33491.089133] 2.6.27-rc7-mst #53
[33491.089137] ---------------------------------------------
[33491.089141] kseriod/147 is trying to acquire lock:
[33491.089146]  (&ps2dev->cmd_mutex){--..}, at: [<c028cdf3>] ps2_command+0x43/0x3a0
[33491.089162] 
[33491.089163] but task is already holding lock:
[33491.089168]  (&ps2dev->cmd_mutex){--..}, at: [<c028cdf3>] ps2_command+0x43/0x3a0
[33491.089179] 
[33491.089180] other info that might help us debug this:
[33491.089185] 4 locks held by kseriod/147:
[33491.089189]  #0:  (serio_mutex){--..}, at: [<c028b612>] serio_thread+0x22/0x340
[33491.089204]  #1:  (&serio->drv_mutex){--..}, at: [<c028aad4>] serio_connect_driver+0x24/0x50
[33491.089218]  #2:  (psmouse_mutex){--..}, at: [<f8a355ca>] psmouse_connect+0x1a/0x250 [psmouse]
[33491.089246]  #3:  (&ps2dev->cmd_mutex){--..}, at: [<c028cdf3>] ps2_command+0x43/0x3a0
[33491.089259] 
[33491.089260] stack backtrace:
[33491.089266] Pid: 147, comm: kseriod Not tainted 2.6.27-rc7-mst #53
[33491.089272]  [<c014b924>] validate_chain+0xbd4/0xeb0
[33491.089282]  [<c014978a>] ? find_usage_backwards+0x1a/0x100
[33491.089293]  [<c014be39>] __lock_acquire+0x239/0x950
[33491.089301]  [<c014ae10>] ? validate_chain+0xc0/0xeb0
[33491.089311]  [<c014c5ae>] lock_acquire+0x5e/0x80
[33491.089319]  [<c028cdf3>] ? ps2_command+0x43/0x3a0
[33491.089327]  [<c033163f>] mutex_lock_nested+0x9f/0x270
[33491.089337]  [<c028cdf3>] ? ps2_command+0x43/0x3a0
[33491.089346]  [<c028cdf3>] ? ps2_command+0x43/0x3a0
[33491.089354]  [<c014be39>] ? __lock_acquire+0x239/0x950
[33491.089363]  [<c028cdf3>] ps2_command+0x43/0x3a0
[33491.089371]  [<c014a4cb>] ? mark_held_locks+0x6b/0x80
[33491.089389]  [<f8a34682>] psmouse_sliced_command+0x22/0x70 [psmouse]
[33491.089404]  [<c014a634>] ? trace_hardirqs_on_caller+0xc4/0x150
[33491.089418]  [<f8a36ffe>] synaptics_pt_write+0x1e/0x50 [psmouse]
[33491.089433]  [<c028cbcb>] ps2_sendbyte+0x3b/0x100
[33491.089440]  [<c014a634>] ? trace_hardirqs_on_caller+0xc4/0x150
[33491.089450]  [<c014a6cb>] ? trace_hardirqs_on+0xb/0x10
[33491.089459]  [<c028ce89>] ps2_command+0xd9/0x3a0
[33491.089467]  [<c014a6cb>] ? trace_hardirqs_on+0xb/0x10
[33491.089476]  [<c0332ed2>] ? _spin_unlock_irq+0x22/0x30
[33491.089492]  [<f8a347bd>] psmouse_probe+0x1d/0xa0 [psmouse]
[33491.089508]  [<f8a356ee>] psmouse_connect+0x13e/0x250 [psmouse]
[33491.089539]  [<c028aadb>] serio_connect_driver+0x2b/0x50
[33491.089557]  [<c028ab16>] serio_driver_probe+0x16/0x20
[33491.089565]  [<c0278c54>] driver_probe_device+0x84/0x180
[33491.089574]  [<c0332a2d>] ? _spin_unlock+0x1d/0x20
[33491.089584]  [<c0323013>] ? klist_next+0x63/0xa0
[33491.089593]  [<c0278dd8>] __device_attach+0x8/0x10
[33491.089602]  [<c0278047>] bus_for_each_drv+0x47/0x70
[33491.089610]  [<c0278e7e>] device_attach+0x6e/0x80
[33491.089618]  [<c0278dd0>] ? __device_attach+0x0/0x10
[33491.089628]  [<c028ab34>] serio_find_driver+0x14/0x50
[33491.089636]  [<c028ae36>] ? serio_disconnect_port+0x56/0x60
[33491.089646]  [<c028af02>] serio_reconnect_port+0x52/0x80
[33491.089654]  [<c028b89c>] serio_thread+0x2ac/0x340
[33491.089662]  [<c014a6cb>] ? trace_hardirqs_on+0xb/0x10
[33491.089672]  [<c013be80>] ? autoremove_wake_function+0x0/0x50
[33491.089681]  [<c028b5f0>] ? serio_thread+0x0/0x340
[33491.089691]  [<c013bb82>] kthread+0x42/0x70
[33491.089697]  [<c013bb40>] ? kthread+0x0/0x70
[33491.089705]  [<c010489b>] kernel_thread_helper+0x7/0x1c
[33491.089714]  =======================

