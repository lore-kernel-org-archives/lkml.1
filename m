Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbXLRVyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbXLRVyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXLRVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:53:58 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:57679 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXLRVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:53:58 -0500
Message-ID: <4768416B.5030103@cosmosbay.com>
Date: Tue, 18 Dec 2007 22:53:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/extable.c : Removes an expensive integer divide in search_extable()
Content-Type: multipart/mixed;
 boundary="------------000304090204090207090905"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 18 Dec 2007 22:53:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000304090204090207090905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Actual code let compiler generates idiv instruction on x86.

Using a right shift is OK here and readable as well.

Before patch
   10:   57                      push   %edi
   11:   56                      push   %esi
   12:   89 d6                   mov    %edx,%esi
   14:   53                      push   %ebx
   15:   89 c3                   mov    %eax,%ebx
   17:   eb 22                   jmp    3b <search_extable+0x2b>
   19:   89 f0                   mov    %esi,%eax
   1b:   ba 02 00 00 00          mov    $0x2,%edx
   20:   29 d8                   sub    %ebx,%eax
   22:   89 d7                   mov    %edx,%edi
   24:   c1 f8 03                sar    $0x3,%eax
   27:   99                      cltd
   28:   f7 ff                   idiv   %edi
   2a:   8d 04 c3                lea    (%ebx,%eax,8),%eax
   2d:   39 08                   cmp    %ecx,(%eax)
...

After patch

00000010 <search_extable>:
   10:   53                      push   %ebx
   11:   89 c3                   mov    %eax,%ebx
   13:   eb 18                   jmp    2d <search_extable+0x1d>
   15:   89 d0                   mov    %edx,%eax
   17:   29 d8                   sub    %ebx,%eax
   19:   c1 f8 04                sar    $0x4,%eax
   1c:   8d 04 c3                lea    (%ebx,%eax,8),%eax
   1f:   39 08                   cmp    %ecx,(%eax)
...

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------000304090204090207090905
Content-Type: text/plain;
 name="extable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="extable.patch"

diff --git a/lib/extable.c b/lib/extable.c
index 463f456..179c087 100644
--- a/lib/extable.c
+++ b/lib/extable.c
@@ -57,10 +57,10 @@ search_extable(const struct exception_table_entry *first,
 	while (first <= last) {
 		const struct exception_table_entry *mid;
 
-		mid = (last - first) / 2 + first;
+		mid = ((last - first) >> 1) + first;
 		/*
-		 * careful, the distance between entries can be
-		 * larger than 2GB:
+		 * careful, the distance between value and insn
+		 * can be larger than MAX_LONG:
 		 */
 		if (mid->insn < value)
 			first = mid + 1;

--------------000304090204090207090905--
