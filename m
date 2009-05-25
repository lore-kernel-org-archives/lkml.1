Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZEYDlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZEYDlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZEYDlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:41:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:60124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZEYDlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:41:03 -0400
Date: Mon, 25 May 2009 03:40:02 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A1A0A27.4050301@kernel.org>
References: <4A1A0A27.4050301@kernel.org>
Subject: [tip:x86/urgent] x86: Remove remap percpu allocator for the time being
Message-ID: <tip-71c9d8b68b299bef614afc7907393564a9f1476f@git.kernel.org>
Git-Commit-ID: 71c9d8b68b299bef614afc7907393564a9f1476f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 03:40:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71c9d8b68b299bef614afc7907393564a9f1476f
Gitweb:     http://git.kernel.org/tip/71c9d8b68b299bef614afc7907393564a9f1476f
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 25 May 2009 12:01:59 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 05:37:55 +0200

x86: Remove remap percpu allocator for the time being

Remap percpu allocator has subtle bug when combined with page
attribute changing.  Remap percpu allocator aliases PMD pages for the
first chunk and as pageattr doesn't know about the alias it ends up
updating page attributes of the original mapping thus leaving the
alises in inconsistent state which might lead to subtle data
corruption.  Please read the following threads for more information:

  http://thread.gmane.org/gmane.linux.kernel/835783

The following is the proposed fix which teaches pageattr about percpu
aliases.

  http://thread.gmane.org/gmane.linux.kernel/837157

However, the above changes are deemed too pervasive for upstream
inclusion for 2.6.30 release, so this patch essentially disables
the remap allocator for the time being.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4A1A0A27.4050301@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup_percpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..8f0e13b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -160,8 +160,10 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	/*
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
+	 *
+	 * NOTE: disabled for now.
 	 */
-	if (!cpu_has_pse || !pcpu_need_numa())
+	if (true || !cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	/*
