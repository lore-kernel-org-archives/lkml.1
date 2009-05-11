Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbZEKJxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbZEKJxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZEKJxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:53:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53826 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757AbZEKJx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:29 -0400
Date: Mon, 11 May 2009 09:52:18 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A01C3BB.1000609@kernel.org>
References: <4A01C3BB.1000609@kernel.org>
Subject: [tip:irq/numa] x86: fix alloc_mptable()
Message-ID: <tip-ee214558c2e959781a406e76c5b34364da638e1d@git.kernel.org>
Git-Commit-ID: ee214558c2e959781a406e76c5b34364da638e1d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee214558c2e959781a406e76c5b34364da638e1d
Gitweb:     http://git.kernel.org/tip/ee214558c2e959781a406e76c5b34364da638e1d
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 10:07:07 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:35:07 +0200

x86: fix alloc_mptable()

Fix the conditions when we stop updating the mptable due to
running out of slots.

[ Impact: fix memory corruption / non-working update_mptable boot parameter ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C3BB.1000609@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 70fd7e4..cd2a41a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -870,24 +870,17 @@ static
 inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */
 
-static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
-		      int count)
+static int
+check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	if (!mpc_new_phys) {
-		pr_info("No spare slots, try to append...take your risk, "
-			"new mpc_length %x\n", count);
-	} else {
-		if (count <= mpc_new_length)
-			pr_info("No spare slots, try to append..., "
-				"new mpc_length %x\n", count);
-		else {
-			pr_err("mpc_new_length %lx is too small\n",
-				mpc_new_length);
-			return -1;
-		}
+	int ret = 0;
+
+	if (!mpc_new_phys || count <= mpc_new_length) {
+		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
+		return -1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
@@ -946,7 +939,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
