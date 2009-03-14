Return-Path: <linux-kernel-owner+w=401wt.eu-S1764966AbZCNBuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764966AbZCNBuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZCNBVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:37 -0400
Received: from kroah.org ([198.145.64.141]:35623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754649AbZCNBVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:43 2009
Message-Id: <20090314011043.372383693@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 081/114] powerpc: Fix load/store float double alignment handler
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-fix-load-store-float-double-alignment-handler.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 49f297f8df9adb797334155470ea9ca68bdb041e upstream.

When we introduced VSX, we changed the way FPRs are stored in the
thread_struct.  Unfortunately we missed the load/store float double
alignment handler code when updating how we access FPRs in the
thread_struct.

Below fixes this and merges the little/big endian case.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/align.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -367,27 +367,24 @@ static int emulate_multiple(struct pt_re
 static int emulate_fp_pair(unsigned char __user *addr, unsigned int reg,
 			   unsigned int flags)
 {
-	char *ptr = (char *) &current->thread.TS_FPR(reg);
-	int i, ret;
+	char *ptr0 = (char *) &current->thread.TS_FPR(reg);
+	char *ptr1 = (char *) &current->thread.TS_FPR(reg+1);
+	int i, ret, sw = 0;
 
 	if (!(flags & F))
 		return 0;
 	if (reg & 1)
 		return 0;	/* invalid form: FRS/FRT must be even */
-	if (!(flags & SW)) {
-		/* not byte-swapped - easy */
-		if (!(flags & ST))
-			ret = __copy_from_user(ptr, addr, 16);
-		else
-			ret = __copy_to_user(addr, ptr, 16);
-	} else {
-		/* each FPR value is byte-swapped separately */
-		ret = 0;
-		for (i = 0; i < 16; ++i) {
-			if (!(flags & ST))
-				ret |= __get_user(ptr[i^7], addr + i);
-			else
-				ret |= __put_user(ptr[i^7], addr + i);
+	if (flags & SW)
+		sw = 7;
+	ret = 0;
+	for (i = 0; i < 8; ++i) {
+		if (!(flags & ST)) {
+			ret |= __get_user(ptr0[i^sw], addr + i);
+			ret |= __get_user(ptr1[i^sw], addr + i + 8);
+		} else {
+			ret |= __put_user(ptr0[i^sw], addr + i);
+			ret |= __put_user(ptr1[i^sw], addr + i + 8);
 		}
 	}
 	if (ret)


