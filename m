Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZKYRac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZKYRac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbZKYRab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:30:31 -0500
Received: from lucidpixels.com ([75.144.35.66]:33358 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906AbZKYRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:30:28 -0500
Date: Wed, 25 Nov 2009 12:30:34 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: netconsole/sysklogd (un)wrapping of kernel messages?
Message-ID: <alpine.DEB.2.00.0911251224060.13062@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried using netconsole with sysklogd or syslog-ng, and in either event I 
see entries as follows:

Nov 25 12:23:25 192.168.1.2 0 12772  12765 0x00000000
Nov 25 12:23:25 192.168.1.2 00000003035d4ea8
Nov 25 12:23:25 192.168.1.2 000000000000c8e8
Nov 25 12:23:25 192.168.1.2 [122776.793261]  [<ffffffff810c29b0>] ? pollwake+0x0/0x60
Nov 25 12:23:25 192.168.1.2 [122776.793261]  [<ffffffff8144fd59>] ? _spin_lock_bh+0x9/0x20
Nov 25 12:23:25 192.168.1.2 [122776.793261]  [<ffffffff813af673>] ? release_sock+0x13/0xa0
Nov 25 12:23:25 192.168.1.2 [122776.793261]  [<ffffffff813f0a85>] ? tcp_recvmsg+0x225/0x9c0

See the first 3 lines, pieces seem to be out of place (syslog-ng).

Again with sysklogd:

Nov 25 12:19:50 l1 [122561.934261] sshd          S
Nov 25 12:19:50 l1 [122561.955377]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b 
Nov 25 12:19:50 l1 [122561.955377]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b 
Nov 25 12:19:50 l1  0000000000000000
Nov 25 12:19:50 l1  ffff8801fa6adc50

Nov 25 12:19:50 l1 [122561.934261] sshd          S
Nov 25 12:19:50 l1 [122561.955377]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b 
Nov 25 12:19:50 l1 [122561.955377]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b 
Nov 25 12:19:50 l1  0000000000000000
Nov 25 12:19:50 l1  ffff8801fa6adc50

According to this document:
http://www.novell.com/communities/node/4753/netconsole-howto-send-kernel-boot-messages-over-ethernet

Those messages appear cleanly with no splitting.

Where as mine:

Nov 24 02:17:17 l1 [    9.272986] md:  adding sda1 ... 
Nov 24 02:17:17 l1 [    9.273038] md: created md0 
Nov 24 02:17:17 l1 [    9.273083] md: bind<sda1> 
Nov 24 02:17:17 l1 [    9.273144] md: bind<sdb1> 
Nov 24 02:17:17 l1 [    9.273202] md: running: 
Nov 24 02:17:17 l1 sdb1>
Nov 24 02:17:17 l1 sda1>
Nov 24 02:17:17 l1 
Nov 24 02:17:17 l1 [    9.273453] raid1: raid set md0 active with 2 out of 2 mirrors 
Nov 24 02:17:17 l1 [    9.273519] md0: detected capacity change from 0 to 17190682624

Seem to be split all over the place.

The purpose of using netconsole is to try to catch a deadlock condition but
I am afraid if/once I do the output will be so mangled it will make it
difficult to read.

---

One way to see if its not related to sysklogd/syslog-ng is to use netcat,
trying that I get:

[123058.837271] sshd          S 0000000000000000     0 12772  12765 0x00000000
  0000000000000082 ffffea000666fbc8
[123058.837271]  000000000000ff80 000000000000c8e8 ffff88023f3f7330 ffff88023f3f75b0
[123058.837271]  000000023a66db80 00007f9a6e05c020 ffff88023f3f75b0
[123058.837271] Call Trace:
[123058.837271]  [<ffffffff81071acb>] ? getnstimeofday+0x5b/0xe0
[123058.837271]  [<ffffffff8144e5a9>] ? schedule_timeout+0x119/0x1a0
[123058.837271]  [<ffffffff81051500>] ? default_wake_function+0x0/0x10
[123058.837271]  [<ffffffff8102c52b>] ? system_call_fastpath+0x16/0x1b
[123058.837271] spawn         S 0000000000000000     0 13047   2559 0x00000000
[123058.837271]  ffff88023f890630 0000000000000082 0000000000000001 ffffea00015e7ab8
[123058.837271]  000000000000ff80 000000000000c8e8 ffff8800a5b12ed0 ffff8800a5b13150
[123058.837271]  000000010414c670 00000001074ffd1b 0000000000000286 ffff8800a5b13150

The output is much cleaner.

Is there any tweak to get this to work with sysklogd/syslog-ng so the output
is more readable?

Justin.

