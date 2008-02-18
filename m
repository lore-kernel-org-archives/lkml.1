Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYBRXWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYBRXWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbYBRXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:22:27 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:45828 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbYBRXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:22:26 -0500
Message-ID: <47BA132B.4050005@tiscali.nl>
Date: Tue, 19 Feb 2008 00:22:19 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: marcin.slusarz@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>	<1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com>	<47B2BB58.5040401@tiscali.nl> <20080215212815.26117a19.akpm@linux-foundation.org>
In-Reply-To: <20080215212815.26117a19.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Feb 2008 10:41:44 +0100 Roel Kluin <12o3l@tiscali.nl> wrote:
> 
>> you may also want these:
>> ---
>> [bl]e_add_cpu conversion in return

> upsets powerpc (at least):
> 
> fs/ufs/swab.h: In function `fs64_add':
> fs/ufs/swab.h:47: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> fs/ufs/swab.h:49: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> fs/ufs/swab.h: In function `fs64_sub':
> fs/ufs/swab.h:58: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> fs/ufs/swab.h:60: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type

sorry for this. Is it correct to cast like the patch below does?
If not (anyone) feel free to correct and send a patch yourself.
The patch below was *not* tested
---
[bl]e_add_cpu conversion in return (with cast)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
index 1683d2b..594d6e8 100644
--- a/fs/ufs/swab.h
+++ b/fs/ufs/swab.h
@@ -44,18 +44,22 @@ static __inline u32
 fs64_add(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
+		le64_add_cpu((__le64 *)n, d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
+		be64_add_cpu((__le64 *)n, d);
+
+	return *n;
 }
 
 static __inline u32
 fs64_sub(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
+		le64_add_cpu((__le64 *)n, -d);
 	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
+		be64_add_cpu((__le64 *)n, -d);
+
+	return *n;
 }
 
 static __inline u32
