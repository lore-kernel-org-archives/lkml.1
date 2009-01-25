Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZAYUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZAYUu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZAYUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:50:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:5631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZAYUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=c+0E/0+ahzzfsUpgVSzCNWwbtNE5L1jF2+p2+EXeP4cQ8Gel26D8htEzzyQTiqR7sq
         UrEjM5DIVWLnKSiEkBGDNcZiv/4lwYj+vZvID83iA06Lo4JGEN9wTo68iBMpc+fllOto
         AZCygXaqmXvTgE2sxv3Sr7CyfDmo60Sia82do=
Message-ID: <497cd085.2283420a.5373.49e7@mx.google.com>
Date: Sun, 25 Jan 2009 12:50:13 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] x86: optimize a bit __raw_read_trylock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of __raw_read_trylock starts with decrementing the lock
and read its new value as a separate operation after that.

That makes 3 dereferences (read, write (after sub), read) whereas
a single atomic_dec_return does only two pointers dereferences (read, write).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/spinlock.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 2bd6b11..139b424 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -267,8 +267,7 @@ static inline int __raw_read_trylock(raw_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
-	atomic_dec(count);
-	if (atomic_read(count) >= 0)
+	if (atomic_dec_return(count) >= 0)
 		return 1;
 	atomic_inc(count);
 	return 0;
-- 
1.6.1


