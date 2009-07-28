Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZG1Xx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZG1Xx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbZG1Xx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:53:57 -0400
Received: from kroah.org ([198.145.64.141]:35932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZG1XuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:00 2009
Message-Id: <20090728234200.257182735@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 57/71] netfilter: nf_log: fix sleeping function called from invalid context
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-nf_log-fix-sleeping-function-called-from-invalid-context.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 266d07cb1c9a0c345d7d3aea889f92062894059e upstream.

Fix regression introduced by 17625274 "netfilter: sysctl support of
logger choice":

BUG: sleeping function called from invalid context at /mnt/s390test/linux-2.6-tip/arch/s390/include/asm/uaccess.h:234
in_atomic(): 1, irqs_disabled(): 0, pid: 3245, name: sysctl
CPU: 1 Not tainted 2.6.30-rc8-tipjun10-02053-g39ae214 #1
Process sysctl (pid: 3245, task: 000000007f675da0, ksp: 000000007eb17cf0)
0000000000000000 000000007eb17be8 0000000000000002 0000000000000000
       000000007eb17c88 000000007eb17c00 000000007eb17c00 0000000000048156
       00000000003e2de8 000000007f676118 000000007eb17f10 0000000000000000
       0000000000000000 000000007eb17be8 000000000000000d 000000007eb17c58
       00000000003e2050 000000000001635c 000000007eb17be8 000000007eb17c30
Call Trace:
(Ý<00000000000162e6>¨ show_trace+0x13a/0x148)
 Ý<00000000000349ea>¨ __might_sleep+0x13a/0x164
 Ý<0000000000050300>¨ proc_dostring+0x134/0x22c
 Ý<0000000000312b70>¨ nf_log_proc_dostring+0xfc/0x188
 Ý<0000000000136f5e>¨ proc_sys_call_handler+0xf6/0x118
 Ý<0000000000136fda>¨ proc_sys_read+0x26/0x34
 Ý<00000000000d6e9c>¨ vfs_read+0xac/0x158
 Ý<00000000000d703e>¨ SyS_read+0x56/0x88
 Ý<0000000000027f42>¨ sysc_noemu+0x10/0x16

Use the nf_log_mutex instead of RCU to fix this.

Reported-and-tested-by: Maran Pakkirisamy <maranpsamy@in.ibm.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_log.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -248,14 +248,14 @@ static int nf_log_proc_dostring(ctl_tabl
 		rcu_assign_pointer(nf_loggers[tindex], logger);
 		mutex_unlock(&nf_log_mutex);
 	} else {
-		rcu_read_lock();
-		logger = rcu_dereference(nf_loggers[tindex]);
+		mutex_lock(&nf_log_mutex);
+		logger = nf_loggers[tindex];
 		if (!logger)
 			table->data = "NONE";
 		else
 			table->data = logger->name;
 		r = proc_dostring(table, write, filp, buffer, lenp, ppos);
-		rcu_read_unlock();
+		mutex_unlock(&nf_log_mutex);
 	}
 
 	return r;


