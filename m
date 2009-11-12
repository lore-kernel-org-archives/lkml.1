Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZKLHsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZKLHsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZKLHsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:48:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47808 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZKLHsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:48:02 -0500
Date: Thu, 12 Nov 2009 18:48:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: sysctl tree build failure
Message-Id: <20091112184805.1c0720cb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next build (powerpc allnoconfig) failed like this:

kernel/built-in.o: In function `get_sysctl':
sysctl_binary.c:(.text+0x100d4): undefined reference to `dev_get_by_index'

Caused by commit 26a7034b40ba80f82f64fa251a2cbf49f9971c6a ("sysctl:
Reduce sys_sysctl to a compatibility wrapper around /proc/sys").

CONFIG_NET is not set for this build.

I have used this patch for today:
(It does produce this warning, though:

kernel/sysctl_binary.c:1253: warning: unused variable 'net'

so needs more work.)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 18:43:35 +1100
Subject: [PATCH] sysctl: fix build dependency on CONFIG_NET

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/sysctl_binary.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 471438b..4f58ea7 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1270,6 +1270,7 @@ repeat:
 		if (ctl_name == table->ctl_name)
 			procname = table->procname;
 
+#ifdef CONFIG_NET
 		/*
 		 * For a wild card entry map from ifindex to network
 		 * device name.
@@ -1279,6 +1280,7 @@ repeat:
 			if (dev)
 				procname = dev->name;
 		}
+#endif
 		if (procname) {
 			int len;
 
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
