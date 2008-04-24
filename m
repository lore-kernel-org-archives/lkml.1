Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYDXMzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYDXMzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYDXMyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:54:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:56448 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYDXMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:54:52 -0400
Date: Thu, 24 Apr 2008 16:54:50 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: unbreak OSF/1 (a.out) binaries
Message-ID: <20080424125450.GB5048@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSF/1 brk(2) was broken by following one-liner in sys_brk()
(commit 4cc6028d4040f95cdb590a87db478b42b8be0508):

-	if (brk < mm->end_code)
+	if (brk < mm->start_brk)
		goto out;

The problem is that osf_set_program_attributes()
does update mm->end_code, but not mm->start_brk,
which still contains inappropriate value left from
binary loader, so brk() always fails.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/osf_sys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 8c71daf..9fee37e 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -75,6 +75,7 @@ osf_set_program_attributes(unsigned long text_start, unsigned long text_len,
 	lock_kernel();
 	mm = current->mm;
 	mm->end_code = bss_start + bss_len;
+	mm->start_brk = bss_start + bss_len;
 	mm->brk = bss_start + bss_len;
 #if 0
 	printk("set_program_attributes(%lx %lx %lx %lx)\n",
