Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbXEUKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbXEUKPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761266AbXEUKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:37 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33581 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761343AbXEUKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:18 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510268:sNHT120544305"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Bernd Schmidt <bernd.schmidt@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 25/32] Blackfin arch: fix signal handling bug
Date: Mon, 21 May 2007 18:09:33 +0800
Message-Id: <11797421872192-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernd.schmidt@analog.com>

There's a forum thread at
https://blackfin.uclinux.org/gf/project/uclinux-dist/forum/?action=ForumBrowse&_forum_action=MessageReply&message_id=24741

which has a testcase involving signal handling that crashes quite readily.
Inspecting the code I believe what happens is that signal handling can become
confused when it is invoked on return from an interrupt, if the contents of
P0 and R0 at the time of the interrupt happen to be such that P0 is larger
than zero (indicating to the signal code that we're in a syscall), and R0
happens to have a value of something like -EINTR or -ERESTARTSYS.
Fixed by setting orig_p0 to -1 if we're returning from an interrupt.  The
testcase now seems to run without problems.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/entry.S |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index e463733..7d03687 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -712,6 +712,11 @@ _schedule_and_signal_from_int:
 	p1.h = _evt_system_call;
 	[p0] = p1;
 	csync;
+
+	/* Set orig_p0 to -1 to indicate this isn't the end of a syscall.  */
+	r0 = -1 (x);
+	[sp + PT_ORIG_P0] = r0;
+
 	p1 = rets;
 	[sp + PT_RESERVED] = p1;
 
-- 
1.5.1.2
