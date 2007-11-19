Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbXKSSXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbXKSSXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXKSSVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXKSSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:40 -0500
Date: Mon, 19 Nov 2007 10:18:30 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kiszka <jan.kiszka@web.de>, Dave Young <hidave.darkstar@gmail.com>
Subject: [patch 05/26] fix param_sysfs_builtin name length check
Message-ID: <20071119181830.GF15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-param_sysfs_builtin-name-length-check.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jan Kiszka <jan.kiszka@web.de>

patch 22800a2830ec07e7cc5c837999890ac47cc7f5de in mainline.

Commit faf8c714f4508207a9c81cc94dafc76ed6680b44 caused a regression:
parameter names longer than MAX_KBUILD_MODNAME will now be rejected,
although we just need to keep the module name part that short.  This patch
restores the old behaviour while still avoiding that memchr is called with
its length parameter larger than the total string length.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/params.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -591,19 +591,16 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
-		size_t kplen;
+		size_t max_name_len;
 
 		kp = &__start___param[i];
-		kplen = strlen(kp->name);
+		max_name_len =
+			min_t(size_t, MAX_KBUILD_MODNAME, strlen(kp->name));
 
-		/* We do not handle args without periods. */
-		if (kplen > MAX_KBUILD_MODNAME) {
-			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
-			continue;
-		}
-		dot = memchr(kp->name, '.', kplen);
+		dot = memchr(kp->name, '.', max_name_len);
 		if (!dot) {
-			DEBUGP("couldn't find period in %s\n", kp->name);
+			DEBUGP("couldn't find period in first %d characters "
+			       "of %s\n", MAX_KBUILD_MODNAME, kp->name);
 			continue;
 		}
 		name_len = dot - kp->name;

-- 
