Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYEOLFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYEOLFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYEOLFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:05:05 -0400
Received: from sacred.ru ([62.205.161.221]:47664 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYEOLFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:05:04 -0400
Message-ID: <482C1840.1020202@openvz.org>
Date: Thu, 15 May 2008 15:02:24 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/10] Bsdacct: make check timer accept a bsd_acct_struct argument
References: <482C15FE.7070300@openvz.org>
In-Reply-To: <482C15FE.7070300@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 15 May 2008 15:04:44 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to have many bsd_acct_struct instances, not just
one, so the timer (currently working with a global one) has
to know which one to work with.

Use a handy setup_timer macro for it (thanks to Oleg for one).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 kernel/acct.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index d9ee183..05f8bc0 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -97,9 +97,10 @@ static struct bsd_acct_struct acct_globals __cacheline_aligned =
 /*
  * Called whenever the timer says to check the free space.
  */
-static void acct_timeout(unsigned long unused)
+static void acct_timeout(unsigned long x)
 {
-	acct_globals.needcheck = 1;
+	struct bsd_acct_struct *acct = (struct bsd_acct_struct *)x;
+	acct->needcheck = 1;
 }
 
 /*
@@ -193,8 +194,8 @@ static void acct_file_reopen(struct file *file)
 		acct_globals.needcheck = 0;
 		acct_globals.active = 1;
 		/* It's been deleted if it was used before so this is safe */
-		init_timer(&acct_globals.timer);
-		acct_globals.timer.function = acct_timeout;
+		setup_timer(&acct_globals.timer, acct_timeout,
+				(unsigned long)&acct_globals);
 		acct_globals.timer.expires = jiffies + ACCT_TIMEOUT*HZ;
 		add_timer(&acct_globals.timer);
 	}
-- 
1.5.3.4
