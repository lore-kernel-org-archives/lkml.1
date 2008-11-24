Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYKXMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYKXMTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKXMTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:19:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:31062 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYKXMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=WbfH8DTdYOXkPP+IRDQfZab2LVk5AYSZMa+G1YY/vDAprPRgXzAuqpO1eYm5Pgt6rQ
         jAgFnPtQAinqYITDv5PWfJFb8vYcTC9CrznFBStLLwi8U9FbEILAeQbLFKg2CCTB+91j
         n8HSzTPhtq0hQthyaxhABrY5qT9mE3j7rc7yU=
Date: Mon, 24 Nov 2008 13:20:13 +0100
To: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH -tip] kmemcheck: fix dynamic enable/disable
Message-ID: <20081124122013.GA24810@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ingo: Will send pull request for this later :-))


>From 6f505f59011e565c2dbb7a220702feb0447cc854 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 24 Nov 2008 11:52:05 +0100
Subject: [PATCH] kmemcheck: fix dynamic enable/disable

On Fri, Oct 10, 2008 at 1:40 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> I received a lot of errors after manually enabling kmemcheck
> in /proc (it had been turned off due to oneshot mode). It
> might be a good idea to put a warning that errrors found after
> enabling it at any time other than boot might be spurious.

Fixed. This was the problem: Instructions with multiple address
operands could look up the shadow of an address that had
previously been un-hidden. After handling the memory access, the
page would get hidden again. The fix is to verify that the page
is present before we return a shadow pointer.

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |   10 ++++++++++
 arch/x86/mm/kmemcheck/shadow.c    |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 056b4f1..12a4bbd 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -707,6 +707,16 @@ bool kmemcheck_trap(struct pt_regs *regs)
 	}
 
 	/*
+	 * At this point, we know that the trap was kmemcheck's. However, if
+	 * kmemcheck was disabled, we need to return immediately (and stop
+	 * emulating the REP instruction).
+	 */
+	if (!kmemcheck_enabled) {
+		kmemcheck_hide(regs);
+		return true;
+	}
+
+	/*
 	 * We're emulating a REP MOVS/STOS instruction. Are we done yet?
 	 * Of course, 64-bit needs to handle CX/ECX/RCX differently...
 	 */
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 196dddc..62a0f63 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -27,6 +27,8 @@ void *kmemcheck_shadow_lookup(unsigned long address)
 	pte = kmemcheck_pte_lookup(address);
 	if (!pte)
 		return NULL;
+	if (pte_present(*pte))
+		return NULL;
 
 	page = virt_to_page(address);
 	if (!page->shadow)
-- 
1.5.6.5

