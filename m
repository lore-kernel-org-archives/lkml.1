Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbXH0Qyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbXH0Qyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXH0Qy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:54:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21642 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXH0Qy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:54:28 -0400
Date: Mon, 27 Aug 2007 16:02:12 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix maxcpus=N parsing
Message-ID: <Pine.LNX.4.64.0708271554570.21853@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 61ec7567db103d537329b0db9a887db570431ff4: maxcpus=N is now having no
effect on x86_64, and freezing bootup on i386 (because of inconsistency
with the separate maxcpus parsing down in arch/i386, I guess).  That's
because early_param parsing is a little different from __setup parsing,
and needs the "=" omitted: then it seems to work as the original commit
intended (no mention of IO-APIC in /proc/interrupts when maxcpus=0).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Sorry, I noticed this back in -mm, but got diverted by deeper mysteries.
Cc'ed Rusty: I presume there's a good reason why early_param parsing is
confusingly different, but he may know better and want to change it.

It's odd that i386 treats maxcpus=N differently from other architectures:
on i386 it limits cpu_possible_map, on others it just limits what boots
(then powersaved is liable to bring up the others on x86_64 - hmmm).

--- 2.6.23-rc3-git10/init/main.c	2007-08-26 18:10:20.000000000 +0100
+++ linux/init/main.c	2007-08-26 18:59:16.000000000 +0100
@@ -168,7 +168,7 @@ static int __init maxcpus(char *str)
 	return 0;
 }
 
-early_param("maxcpus=", maxcpus);
+early_param("maxcpus", maxcpus);
 #else
 #define max_cpus NR_CPUS
 #endif
