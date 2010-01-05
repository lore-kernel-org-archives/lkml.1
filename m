Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472Ab0AEAf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0AEAf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414Ab0AEAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:46 -0500
Received: from kroah.org ([198.145.64.141]:34449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0AEAfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Amerigo Wang <amwang@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/97] 'sysctl_max_map_count' should be non-negative
Date: Mon,  4 Jan 2010 16:33:13 -0800
Message-Id: <1262651630-7354-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>

commit 70da2340fbc68e91e701762f785479ab495a0869 upstream.

Jan Engelhardt reported we have this problem:

setting max_map_count to a value large enough results in programs dying at
first try.  This is on 2.6.31.6:

15:59 borg:/proc/sys/vm # echo $[1<<31-1] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
1073741824
15:59 borg:/proc/sys/vm # echo $[1<<31] >max_map_count
15:59 borg:/proc/sys/vm # cat max_map_count
Killed

This is because we have a chance to make 'max_map_count' negative.  but
it's meaningless.  Make it only accept non-negative values.

Reported-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: James Morris <jmorris@namei.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sysctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index db23ab7..3928c04 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1607,7 +1607,8 @@ static struct ctl_table debug_table[] = {
 		.data		= &show_unhandled_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
 	},
 #endif
 	{ .ctl_name = 0 }
-- 
1.6.6

