Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZGKIWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZGKIWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZGKIWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:22:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:43022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZGKIWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:22:34 -0400
Date: Sat, 11 Jul 2009 08:22:00 GMT
From: tip-bot for Sonny Rao <sonnyrao@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sonnyrao@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sonnyrao@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090710231313.GA23572@us.ibm.com>
References: <20090710231313.GA23572@us.ibm.com>
Subject: [tip:core/urgent] futexes: Fix infinite loop in get_futex_key() on huge page
Message-ID: <tip-7c8fa4f04ab956076605422d5ed37410893a8a73@git.kernel.org>
Git-Commit-ID: 7c8fa4f04ab956076605422d5ed37410893a8a73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 08:22:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c8fa4f04ab956076605422d5ed37410893a8a73
Gitweb:     http://git.kernel.org/tip/7c8fa4f04ab956076605422d5ed37410893a8a73
Author:     Sonny Rao <sonnyrao@us.ibm.com>
AuthorDate: Fri, 10 Jul 2009 18:13:13 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 10:18:45 +0200

futexes: Fix infinite loop in get_futex_key() on huge page

get_futex_key() can infinitely loop if it is called on a
virtual address that is within a huge page but not aligned to
the beginning of that page.  The call to get_user_pages_fast
will return the struct page for a sub-page within the huge page
and the check for page->mapping will always fail.

The fix is to call compound_head on the page before checking
that it's mapped.

Signed-off-by: Sonny Rao <sonnyrao@us.ibm.com>
Cc: stable@kernel.org
Cc: anton@samba.org
Cc: rajamony@us.ibm.com
Cc: speight@us.ibm.com
Cc: mstephen@us.ibm.com
Cc: grimm@us.ibm.com
Cc: mikey@ozlabs.au.ibm.com
LKML-Reference: <20090710231313.GA23572@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 794c862..0672ff8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -247,6 +247,7 @@ again:
 	if (err < 0)
 		return err;
 
+	page = compound_head(page);
 	lock_page(page);
 	if (!page->mapping) {
 		unlock_page(page);
