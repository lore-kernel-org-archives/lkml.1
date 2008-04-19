Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYDTB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYDTB3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYDTB3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:29:23 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:41223 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYDTB3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:29:22 -0400
Message-ID: <480A6034.1080806@ccr.jussieu.fr>
Date: Sat, 19 Apr 2008 23:12:20 +0200
From: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: Ralf Baechle DL5RB <ralf@linux-mips.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-hams <linux-hams@vger.kernel.org>
Subject: [PATCH] rose_node_list_lock was not released before returning to
 user space
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 74859daa5a1ef4d793c03c77b52affa0f95c609d Mon Sep 17 00:00:00 2001
From: Bernard Pidoux <f6bvp@amsat.org>
Date: Sat, 19 Apr 2008 20:13:55 +0200
Subject: [PATCH] rose_node_list_lock was not released before returning to user space

I have already submited this patch on January 11, 2008.
As the bug is still present, I resend it.

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
xfbbd/3683 is leaving the kernel with locks still held!
1 lock held by xfbbd/3683:
  #0:  (sk_lock-AF_ROSE){--..}, at: [<c8cd1eb3>] rose_connect+0x73/0x420 [rose]

INFO: task xfbbd:3683 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfbbd         D 00000246     0  3683   3669
        c6965ee0 00000092 c02c5c40 00000246 c0f6b5f0 c0f6b5c0 c0f6b5f0 c0f6b5c0
        c0f6b614 c6965f18 c024b74b ffffffff c06ba070 00000000 00000000 00000001
        c6ab07c0 c012d450 c0f6b634 c0f6b634 c7b5bf10 c0d6004c c7b5bf10 c6965f40
Call Trace:
  [<c024b74b>] lock_sock_nested+0x6b/0xd0
  [<c012d450>] ? autoremove_wake_function+0x0/0x40
  [<c02488f1>] sock_fasync+0x41/0x150
  [<c0249e69>] sock_close+0x19/0x40
  [<c0175d54>] __fput+0xb4/0x170
  [<c0176018>] fput+0x18/0x20
  [<c017300e>] filp_close+0x3e/0x70
  [<c01744e9>] sys_close+0x69/0xb0
  [<c0103bda>] sysenter_past_esp+0x5f/0xa5
  =======================
INFO: lockdep is turned off.


Signed-off-by: Bernard Pidoux <f6bvp@amsat.org>
---
  net/rose/af_rose.c |    6 ++++--
  1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index d1ff3f8..1ebf652 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -760,8 +760,10 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le

         rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
                                          &diagnostic);
-       if (!rose->neighbour)
-               return -ENETUNREACH;
+       if (!rose->neighbour) {
+               err = -ENETUNREACH;
+               goto out_release;
+       }

         rose->lci = rose_new_lci(rose->neighbour);
         if (!rose->lci) {
--
1.5.5


