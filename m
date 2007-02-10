Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXBJVvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXBJVvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXBJVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:51:15 -0500
Received: from mail.screens.ru ([213.234.233.54]:60927 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXBJVvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:51:01 -0500
Date: Sun, 11 Feb 2007 00:50:52 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Horms <horms@verge.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ipvs: flush defense_work before module unload
Message-ID: <20070210215052.GA2219@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net/ipv4/ipvs/ip_vs_core.c

	module_exit
	    ip_vs_cleanup
		ip_vs_control_cleanup
		    cancel_rearming_delayed_work
	// done

This is unsafe. The module may be unloaded and the memory may be freed while
defense_work's handler is still running/preempted.

Do flush_work(&defense_work.work) after cancel_rearming_delayed_work().

Alternatively, we could add flush_work() to cancel_rearming_delayed_work(),
but note that we can't change cancel_delayed_work() in the same manner because
it may be called from atomic context.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/net/ipv4/ipvs/ip_vs_ctl.c~3_ipvs	2007-02-03 20:41:11.000000000 +0300
+++ 6.20-rc6-mm3/net/ipv4/ipvs/ip_vs_ctl.c	2007-02-10 23:14:41.000000000 +0300
@@ -2387,6 +2387,7 @@ void ip_vs_control_cleanup(void)
 	EnterFunction(2);
 	ip_vs_trash_cleanup();
 	cancel_rearming_delayed_work(&defense_work);
+	flush_work_keventd(&defense_work.work);
 	ip_vs_kill_estimator(&ip_vs_stats);
 	unregister_sysctl_table(sysctl_header);
 	proc_net_remove("ip_vs_stats");

