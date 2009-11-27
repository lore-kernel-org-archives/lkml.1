Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZK0XId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZK0XId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZK0XIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:08:19 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60480 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbZK0XGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH v3 17/27] S390: use helpers for rlimits
Date: Sat, 28 Nov 2009 00:05:57 +0100
Message-Id: <1259363167-9347-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index f4558cc..0acf3aa 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -40,7 +40,7 @@
 
 static inline unsigned long mmap_base(void)
 {
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+	unsigned long gap = rlim_get_cur(RLIMIT_STACK);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
@@ -61,7 +61,7 @@ static inline int mmap_is_legacy(void)
 #endif
 	return sysctl_legacy_va_layout ||
 	    (current->personality & ADDR_COMPAT_LAYOUT) ||
-	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY;
+	    rlim_get_cur(RLIMIT_STACK) == RLIM_INFINITY;
 }
 
 #ifndef CONFIG_64BIT
-- 
1.6.5.3

