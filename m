Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYJFXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYJFXaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbYJFXXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbYJFXXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:23:00 -0400
Date: Mon, 6 Oct 2008 16:17:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 25/28] netlink: fix overrun in attribute iteration
Message-ID: <20081006231755.GZ20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-netlink-fix-overrun-in-attribute-iteration.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Vegard Nossum <vegard.nossum@gmail.com>

[ Upstream commit 1045b03e07d85f3545118510a587035536030c1c ]

kmemcheck reported this:

  kmemcheck: Caught 16-bit read from uninitialized memory (f6c1ba30)
  0500110001508abf050010000500000002017300140000006f72672e66726565
   i i i i i i i i i i i i i u u u u u u u u u u u u u u u u u u u
                                   ^

  Pid: 3462, comm: wpa_supplicant Not tainted (2.6.27-rc3-00054-g6397ab9-dirty #13)
  EIP: 0060:[<c05de64a>] EFLAGS: 00010296 CPU: 0
  EIP is at nla_parse+0x5a/0xf0
  EAX: 00000008 EBX: fffffffd ECX: c06f16c0 EDX: 00000005
  ESI: 00000010 EDI: f6c1ba30 EBP: f6367c6c ESP: c0a11e88
   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  CR0: 8005003b CR2: f781cc84 CR3: 3632f000 CR4: 000006d0
  DR0: c0ead9bc DR1: 00000000 DR2: 00000000 DR3: 00000000
  DR6: ffff4ff0 DR7: 00000400
   [<c05d4b23>] rtnl_setlink+0x63/0x130
   [<c05d5f75>] rtnetlink_rcv_msg+0x165/0x200
   [<c05ddf66>] netlink_rcv_skb+0x76/0xa0
   [<c05d5dfe>] rtnetlink_rcv+0x1e/0x30
   [<c05dda21>] netlink_unicast+0x281/0x290
   [<c05ddbe9>] netlink_sendmsg+0x1b9/0x2b0
   [<c05beef2>] sock_sendmsg+0xd2/0x100
   [<c05bf945>] sys_sendto+0xa5/0xd0
   [<c05bf9a6>] sys_send+0x36/0x40
   [<c05c03d6>] sys_socketcall+0x1e6/0x2c0
   [<c020353b>] sysenter_do_call+0x12/0x3f
   [<ffffffff>] 0xffffffff

This is the line in nla_ok():

  /**
   * nla_ok - check if the netlink attribute fits into the remaining bytes
   * @nla: netlink attribute
   * @remaining: number of bytes remaining in attribute stream
   */
  static inline int nla_ok(const struct nlattr *nla, int remaining)
  {
          return remaining >= sizeof(*nla) &&
                 nla->nla_len >= sizeof(*nla) &&
                 nla->nla_len <= remaining;
  }

It turns out that remaining can become negative due to alignment in
nla_next(). But GCC promotes "remaining" to unsigned in the test
against sizeof(*nla) above. Therefore the test succeeds, and the
nla_for_each_attr() may access memory outside the received buffer.

A short example illustrating this point is here:

  #include <stdio.h>

  main(void)
  {
          printf("%d\n", -1 >= sizeof(int));
  }

...which prints "1".

This patch adds a cast in front of the sizeof so that GCC will make
a signed comparison and fix the illegal memory dereference. With the
patch applied, there is no kmemcheck report.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -704,7 +704,7 @@ static inline int nla_len(const struct n
  */
 static inline int nla_ok(const struct nlattr *nla, int remaining)
 {
-	return remaining >= sizeof(*nla) &&
+	return remaining >= (int) sizeof(*nla) &&
 	       nla->nla_len >= sizeof(*nla) &&
 	       nla->nla_len <= remaining;
 }

-- 
