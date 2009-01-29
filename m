Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZA2O5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZA2O5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZA2O45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:56:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZA2O44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:56:56 -0500
Subject: [PATCH] x86: add might_sleep() to do_page_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200901291541.32618.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291502.48312.frank.mehnert@sun.com>
	 <1233238854.4495.93.camel@laptop>
	 <200901291541.32618.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 15:56:43 +0100
Message-Id: <1233241003.4495.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VirtualBox calls do_page_fault() from an atomic context but runs into a
might_sleep() way pas this point, cure that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/fault.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 67e4df5..bb7f946 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -908,6 +908,11 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		}
 		down_read(&mm->mmap_sem);
 	}
+	/*
+	 * The above down_read_trylock() might have succeeded in which case
+	 * we'll have missed the might_sleep() from down_read().
+	 */
+	might_sleep();
 
 	vma = find_vma(mm, address);
 	if (unlikely(!vma)) {


