Return-Path: <linux-kernel-owner+w=401wt.eu-S1763678AbZLQBZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678AbZLQBZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763722AbZLQBYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:24:46 -0500
Received: from kroah.org ([198.145.64.141]:41509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763724AbZLQBVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:09 2009
Message-Id: <20091217011609.364392349@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       WANG Cong <amwang@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [87/90] sysctl_max_map_count should be non-negative
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1539,7 +1539,8 @@ static struct ctl_table debug_table[] = 
 		.data		= &show_unhandled_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
 	},
 #endif
 	{ .ctl_name = 0 }


