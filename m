Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYHKNL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYHKNL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYHKNLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:11:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:26275 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYHKNLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Lc7/IPrdv0WtRwJDfQ1maoIrgFrG33RDc9mHJ2igZ5xhq3c56/21He7XGV9y6h3KK4
         7/CFGURQsPqmve7LBqkhE+rIX9B4Ir5Z+kGok6HLlPgV0w2yHx7idD8izskHTg4EDCfc
         KlTHCiWCc0GybLmoGsCxkqOJvNkjMl6XlLCOM=
Message-ID: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com>
Date: Mon, 11 Aug 2008 15:11:46 +0200
From: "John Kacur" <jkacur@gmail.com>
To: rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] BUG: using smp_processor_id() in preemptible [00000000] code: caller is __qdisc_run
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_36925_17376024.1218460306058"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_36925_17376024.1218460306058
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm running a linux-2.6.26.1 kernel with the real-time
patch-2.6.26-rt1 plus most of the patches discussed on the
linux-rt-users list since rt1. (except ppc patches, and not Gregory
Haskins experimental stuff)
The above info is mostly just full exclosure, I'm sure that this bug
exists in plain linux-2.6.26 + real-time patch-2.6.26-rt1 too.

BUG: using smp_processor_id() in preemptible [00000000] code: firefox-bin/4091
caller is __qdisc_run+0x160/0x1e9
Pid: 4091, comm: firefox-bin Tainted: G        W 2.6.26.1-rt1.jk #4

Call Trace:
 [<ffffffff803468ac>] debug_smp_processor_id+0xe4/0xf4
 [<ffffffff8040673f>] __qdisc_run+0x160/0x1e9
 [<ffffffff803f406c>] dev_queue_xmit+0x1b3/0x2ee
 [<ffffffff8041abec>] ip_finish_output+0x2a6/0x2ef
 [<ffffffff8041ad18>] ip_output+0xe3/0xec
 [<ffffffff80419c54>] ip_local_out+0x25/0x29
 [<ffffffff8041a4c6>] ip_queue_xmit+0x2ce/0x35e
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff80286265>] ? trace_preempt_on+0x1f/0x105
 [<ffffffff8042b6b2>] ? tcp_transmit_skb+0x72a/0x78f
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8042b6d8>] tcp_transmit_skb+0x750/0x78f
 [<ffffffff8042e274>] __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff802b53b3>] ? __kmalloc_node+0x48/0x4a
 [<ffffffff803ee44d>] ? __alloc_skb+0x70/0x136
 [<ffffffff8042e518>] tcp_send_fin+0x18e/0x19a
 [<ffffffff80420358>] tcp_close+0x1cc/0x413
 [<ffffffff8043d1a6>] inet_release+0x55/0x5c
 [<ffffffff803e78af>] sock_release+0x1f/0xb2
 [<ffffffff803e797b>] sock_close+0x39/0x3f
 [<ffffffff802bb11b>] __fput+0xca/0x18d
 [<ffffffff802bb1f7>] fput+0x19/0x1b
 [<ffffffff802b8120>] filp_close+0x6b/0x76
 [<ffffffff802b81d5>] sys_close+0xaa/0xe9
 [<ffffffff80226c07>] sysenter_do_call+0x8c/0x149
 [<ffffffff8046ca94>] ? trace_hardirqs_on_thunk+0x3a/0x3c

---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff80346859>] .... debug_smp_processor_id+0x91/0xf4
.....[<ffffffff8040673f>] ..   ( <= __qdisc_run+0x160/0x1e9)

BUG: firefox-bin:4091 task might have lost a preemption check!
Pid: 4091, comm: firefox-bin Tainted: G        W 2.6.26.1-rt1.jk #4

