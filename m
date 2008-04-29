Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYD2RWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYD2RWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYD2RU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:28 -0400
Received: from mail.suse.de ([195.135.220.2]:51886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbYD2RU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:26 -0400
Date: Tue, 29 Apr 2008 10:18:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bernard Pidoux <f6bvp@amsat.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [08/37] rose: Socket lock was not released before returning to
	user space
Message-ID: <20080429171811.GI14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rose-socket-lock-was-not-released-before-returning-to-user-space.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bernard Pidoux <f6bvp@amsat.org>

[ Upstream commit: 43837b1e6c5aef803d57009a68db18df13e64892 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rose/af_rose.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -760,8 +760,10 @@ static int rose_connect(struct socket *s
 
 	rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
 					 &diagnostic);
-	if (!rose->neighbour)
-		return -ENETUNREACH;
+	if (!rose->neighbour) {
+		err = -ENETUNREACH;
+		goto out_release;
+	}
 
 	rose->lci = rose_new_lci(rose->neighbour);
 	if (!rose->lci) {

-- 
