Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZGBR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZGBR3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZGBR2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:28:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39110 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZGBR2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:28:39 -0400
Date: Thu, 2 Jul 2009 19:25:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] child_wait_callback: check __WNOTHREAD case
Message-ID: <20090702172513.GA24092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

do_wait(__WNOTHREAD) can only succeed if the caller is either ptracer, or
it is ->real_parent and the child is not traced. IOW, caller == p->parent
otherwise we should not wake up.

Change child_wait_callback() to check this. Ratan reports the workload with
CPU load >99% caused by unnecessary wakeups, should be fixed by this patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    3 +++
 1 file changed, 3 insertions(+)

--- WAIT/kernel/exit.c~3_WNOTHREAD	2009-07-02 18:38:03.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-02 18:44:43.000000000 +0200
@@ -1569,6 +1569,9 @@ static int child_wait_callback(wait_queu
 	if (!eligible_child(wo, p))
 		return 0;
 
+	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
+		return 0;
+
 	return default_wake_function(wait, mode, sync, key);
 }
 

