Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYJWPug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYJWPug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYJWPuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:50:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57260 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYJWPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:50:08 -0400
Date: Thu, 23 Oct 2008 08:49:28 -0700
From: sukadev@linux.vnet.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] 'kill sig -1' must only apply to caller's namespace
Message-ID: <20081023154928.GA1044@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [PATCH] 'kill sig -1' must only apply to caller's namespace

Currently "kill <sig> -1" kills processes in all namespaces and breaks the
isolation of namespaces. Earlier attempt to fix this was discussed at:

	http://lkml.org/lkml/2008/7/23/148

As suggested by Oleg Nesterov in that thread, use "task_pid_vnr() > 1"
check since task_pid_vnr() returns 0 if process is outside the caller's
namespace.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Daniel Hokka Zakrisson <daniel@hozac.com>
---
 kernel/signal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 105217d..4530fc6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1144,7 +1144,8 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 		struct task_struct * p;
 
 		for_each_process(p) {
-			if (p->pid > 1 && !same_thread_group(p, current)) {
+			if (task_pid_vnr(p) > 1 &&
+					!same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
 				++count;
 				if (err != -EPERM)
-- 
1.5.2.5

