Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbXIXQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbXIXQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760921AbXIXQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58027 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697AbXIXQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:41 -0400
Date: Mon, 24 Sep 2007 09:22:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [37/50] Fix inet_diag OOPS.
Message-ID: <20070924162206.GL13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-inet_diag-oops.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Patrick McHardy <kaber@trash.net>

commit 0a9c73014415d2a84dac346c1e12169142a6ad37 in mainline

[INET_DIAG]: Fix oops in netlink_rcv_skb

netlink_run_queue() doesn't handle multiple processes processing the
queue concurrently. Serialize queue processing in inet_diag to fix
a oops in netlink_rcv_skb caused by netlink_run_queue passing a
NULL for the skb.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000054
[349587.500454]  printing eip:
[349587.500457] c03318ae
[349587.500459] *pde = 00000000
[349587.500464] Oops: 0000 [#1]
[349587.500466] PREEMPT SMP
[349587.500474] Modules linked in: w83627hf hwmon_vid i2c_isa
[349587.500483] CPU:    0
[349587.500485] EIP:    0060:[<c03318ae>]    Not tainted VLI
[349587.500487] EFLAGS: 00010246   (2.6.22.3 #1)
[349587.500499] EIP is at netlink_rcv_skb+0xa/0x7e
[349587.500506] eax: 00000000   ebx: 00000000   ecx: c148d2a0   edx: c0398819
[349587.500510] esi: 00000000   edi: c0398819   ebp: c7a21c8c   esp: c7a21c80
[349587.500517] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[349587.500521] Process oidentd (pid: 17943, ti=c7a20000 task=cee231c0 task.ti=c7a20000)
[349587.500527] Stack: 00000000 c7a21cac f7c8ba78 c7a21ca4 c0331962 c0398819 f7c8ba00 0000004c
[349587.500542]        f736f000 c7a21cb4 c03988e3 00000001 f7c8ba00 c7a21cc4 c03312a5 0000004c
[349587.500558]        f7c8ba00 c7a21cd4 c0330681 f7c8ba00 e4695280 c7a21d00 c03307c6 7fffffff
[349587.500578] Call Trace:
[349587.500581]  [<c010361a>] show_trace_log_lvl+0x1c/0x33
[349587.500591]  [<c01036d4>] show_stack_log_lvl+0x8d/0xaa
[349587.500595]  [<c010390e>] show_registers+0x1cb/0x321
[349587.500604]  [<c0103bff>] die+0x112/0x1e1
[349587.500607]  [<c01132d2>] do_page_fault+0x229/0x565
[349587.500618]  [<c03c8d3a>] error_code+0x72/0x78
[349587.500625]  [<c0331962>] netlink_run_queue+0x40/0x76
[349587.500632]  [<c03988e3>] inet_diag_rcv+0x1f/0x2c
[349587.500639]  [<c03312a5>] netlink_data_ready+0x57/0x59
[349587.500643]  [<c0330681>] netlink_sendskb+0x24/0x45
[349587.500651]  [<c03307c6>] netlink_unicast+0x100/0x116
[349587.500656]  [<c0330f83>] netlink_sendmsg+0x1c2/0x280
[349587.500664]  [<c02fcce9>] sock_sendmsg+0xba/0xd5
[349587.500671]  [<c02fe4d1>] sys_sendmsg+0x17b/0x1e8
[349587.500676]  [<c02fe92d>] sys_socketcall+0x230/0x24d
[349587.500684]  [<c01028d2>] syscall_call+0x7/0xb
[349587.500691]  =======================
[349587.500693] Code: f0 ff 4e 18 0f 94 c0 84 c0 0f 84 66 ff ff ff 89 f0 e8 86 e2 fc ff e9 5a ff ff ff f0 ff 40 10 eb be 55 89 e5 57 89 d7 56 89 c6 53 <8b> 50 54 83 fa 10 72 55 8b 9e 9c 00 00 00 31 c9 8b 03 83 f8 0f

Reported by Athanasius <link@miggy.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/inet_diag.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -836,12 +836,16 @@ static int inet_diag_rcv_msg(struct sk_b
 	return inet_diag_get_exact(skb, nlh);
 }
 
+static DEFINE_MUTEX(inet_diag_mutex);
+
 static void inet_diag_rcv(struct sock *sk, int len)
 {
 	unsigned int qlen = 0;
 
 	do {
+		mutex_lock(&inet_diag_mutex);
 		netlink_run_queue(sk, &qlen, &inet_diag_rcv_msg);
+		mutex_unlock(&inet_diag_mutex);
 	} while (qlen);
 }
 

-- 
