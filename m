Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZCMJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZCMJh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCMJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:37:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:55974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZCMJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:37:17 -0400
Date: Fri, 13 Mar 2009 09:36:28 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312221118.11146.68610.stgit@Aeon>
References: <20090312221118.11146.68610.stgit@Aeon>
Subject: [tip:core/futexes] futex: remove the pointer math from double_unlock_hb, fix
Message-ID: <tip-88f502fedba82eff252b6420e8b8328e4ae25c67@git.kernel.org>
Git-Commit-ID: 88f502fedba82eff252b6420e8b8328e4ae25c67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 09:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88f502fedba82eff252b6420e8b8328e4ae25c67
Gitweb:     http://git.kernel.org/tip/88f502fedba82eff252b6420e8b8328e4ae25c67
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 10:32:07 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 10:32:07 +0100

futex: remove the pointer math from double_unlock_hb, fix

Impact: fix double unlock crash

Thomas Gleixner noticed that the simplified double_unlock_hb()
became ... too unsophisticated: in the hb1 == hb2 case it will
do a double unlock.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <20090312221118.11146.68610.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 2331b73..6b50a02 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -659,7 +659,8 @@ static inline void
 double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 {
 	spin_unlock(&hb1->lock);
-	spin_unlock(&hb2->lock);
+	if (hb1 != hb2)
+		spin_unlock(&hb2->lock);
 }
 
 /*
