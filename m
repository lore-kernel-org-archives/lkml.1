Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYIKU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYIKU7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYIKU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:59:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5518 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYIKU7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=QU1XKA01UBBIcxgOdCsD4YEbBTHk9sL1utNXSbVeQmquDXmvaOdh3gJO0NMYCiAMuS
         bxYMkPlZB6ti/fPqKGSyOBu762RIPonHo+gRGiCf88hVu11o58CRwi4jjb43ctMR4c0T
         hPFLqJ6cAdigKgtynlSl/736pUYvZ9h3Jpulk=
Date: Thu, 11 Sep 2008 22:59:33 +0200
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] netlink: fix overrun in attribute iteration
Message-ID: <20080911205933.GA20032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ca63375e8ed91d73d0c2abd1cb64a8b022ce2af8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 11 Sep 2008 22:37:13 +0200
Subject: [PATCH] netlink: fix overrun in attribute iteration

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

Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/net/netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 18024b8..208fe5a 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -702,7 +702,7 @@ static inline int nla_len(const struct nlattr *nla)
  */
 static inline int nla_ok(const struct nlattr *nla, int remaining)
 {
-	return remaining >= sizeof(*nla) &&
+	return remaining >= (int) sizeof(*nla) &&
 	       nla->nla_len >= sizeof(*nla) &&
 	       nla->nla_len <= remaining;
 }
-- 
1.5.5.1

