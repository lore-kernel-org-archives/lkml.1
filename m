Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYJ2Q1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYJ2Q1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJ2Q1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:27:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:47632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYJ2Q1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:27:40 -0400
Date: Wed, 29 Oct 2008 09:27:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] corruption checker: print the DMI board name on corruption
Message-ID: <20081029092756.1e441b80@infradead.org>
In-Reply-To: <20081029091703.47628e54@infradead.org>
References: <20081029091703.47628e54@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

would you consider merging this patch for 2.6.28 still?
Without this patch, kerneloops.org only gets to see THAT corruption
happens, but doesn't have information about what kind of system the
corruption is happening on.. (which is the useful part to make a
DMI blacklist).

So far we have 1 such report in kerneloops.org but it's useless... no
system information.



>From c66993517ac861964d6968d3672f88b3b69e29ce Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 29 Oct 2008 09:24:44 -0700
Subject: [PATCH] corruption checker: print the DMI board name on corruption

when the memory corruptor checker hits (as it has done now based on
kerneloops.org data), it would be extremely useful to know the DMI board
name so we can add a blacklist for such a machine... without having to ask
the user for lots of extra info.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/setup.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..d57fee2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -697,6 +697,7 @@ void check_for_bios_corruption(void)
 {
 	int i;
 	int corruption = 0;
+	const char *board;
 
 	if (!memory_corruption_check)
 		return;
@@ -715,7 +716,11 @@ void check_for_bios_corruption(void)
 		}
 	}
 
-	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\nBoard name: %s\n",
+		board);
 }
 
 static void periodic_check_for_corruption(unsigned long data)
-- 
1.5.5.1

