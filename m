Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbZJIXm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbZJIXm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934586AbZJIXmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:13 -0400
Received: from kroah.org ([198.145.64.141]:51449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbZJIXmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233439.921068660@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Varga <nite@hq.alert.sk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 30/37] tcp: fix CONFIG_TCP_MD5SIG + CONFIG_PREEMPT timer BUG()
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=tcp-fix-config_tcp_md5sig-config_preempt-timer-bug.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robert Varga <nite@hq.alert.sk>

[ Upstream commit 657e9649e745b06675aa5063c84430986cdc3afa ]

I have recently came across a preemption imbalance detected by:

<4>huh, entered ffffffff80644630 with preempt_count 00000102, exited with 00000101?
<0>------------[ cut here ]------------
<2>kernel BUG at /usr/src/linux/kernel/timer.c:664!
<0>invalid opcode: 0000 [1] PREEMPT SMP

with ffffffff80644630 being inet_twdr_hangman().

This appeared after I enabled CONFIG_TCP_MD5SIG and played with it a
bit, so I looked at what might have caused it.

One thing that struck me as strange is tcp_twsk_destructor(), as it
calls tcp_put_md5sig_pool() -- which entails a put_cpu(), causing the
detected imbalance. Found on 2.6.23.9, but 2.6.31 is affected as well,
as far as I can tell.

Signed-off-by: Robert Varga <nite@hq.alert.sk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_minisocks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -363,7 +363,7 @@ void tcp_twsk_destructor(struct sock *sk
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 	if (twsk->tw_md5_keylen)
-		tcp_put_md5sig_pool();
+		tcp_free_md5sig_pool();
 #endif
 }
 


