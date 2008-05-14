Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYENRIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYENRIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYENRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:08:05 -0400
Received: from stinky.trash.net ([213.144.137.162]:47059 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYENRIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:08:02 -0400
Message-ID: <482B1C70.5070005@trash.net>
Date: Wed, 14 May 2008 19:08:00 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Gustavo Guillermo Perez <gustavo@compunauta.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 20/37] {nfnetlink, ip, ip6}_queue: fix skb_over_panic
 when enlarging packets
References: <20080513200453.064446337@mini.kroah.org> <877idxdb04.fsf@natisbad.org> <20080513220627.GA18320@suse.de> <200805141145.09563.gustavo@compunauta.com>
In-Reply-To: <200805141145.09563.gustavo@compunauta.com>
Content-Type: multipart/mixed;
 boundary="------------080904050307060301040203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080904050307060301040203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Gustavo Guillermo Perez wrote:
> El Martes, 13 de Mayo de 2008, Greg KH escribió:
>> On Wed, May 14, 2008 at 01:45:15AM +0200, Arnaud Ebalard wrote:
>>> Hi,
>>>
>>> Greg KH <gregkh@suse.de> writes:
>>>> 2.6.25-stable review patch.  If anyone has any objections, please let
>>>> us know.
>>> Sorry for the noise, but for those who missed one of the latest post on
>>> the topic on netdev, I should add that the bug is also in 2.6.24.4 (even
>>> if it's probably too late for that poor guy :-( ).
>> Sorry, yes, we are no longer doing 2.6.24-stable releases.
 >
> the fix will be available in 2.6.25.4 ?

Yes. This is the patch against the latest 2.6.24.x release in case
someone needs it. Not sure anymore if it differs from the 2.6.25
version.



--------------080904050307060301040203
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 431e3757dbafdad741ef7d9bdaa2fca7fce3d5cc
Author: Arnaud Ebalard <arno@natisbad.org>
Date:   Tue May 6 13:03:59 2008 +0200

    [NETFILTER]: {nfnetlink,ip,ip6}_queue: fix skb_over_panic when enlarging packets
    
    Upstream commit 9a732ed6d:
    
    While reinjecting *bigger* modified versions of IPv6 packets using
    libnetfilter_queue, things work fine on a 2.6.24 kernel (2.6.22 too)
    but I get the following on recents kernels (2.6.25, trace below is
    against today's net-2.6 git tree):
    
    skb_over_panic: text:c04fddb0 len:696 put:632 head:f7592c00 data:f7592c00 tail:0xf7592eb8 end:0xf7592e80 dev:eth0
    ------------[ cut here ]------------
    invalid opcode: 0000 [#1] PREEMPT
    Process sendd (pid: 3657, ti=f6014000 task=f77c31d0 task.ti=f6014000)
    Stack: c071e638 c04fddb0 000002b8 00000278 f7592c00 f7592c00 f7592eb8 f7592e80
           f763c000 f6bc5200 f7592c40 f6015c34 c04cdbfc f6bc5200 00000278 f6015c60
           c04fddb0 00000020 f72a10c0 f751b420 00000001 0000000a 000002b8 c065582c
    Call Trace:
     [<c04fddb0>] ? nfqnl_recv_verdict+0x1c0/0x2e0
     [<c04cdbfc>] ? skb_put+0x3c/0x40
     [<c04fddb0>] ? nfqnl_recv_verdict+0x1c0/0x2e0
     [<c04fd115>] ? nfnetlink_rcv_msg+0xf5/0x160
     [<c04fd03e>] ? nfnetlink_rcv_msg+0x1e/0x160
     [<c04fd020>] ? nfnetlink_rcv_msg+0x0/0x160
     [<c04f8ed7>] ? netlink_rcv_skb+0x77/0xa0
     [<c04fcefc>] ? nfnetlink_rcv+0x1c/0x30
     [<c04f8c73>] ? netlink_unicast+0x243/0x2b0
     [<c04cfaba>] ? memcpy_fromiovec+0x4a/0x70
     [<c04f9406>] ? netlink_sendmsg+0x1c6/0x270
     [<c04c8244>] ? sock_sendmsg+0xc4/0xf0
     [<c011970d>] ? set_next_entity+0x1d/0x50
     [<c0133a80>] ? autoremove_wake_function+0x0/0x40
     [<c0118f9e>] ? __wake_up_common+0x3e/0x70
     [<c0342fbf>] ? n_tty_receive_buf+0x34f/0x1280
     [<c011d308>] ? __wake_up+0x68/0x70
     [<c02cea47>] ? copy_from_user+0x37/0x70
     [<c04cfd7c>] ? verify_iovec+0x2c/0x90
     [<c04c837a>] ? sys_sendmsg+0x10a/0x230
     [<c011967a>] ? __dequeue_entity+0x2a/0xa0
     [<c011970d>] ? set_next_entity+0x1d/0x50
     [<c0345397>] ? pty_write+0x47/0x60
     [<c033d59b>] ? tty_default_put_char+0x1b/0x20
     [<c011d2e9>] ? __wake_up+0x49/0x70
     [<c033df99>] ? tty_ldisc_deref+0x39/0x90
     [<c033ff20>] ? tty_write+0x1a0/0x1b0
     [<c04c93af>] ? sys_socketcall+0x7f/0x260
     [<c0102ff9>] ? sysenter_past_esp+0x6a/0x91
     [<c05f0000>] ? snd_intel8x0m_probe+0x270/0x6e0
     =======================
    Code: 00 00 89 5c 24 14 8b 98 9c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 38 e6 71 c0 89 44 24 08 e8 c4 46 c5 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec 0c 8b 40 50 39 d0
    EIP: [<c04ccdfc>] skb_over_panic+0x5c/0x60 SS:ESP 0068:f6015bf8
    
    
    Looking at the code, I ended up in nfq_mangle() function (called by
    nfqnl_recv_verdict()) which performs a call to skb_copy_expand() due to
    the increased size of data passed to the function. AFAICT, it should ask
    for 'diff' instead of 'diff - skb_tailroom(e->skb)'. Because the
    resulting sk_buff has not enough space to support the skb_put(skb, diff)
    call a few lines later, this results in the call to skb_over_panic().
    
    The patch below asks for allocation of a copy with enough space for
    mangled packet and the same amount of headroom as old sk_buff. While
    looking at how the regression appeared (e2b58a67), I noticed the same
    pattern in ipq_mangle_ipv6() and ipq_mangle_ipv4(). The patch corrects
    those locations too.
    
    Tested with bigger reinjected IPv6 packets (nfqnl_mangle() path), things
    are ok (2.6.25 and today's net-2.6 git tree).
    
    Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 16d0fb3..f821a9b 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -349,9 +349,8 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			nskb = skb_copy_expand(e->skb, 0,
-					       diff - skb_tailroom(e->skb),
-					       GFP_ATOMIC);
+			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
+					       diff, GFP_ATOMIC);
 			if (!nskb) {
 				printk(KERN_WARNING "ip_queue: error "
 				      "in mangle, dropping packet\n");
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 710a04f..b9db6d9 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -346,9 +346,8 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			nskb = skb_copy_expand(e->skb, 0,
-					       diff - skb_tailroom(e->skb),
-					       GFP_ATOMIC);
+			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
+					       diff, GFP_ATOMIC);
 			if (!nskb) {
 				printk(KERN_WARNING "ip6_queue: OOM "
 				      "in mangle, dropping packet\n");
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7c3646c..d5fab38 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -627,9 +627,8 @@ nfqnl_mangle(void *data, int data_len, struct nfqnl_queue_entry *e)
 		if (data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			nskb = skb_copy_expand(e->skb, 0,
-					       diff - skb_tailroom(e->skb),
-					       GFP_ATOMIC);
+			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
+					       diff, GFP_ATOMIC);
 			if (!nskb) {
 				printk(KERN_WARNING "nf_queue: OOM "
 				      "in mangle, dropping packet\n");

--------------080904050307060301040203--
