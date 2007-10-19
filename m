Return-Path: <linux-kernel-owner+w=401wt.eu-S966555AbXJSElO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966555AbXJSElO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXJSEkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:40:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50894
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbXJSEky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:40:54 -0400
Date: Thu, 18 Oct 2007 21:41:07 -0700 (PDT)
Message-Id: <20071018.214107.21905270.davem@davemloft.net>
To: ezk@cs.sunysb.edu
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, pcnet32@verizon.net,
       netdev@vger.kernel.org
Subject: Re: broken PCNET32 in 2.6.24 requires experimental PCNET32_NAPI? 
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710190433.l9J4X9vh011890@agora.fsl.cs.sunysb.edu>
References: <4717C90A.4060208@garzik.org>
	<200710190433.l9J4X9vh011890@agora.fsl.cs.sunysb.edu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>
Date: Fri, 19 Oct 2007 00:33:09 -0400

> Call Trace:
>  [<c0102bc2>] show_trace_log_lvl+0x1a/0x2f
>  [<c0102c72>] show_stack_log_lvl+0x9b/0xa3
>  [<c0102e2e>] show_registers+0x1b4/0x285
>  [<c0102fff>] die+0x100/0x21d
>  [<c010a72f>] do_page_fault+0x434/0x515
>  [<c026a40a>] error_code+0x6a/0x70
>  [<c021ea1b>] sock_setsockopt+0x43f/0x494
>  [<c021b994>] sys_setsockopt+0x4f/0x85
>  [<c021ce0e>] sys_socketcall+0x1cb/0x222
>  [<c0102586>] sysenter_past_esp+0x5f/0x91

This fix from Olof Johnson should fix it.

I'll merge this tonight.

diff --git a/net/core/filter.c b/net/core/filter.c
index 1f0068e..e0a0694 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -447,7 +447,8 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	rcu_assign_pointer(sk->sk_filter, fp);
 	rcu_read_unlock_bh();
 
-	sk_filter_delayed_uncharge(sk, old_fp);
+	if (old_fp)
+		sk_filter_delayed_uncharge(sk, old_fp);
 	return 0;
 }
 

