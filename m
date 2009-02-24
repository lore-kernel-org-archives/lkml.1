Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbZBXOkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbZBXOkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZBXOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:40:45 -0500
Received: from web30107.mail.mud.yahoo.com ([209.191.69.39]:25260 "HELO
	web30107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755330AbZBXOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:40:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=ox7rMSHunSIr2i1Bjx06Gd2XNLJ+xMIdA6vZ6xOZIBm38aiaqDz8b5e9ksayg6iZ1uLEFCHBoexxYTUFDHF+o8N9wAHzX65nACoSaBWNbKq/VKUthxDUuHlENPVXDZlHxfOQVKaP3IfDuUmO55CjV1Wr7x6Wo7rlMyuOUk9xiN8=;
Message-ID: <74923.15071.qm@web30107.mail.mud.yahoo.com>
X-YMail-OSG: WxIkqBAVM1nnFhWgPxEmig10Z4JU0.TkYBDAqSWd4RnoW7rGco6QgN1pZ77sWG.ryZNx_odRUS.dvEjdomjFG46ixAFalp__QoRGlHzMF8d3Joja8mdk_Wnylve9xq_blQmnlhlGMyjBaX7JCIKtsGczwj.lyySISe.dsjd_GIxNDudr8QqHUAFnMJg4wbd0qCSXxdJE_N0gcNZKT4EXqYWDOpB_How-
X-Mailer: YahooMailClassic/5.1.18 YahooMailWebService/0.7.289.1
Date: Tue, 24 Feb 2009 06:40:42 -0800 (PST)
From: Parav Pandit <paravpandit@yahoo.com>
Subject: Suspected sock_sendmsg() with MSG_DONTWAIT can block bug.
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I am running kernel 2.6.23 from www.kernel.org.

Short quick question:
---------------------
If sock_sendmsg() is calls with MSG_DONTWAIT, it should send the packet without blocking the context or fail the call with error value.

Which means sock_sendmsg() with MSG_DONTWAIT can be called from soft-irq/ interrupt ctx.
Is that correct?

Assuming its correct, long question:
-----------------------------------

One function of my kernel module looks like

msg_hdr.flags = MSG_DONTWAIT;
spin_lock(lock)
....
sock_sendmsg(sock, msg_hdr, len);
spin_unlock(lock);

I am getting following warning,
BUG: sleeping function called from invalid context at net/core/sock.c:1586

Indicating it can sleep. Here is the back trace of sock_sendmsg() with MSG_DONTWAIT. Is this bug or expected behavior?

Feb 24 19:26:16 localhost kernel: BUG: sleeping function called from invalid context at net/core/sock.c:1586
Feb 24 19:26:16 localhost kernel: in_atomic():1, irqs_disabled():0
Feb 24 19:26:16 localhost kernel:  [<c06c4115>] lock_sock_nested+0x18/0x9e
Feb 24 19:26:16 localhost kernel:  [<c0432632>] local_bh_disable+0xa/0xb
Feb 24 19:26:16 localhost kernel:  [<c06c407c>] release_sock+0x13/0x94
Feb 24 19:26:16 localhost kernel:  [<c06f7afb>] tcp_sendmsg+0x15/0xa21
Feb 24 19:26:16 localhost kernel:  [<c04323b0>] irq_exit+0x50/0x72
Feb 24 19:26:16 localhost kernel:  [<c06c2379>] sock_sendmsg+0xd0/0xeb
Feb 24 19:26:16 localhost kernel:  [<c043eacc>] autoremove_wake_function+0x0/0x35
Feb 24 19:26:16 localhost kernel:  [<c0425e0d>] resched_task+0x3b/0x59
Feb 24 19:26:16 localhost kernel:  [<c0751efe>] _spin_unlock_irqrestore+0x1c/0x30
Feb 24 19:26:16 localhost kernel:  [<c0427c18>] try_to_wake_up+0x2e6/0x2f0
Feb 24 19:26:16 localhost kernel:  [<c043eae1>] autoremove_wake_function+0x15/0x35
Feb 24 19:26:16 localhost kernel:  [<c0424643>] __wake_up_common+0x32/0x55
Feb 24 19:26:16 localhost kernel:  [<f8f9b53e>] send+0xce/0x110 [test_driver]
Feb 24 19:26:16 localhost kernel:  [<f8f9bc16>] drv_tx+0xe6/0x110 [test_driver]
Feb 24 19:26:16 localhost kernel:  [<f8f9c07d>] drv_ctrl_msg+0x7d/0xb0 [test_driver]
Feb 24 19:26:16 localhost kernel:  [<c08be000>] __init_begin+0x0/0x10
Feb 24 19:26:16 localhost kernel:  [<f8fa64ad>] io_thread+0xed/0x1d0 [test_driver]
Feb 24 19:26:16 localhost kernel:  [<f8fa63c0>] io_thread+0x0/0x1d0 [test_driver]
Feb 24 19:26:16 localhost kernel:  [<c0405d47>] kernel_thread_helper+0x7/0x10

Regards,
Parav Pandit





      
