Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYCWHX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYCWHX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYCWHXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:23:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:43375 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYCWHXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mcLE+7On2QqrxEXROrgExwMArSaFHq4v5vY4pRfoODmBThBrjt9c5YEv1nGCf8JDK4yFF79W4JrjIW/voCCskAuNGVkB0K9ps+hi/HhIAok//eM3oCgv9GKvuiRnA4bU1v6HBxI35a4PkAswwpTeu2OtLW4O8Xa1uPB1VwrUY1g=
Message-ID: <89cb5ede0803230023h49563614h57cad4a25d7753a4@mail.gmail.com>
Date: Sun, 23 Mar 2008 10:23:20 +0300
From: "Khaled Al-Hamwi" <khaled.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: spinlock BUG in qdisc_restart
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am doing experimental work on the bcm5700 network driver. I am using
3Com NICs. My machine has two NICs. The machine is simply forwarding
the incoming packets from one NIC to the other one.
I want to process all the incoming packets at the interrupt level and
not using softirqs. I changed the call sequence accordingly in the
bcm5700 driver.

I got the following bug and the system hanged (I got this from
/var/log/messages):

BUG: spinlock trylock failure on UP on CPU#0, swapper/0
lock: d11f014c, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
[<c01bec44>] _raw_spin_trylock+0x37/0x3b
[<c02d6343>] _spin_trylock+0x5/0xe
[<c0291117>] qdisc_restart+0x3c/0x1b5
[<c0284038>] dev_queue_xmit+0xf2/0x207
[<c029fb25>] ip_output+0x1cc/0x224
[<c029e1a7>] ip_forward+0x383/0x3e2
[<c029cf2f>] ip_rcv+0x38e/0x3ea
[<c02845af>] netif_receive_skb+0x1fc/0x23e
[<e033b560>] MM_IndicateRxPackets+0x2be/0x379 [bcm5700]
[<e0342c26>] LM_ServiceInterrupts+0xac/0xc5 [bcm5700]
[<e0337768>] bcm5700_interrupt+0x13c/0x2bd [bcm5700]
[<c0135ce2>] handle_IRQ_event+0x23/0x4c
[<c0135d85>] __do_IRQ+0x7a/0xcd
[<c0103eea>] do_IRQ+0x5c/0x77
=======================
[<c0102d6a>] common_interrupt+0x1a/0x20
[<c02d007b>] unix_sock_destructor+0x4a/0xb3
[<c02d6402>] _spin_unlock_irqrestore+0xa/0xc


I tried different things to solve this issue like using tasklets for
transmitting packets instead of transmitting them directly. Every time
I get a different bug or kernel panic :(
I tried also one suggestion from the mailing list of using spin_trylock_irqsave
and spin_trylock_irqrestore. But that also did not solve the problem.

The problem is that function qdisc_restart is being preempted and
called again on the same CPU. I have only one CPU core and I am using
kernel 2.6.15.
It seems to me that the interrupts initiated by the NIC driver are the
reason for this. But, From the driver code, I can see that the
interrupts are disabled before calling MM_IndicateRxPackets. This
function is responsible for processing the packets and calling
netif_receive_skb for further processing (look at the trace). I got
also this error:
Dead loop on netdevice eth0, fix it urgently!

Is there any other source for preempting qdisc_restart other than
hadware interrupts from the NIC? Is it possible that having two NICs
in this setup is causing this problem? Any ideas or suggestions are
appreciated.

Please, CC me when replying to this message.

Thanks,
Khaled
