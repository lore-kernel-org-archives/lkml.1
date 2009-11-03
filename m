Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKCTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKCTL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZKCTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:11:25 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35814 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZKCTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SeVDHNChD00XCCO8jjkS4B2sEp6tuwnNmwMR2HDzZcyDOsT9MQDNT/bEkv1tuJ1djD
         86VgfQI3eHQFHzkYgJWcBC0LLP2yNW49dmScd4yahNOSnsSTprgHuC8RcrCtzSKnkGDy
         6YMLR/7t6sYNRt58dHfByjDFyghecLHtQZNjs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().
Date: Tue,  3 Nov 2009 20:11:10 +0100
Message-Id: <1257275474-5285-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

flush_thread() tries to do a TIF_DEBUG check before calling in to
flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
but for some reason, the x86 code is manually clearing TIF_DEBUG
immediately before the test, so this path will never be taken.

This kills off the erroneous clear_tsk_thread_flag() and lets
flush_thread_hw_breakpoint() actually get invoked.

Presumably folks were getting lucky with testing and the
free_thread_info() -> free_thread_xstate() path was taking care of the
flush there.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>
LKML-Reference: <20091005102306.GA7889@linux-sh.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/process.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2275ce5..cf8ee00 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -107,8 +107,6 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
 		flush_thread_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-- 
1.6.2.3

