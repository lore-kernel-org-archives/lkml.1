Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZEFMBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZEFMBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEFMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:01:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14805 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZEFMBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:01:03 -0400
Message-Id: <4A01986B.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 06 May 2009 13:02:19 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix early_reserve_e820()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

If the first non-reserved (sub-)range doesn't fit the size requested,
an endless loop will be entered. If a range returned from
find_e820_area_size() turns out insufficient in size, the range must
be skipped before calling the function again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/e820.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.30-rc4/arch/x86/kernel/e820.c	2009-04-30 09:42:42.000000000 +0200
+++ 2.6.30-rc4-x86-early-reserve-e820/arch/x86/kernel/e820.c	2009-05-06 11:25:44.000000000 +0200
@@ -1074,12 +1074,13 @@ u64 __init early_reserve_e820(u64 startt
 	u64 addr;
 	u64 start;
 
-	start = startt;
-	while (size < sizet && (start + 1))
+	for (start = startt; ; start += size) {
 		start = find_e820_area_size(start, &size, align);
-
-	if (size < sizet)
-		return 0;
+		if (!(start + 1))
+			return 0;
+		if (size >= sizet)
+			break;
+	}
 
 #ifdef CONFIG_X86_32
 	if (start >= MAXMEM)



