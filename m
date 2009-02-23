Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZBWQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZBWQd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZBWQdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:33:45 -0500
Received: from mail.aknet.ru ([78.158.192.26]:50929 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbZBWQdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:33:44 -0500
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 11:33:44 EST
Message-ID: <49A2CB13.4080708@aknet.ru>
Date: Mon, 23 Feb 2009 19:13:07 +0300
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>,
       Chuck Ebbert <76306.1226@compuserve.com>
Subject: [patch] small fix to espfix code
Content-Type: multipart/mixed;
 boundary="------------040304000201060500030203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040304000201060500030203
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

The attached patch fixes a tiny
bug introduced by this patch:
http://lkml.org/lkml/2006/9/30/134
The patch was changing the espfix
stack to be 32bit instead of 16bit,
but this place seems to have been
overlooked.
The code was like this:
---
  	pushl %esp
  	movzwl %sp, %esp
  	addw $4, (%esp)
---
and the patch did:
---
  	pushl %esp
  	CFI_ADJUST_CFA_OFFSET 4
-	movzwl %sp, %esp
  	addw $4, (%esp)
---
but the addw was forgotten to adjust.

The bug is mostly theoretical, I can't
really test the effect of this patch.
So, it is completely untested.

---
Fix tiny bug in the espfix NMI handling
code. The bug was inroduced by this patch:
http://lkml.org/lkml/2006/9/30/134
and can practically never be triggered.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
CC: Zachary Amsden <zach@vmware.com>
CC: Chuck Ebbert <76306.1226@compuserve.com>

--------------040304000201060500030203
Content-Type: text/x-patch;
 name="espfix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="espfix.diff"

--- a/arch/x86/kernel/entry_32.S	2009-01-10 21:03:16.000000000 +0300
+++ b/arch/x86/kernel/entry_32.S	2009-02-15 22:34:23.000000000 +0300
@@ -881,7 +881,7 @@
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl %esp
 	CFI_ADJUST_CFA_OFFSET 4
-	addw $4, (%esp)
+	addl $4, (%esp)
 	/* copy the iret frame of 12 bytes */
 	.rept 3
 	pushl 16(%esp)

--------------040304000201060500030203--
