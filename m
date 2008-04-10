Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbYDJIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbYDJIkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYDJIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:40:47 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46823 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbYDJIkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:40:46 -0400
Message-ID: <47FDD413.5040101@sw.ru>
Date: Thu, 10 Apr 2008 12:47:15 +0400
From: Pavel Emelyanov <xemul@sw.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/10] Bsdacct: make check timer accept an argument
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

