Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZKJDTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZKJDTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZKJDTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:19:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:40770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKJDTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:19:52 -0500
Date: Tue, 10 Nov 2009 03:19:28 GMT
From: tip-bot for Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sandmann@redhat.com,
       sandmann@daimi.au.dk, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sandmann@redhat.com, tglx@linutronix.de,
       sandmann@daimi.au.dk, mingo@elte.hu
In-Reply-To: <ye8zl7b8ktj.fsf@camel23.daimi.au.dk>
References: <ye8zl7b8ktj.fsf@camel23.daimi.au.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow
Message-ID: <tip-5ebd4c22897dce65845807a9bd3a31cc4e142b53@git.kernel.org>
Git-Commit-ID: 5ebd4c22897dce65845807a9bd3a31cc4e142b53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ebd4c22897dce65845807a9bd3a31cc4e142b53
Gitweb:     http://git.kernel.org/tip/5ebd4c22897dce65845807a9bd3a31cc4e142b53
Author:     Soeren Sandmann <sandmann@daimi.au.dk>
AuthorDate: Wed, 28 Oct 2009 18:55:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:15:32 +0100

highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow

debug_kmap_atomic() tries to prevent ever printing more than 10
warnings, but it does so by testing whether an unsigned integer
is equal to 0. However, if the warning is caused by a nested
IRQ, then this counter may underflow and the stream of warnings
will never end.

Fix that by using a signed integer instead.

Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl
Cc: <stable@kernel.org> # .31.x
LKML-Reference: <ye8zl7b8ktj.fsf@camel23.daimi.au.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/highmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 25878cc..33587de 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -426,9 +426,9 @@ void __init page_address_init(void)
 
 void debug_kmap_atomic(enum km_type type)
 {
-	static unsigned warn_count = 10;
+	static int warn_count = 10;
 
-	if (unlikely(warn_count == 0))
+	if (unlikely(warn_count < 0))
 		return;
 
 	if (unlikely(in_interrupt())) {
