Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYISPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYISPu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYISPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:50:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYISPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:50:51 -0400
Date: Fri, 19 Sep 2008 11:50:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix count(), compat_count() bounds checking
Message-ID: <20080919155003.GB3114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

With MAX_ARG_STRINGS set to 0x7FFFFFFF, and being passed to 'count()'
and compat_count(), it would appear that the current max bounds check
of fs/exec.c:394:

	if(++i > max)
		return -E2BIG;

would never trigger. Since 'i' is of type int, so values would wrap and the
function would continue looping.

Simple fix seems to be chaning ++i to i++ and checking for '>='.

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 fs/compat.c |    2 +-
 fs/exec.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 3d4d57a..2c68dd7 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1233,7 +1233,7 @@ static int compat_count(compat_uptr_t __user *argv, int max)
 			if (!p)
 				break;
 			argv++;
-			if(++i > max)
+			if (i++ >= max)
 				return -E2BIG;
 		}
 	}
diff --git a/fs/exec.c b/fs/exec.c
index 9bf0476..7766839 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -389,7 +389,7 @@ static int count(char __user * __user * argv, int max)
 			if (!p)
 				break;
 			argv++;
-			if(++i > max)
+			if (i++ >= max)
 				return -E2BIG;
 			cond_resched();
 		}
