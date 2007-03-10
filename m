Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXCJGTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXCJGTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXCJGSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:18:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:41217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXCJGSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:18:41 -0500
Date: Fri, 9 Mar 2007 22:17:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
       Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Subject: [patch 04/20] nfnetlink_log: fix reference leak
Message-ID: <20070310061701.GE31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfnetlink_log-fix-reference-leak.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nfnetlink_log: fix reference leak

Stop reference leaking in nfulnl_log_packet(). If we start a timer we
are already taking another reference.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/netfilter/nfnetlink_log.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -720,15 +720,16 @@ nfulnl_log_packet(unsigned int pf,
 		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
 	}
-	spin_unlock_bh(&inst->lock);
 
+unlock_and_release:
+	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 	return;
 
 alloc_failure:
-	spin_unlock_bh(&inst->lock);
-	instance_put(inst);
 	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
+	goto unlock_and_release;
 }
 
 static int

-- 
