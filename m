Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZJSOtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZJSOtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbZJSOte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:49:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36936 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932136AbZJSOtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:49:32 -0400
Subject: [PATCH 2/4] kmemleak: Scan the _ftrace_events section in modules
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date: Mon, 19 Oct 2009 15:49:29 +0100
Message-ID: <20091019144928.14221.73541.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:49:29.0524 (UTC) FILETIME=[5C939740:01CA50CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This section contains pointers to allocated objects and not scanning it
leads to false positives.

Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/module.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1eb9520..dd29ba4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2380,6 +2380,12 @@ static noinline struct module *load_module(void __user *umod,
 					 "_ftrace_events",
 					 sizeof(*mod->trace_events),
 					 &mod->num_trace_events);
+	/*
+	 * This section contains pointers to allocated objects in the trace
+	 * code and not scanning it leads to false positives.
+	 */
+	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
+			   mod->num_trace_events, GFP_KERNEL);
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */

