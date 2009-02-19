Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZBSDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZBSDIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZBSDH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:07:59 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33405 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZBSDH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:07:57 -0500
Date: Wed, 18 Feb 2009 19:07:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns
	boundary
Message-ID: <20090219030743.GG18990@us.ibm.com>
References: <20090219030207.GA18783@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219030207.GA18783@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 24 Dec 2008 14:14:18 -0800
Subject: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary

When sending a signal to a descendant namespace, set ->si_pid to 0 since
the sender does not have a pid in the receiver's namespace.

Note:
	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
	  signal across a pid namespace boundary, the value in ->si_pid
	  will be cleared to 0.

Changelog[v5]:
	- (Oleg Nesterov) Address both sys_kill() and sys_tkill() cases
	  in send_signal() to simplify code (this drops patch 7/7 from
	  earlier version of patchset).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c94355b..a416d77 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -883,6 +883,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			break;
 		default:
 			copy_siginfo(&q->info, info);
+			if (from_ancestor_ns)
+				q->info.si_pid = 0;
 			break;
 		}
 	} else if (!is_si_special(info)) {
-- 
1.5.2.5

