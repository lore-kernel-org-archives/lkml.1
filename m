Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZLIOU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZLIOU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZLIOUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:20:13 -0500
Received: from www.tglx.de ([62.245.132.106]:34393 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbZLIOUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:20:09 -0500
Message-Id: <20091209141634.729856346@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 14:19:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/3] audit: Do not send uninitialized data for AUDIT_TTY_GET
References: <20091209141540.067855785@linutronix.de>
Content-Disposition: inline; filename=audit-do-not-send-reply-when-esrch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_receive_msg() sends uninitialized data for AUDIT_TTY_GET when
the task was not found.

Send reply only when task was found.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
---
 kernel/audit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/audit.c
===================================================================
--- linux-2.6-tip.orig/kernel/audit.c
+++ linux-2.6-tip/kernel/audit.c
@@ -884,8 +884,10 @@ static int audit_receive_msg(struct sk_b
 			spin_unlock_irq(&tsk->sighand->siglock);
 		}
 		read_unlock(&tasklist_lock);
-		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
-				 &s, sizeof(s));
+
+		if (!err)
+			audit_send_reply(NETLINK_CB(skb).pid, seq,
+					 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {


