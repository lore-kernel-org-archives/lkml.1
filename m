Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0BMTs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:28 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:47287 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab0BMTsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PgpTUmRHbtiW3Is5jyZ2Jso+NbQPQpNBQ3S+OdfoA56JHsJm0A1LRBgG4fkdGWiq67
         l8P1kvOd15Mg5BEF7j7JFFifsmfX9fiClU1UIpqvvHcnPY6okrWjSUE4ITgJG+ICuhiy
         DeWF2gzy7Fycl1cSASoJdNp/kyb1qZAAvOq8U=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 03/10] ftrace: allow building without frame pointers
Date: Sun, 14 Feb 2010 01:18:31 +0530
Message-Id: <1266090518-31120-4-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current gcc, compiling with both -pg and -fomit-frame-pointer is
not allowed.  However, -pg can be used to build without actually
specying -fno-omit-frame-pointer, upon which the defaut behaviour for
the target will be used.

On ARM, it is not possible to build a Thumb-2 kernel with
-fno-omit-frame-pointer (FRAME_POINTERS depends on !THUMB2_KERNEL). In
order to support ftrace for Thumb-2, we need to be able to allow a
combination of FUNCTION_TRACER and !FRAME_POINTER.  We do this by
omitting -fomit-frame-pointer if ftrace is enabled.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 67d6cff..72d90de 100644
--- a/Makefile
+++ b/Makefile
@@ -546,8 +546,11 @@ endif
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
+ifndef CONFIG_FUNCTION_TRACER
+# -fomit-frame-pointer is incompatible with -pg
 KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
+endif
 
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
-- 
1.6.6