Call Trace:
 [<ffffffff804708c8>] ? sub_preempt_count+0xd1/0xe6
 [<ffffffff80235c41>] preempt_enable_no_resched+0x5c/0x5e
 [<ffffffff803468b1>] debug_smp_processor_id+0xe9/0xf4
 [<ffffffff8040673f>] __qdisc_run+0x160/0x1e9
 [<ffffffff803f406c>] dev_queue_xmit+0x1b3/0x2ee
 [<ffffffff8041abec>] ip_finish_output+0x2a6/0x2ef
 [<ffffffff8041ad18>] ip_output+0xe3/0xec
 [<ffffffff80419c54>] ip_local_out+0x25/0x29
 [<ffffffff8041a4c6>] ip_queue_xmit+0x2ce/0x35e
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff80286265>] ? trace_preempt_on+0x1f/0x105
 [<ffffffff8042b6b2>] ? tcp_transmit_skb+0x72a/0x78f
 [<ffffffff8042e274>] ? __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff8042b6d8>] tcp_transmit_skb+0x750/0x78f
 [<ffffffff8042e274>] __tcp_push_pending_frames+0x74a/0x860
 [<ffffffff802b53b3>] ? __kmalloc_node+0x48/0x4a
 [<ffffffff803ee44d>] ? __alloc_skb+0x70/0x136
 [<ffffffff8042e518>] tcp_send_fin+0x18e/0x19a
 [<ffffffff80420358>] tcp_close+0x1cc/0x413
 [<ffffffff8043d1a6>] inet_release+0x55/0x5c
 [<ffffffff803e78af>] sock_release+0x1f/0xb2
 [<ffffffff803e797b>] sock_close+0x39/0x3f
 [<ffffffff802bb11b>] __fput+0xca/0x18d
 [<ffffffff802bb1f7>] fput+0x19/0x1b
 [<ffffffff802b8120>] filp_close+0x6b/0x76
 [<ffffffff802b81d5>] sys_close+0xaa/0xe9
 [<ffffffff80226c07>] sysenter_do_call+0x8c/0x149
 [<ffffffff8046ca94>] ? trace_hardirqs_on_thunk+0x3a/0x3c

---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:

__qdisc_run() calls qdisc_restart() which calls
handle_dev_cpu_collision(skb, dev, q); and then the problem shows up
here:
__get_cpu_var(netdev_rx_stat).cpu_collision++;

The solution is to disable interrupts around the above increment. Here
is an attached patch to do so. (Thank's to Peter Zijlstra for help in
the analysis and dropping the answer in my lap, so if I got it right
it is due to his help, but if I messed it up, then I did that part all
by myself.)

Unless there are objections, please apply.

------=_Part_36925_17376024.1218460306058
Content-Type: text/x-patch; name=qdisc_run.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjr3o7lg0
Content-Disposition: attachment; filename=qdisc_run.patch

U3ViamVjdDogZml4IGZvciBCVUc6IHVzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBwcmVlbXB0
aWJsZSBjb2RlCgpGaXhlcyB1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUg
Y29kZSBhcyBzZWVuIHdoZW4gX19xZGlzY19ydW4KY2FsbHMgcWRpc2NfcmVzdGFydCB3aGljaCBj
YWxscyBoYW5kbGVfZGV2X2NwdV9jb2xsaXNpb24KClRoaXMgaXMgZml4ZWQgYnkgZGlzYWJsaW5n
IGlycXMgKGFuZCBwcmVlbXB0aW9uKSBhcm91bmQgY3B1X2NvbGxpc2lvbisrCmluIGhhbmRsZV9k
ZXZfY3B1X2NvbGxpc2lvbgoKU2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyIGF0IGdt
YWlsIGRvdCBjb20+CgpJbmRleDogbGludXgtMi42LjI2LjEtcnQxLmprL25ldC9zY2hlZC9zY2hf
Z2VuZXJpYy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yNi4xLXJ0MS5qay5vcmlnL25ldC9z
Y2hlZC9zY2hfZ2VuZXJpYy5jCisrKyBsaW51eC0yLjYuMjYuMS1ydDEuamsvbmV0L3NjaGVkL3Nj
aF9nZW5lcmljLmMKQEAgLTk0LDYgKzk0LDcgQEAgc3RhdGljIGlubGluZSBpbnQgaGFuZGxlX2Rl
dl9jcHVfY29sbGlzaQogCQkJCQkgICBzdHJ1Y3QgUWRpc2MgKnEpCiB7CiAJaW50IHJldDsKKwl1
bnNpZ25lZCBsb25nIGZsYWdzOwogCiAJaWYgKHVubGlrZWx5KGRldi0+eG1pdF9sb2NrX293bmVy
ID09ICh2b2lkICopY3VycmVudCkpIHsKIAkJLyoKQEAgLTExMiw3ICsxMTMsOSBAQCBzdGF0aWMg
aW5saW5lIGludCBoYW5kbGVfZGV2X2NwdV9jb2xsaXNpCiAJCSAqIEFub3RoZXIgY3B1IGlzIGhv
bGRpbmcgbG9jaywgcmVxdWV1ZSAmIGRlbGF5IHhtaXRzIGZvcgogCQkgKiBzb21lIHRpbWUuCiAJ
CSAqLworCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CiAJCV9fZ2V0X2NwdV92YXIobmV0ZGV2X3J4
X3N0YXQpLmNwdV9jb2xsaXNpb24rKzsKKwkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwogCQly
ZXQgPSBkZXZfcmVxdWV1ZV9za2Ioc2tiLCBkZXYsIHEpOwogCX0KIAo=
------=_Part_36925_17376024.1218460306058--
