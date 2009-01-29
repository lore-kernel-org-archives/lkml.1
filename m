Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZA2PCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZA2PCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZA2PCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:02:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:60144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZA2PCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:02:22 -0500
Subject: [PATCH v2] x86: add might_sleep() to do_page_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Mehnert <Frank.Mehnert@Sun.COM>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090129145921.GC6512@elte.hu>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291502.48312.frank.mehnert@sun.com>
	 <1233238854.4495.93.camel@laptop>
	 <200901291541.32618.frank.mehnert@sun.com>
	 <1233241003.4495.97.camel@laptop>  <20090129145921.GC6512@elte.hu>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 16:02:12 +0100
Message-Id: <1233241332.4495.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> should go into the 'else' branch i guess? In the down_read() case we 
> already had the check.

True.

---
VirtualBox calls do_page_fault() from an atomic context but runs into a
might_sleep() way pas this point, cure that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/fault.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 67e4df5..bfac289 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -907,6 +907,12 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 			return;
 		}
 		down_read(&mm->mmap_sem);
+	} else {
+		/*
+		 * The above down_read_trylock() might have succeeded in which
+		 * case we'll have missed the might_sleep() from down_read().
+		 */
+		might_sleep();
 	}
 
 	vma = find_vma(mm, address);


