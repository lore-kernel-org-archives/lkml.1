Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZCOGNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZCOGNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCOGNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOGNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:13:06 -0400
Date: Sun, 15 Mar 2009 06:12:26 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49BC2279.2030101@kernel.org>
References: <49BC2279.2030101@kernel.org>
Subject: [tip:x86/mm] x86: fix 64k corruption-check
Message-ID: <tip-6d7942dc2a70a7e74c352107b150265602671588@git.kernel.org>
Git-Commit-ID: 6d7942dc2a70a7e74c352107b150265602671588
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 15 Mar 2009 06:12:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d7942dc2a70a7e74c352107b150265602671588
Gitweb:     http://git.kernel.org/tip/6d7942dc2a70a7e74c352107b150265602671588
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 14 Mar 2009 14:32:41 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Mar 2009 07:03:15 +0100

x86: fix 64k corruption-check

Impact: fix boot crash

Need to exit early if the addr is far above 64k.

The crash got exposed by:

  78a8b35: x86: make e820_update_range() handle small range update

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>
LKML-Reference: <49BC2279.2030101@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/check.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index b617b11..fc999e6 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -86,12 +86,12 @@ void __init setup_bios_corruption_check(void)
 		if (!(addr + 1))
 			break;
 
+		if (addr >= corruption_check_size)
+			break;
+
 		if ((addr + size) > corruption_check_size)
 			size = corruption_check_size - addr;
 
-		if (size == 0)
-			break;
-
 		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
 		scan_areas[num_scan_areas].addr = addr;
 		scan_areas[num_scan_areas].size = size;
