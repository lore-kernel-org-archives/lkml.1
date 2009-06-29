Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZF2O4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZF2O4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbZF2O4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:56:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40501 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbZF2O4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:56:45 -0400
Subject: [PATCH] kmemleak: Inform kmemleak about pid_hash
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 29 Jun 2009 15:56:47 +0100
Message-ID: <20090629145339.21971.41509.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 14:56:47.0479 (UTC) FILETIME=[D35A3870:01C9F8C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemleak does not track alloc_bootmem calls but the pid_hash allocated
in pidhash_init() would need to be scanned as it contains pointers to
struct pid objects.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

FYI, tracking all alloc/free_bootmem calls in kmemleak was raised in the
past but this is not simple as alloc/reserve/free_bootmem aren't always
used as alloc/free pairs and this may confuse kmemleak. There are also
not many places where alloc_bootmem memory contains pointers to other
objects to be worth scanning.

 kernel/pid.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 31310b5..5fa1db4 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -36,6 +36,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
 #include <linux/syscalls.h>
+#include <linux/kmemleak.h>
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
@@ -512,6 +513,12 @@ void __init pidhash_init(void)
 	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
 	if (!pid_hash)
 		panic("Could not alloc pidhash!\n");
+	/*
+	 * pid_hash contains references to allocated struct pid objects and it
+	 * must be scanned by kmemleak to avoid false positives.
+	 */
+	kmemleak_alloc(pid_hash, pidhash_size *	sizeof(*(pid_hash)), 0,
+		       GFP_KERNEL);
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }

