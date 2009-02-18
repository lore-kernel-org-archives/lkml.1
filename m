Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZBRVhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZBRVhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZBRVfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:31 -0500
Received: from kroah.org ([198.145.64.141]:56085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754091AbZBRVfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:30 -0500
Date: Wed, 18 Feb 2009 13:32:19 -0800
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
Subject: [patch 04/39] powerpc/vsx: Fix VSX alignment handler for regs 32-63
Message-ID: <20090218213219.GE19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-vsx-fix-vsx-alignment-handler-for-regs-32-63.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 26456dcfb8d8e43b1b64b2a14710694cf7a72f05 upstream.

Fix the VSX alignment handler for VSX registers > 32.  32-63 are stored
in the VMX part of the thread_struct not the FPR part.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/align.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -646,11 +646,16 @@ static int emulate_vsx(unsigned char __u
 		       unsigned int areg, struct pt_regs *regs,
 		       unsigned int flags, unsigned int length)
 {
-	char *ptr = (char *) &current->thread.TS_FPR(reg);
+	char *ptr;
 	int ret = 0;
 
 	flush_vsx_to_thread(current);
 
+	if (reg < 32)
+		ptr = (char *) &current->thread.TS_FPR(reg);
+	else
+		ptr = (char *) &current->thread.vr[reg - 32];
+
 	if (flags & ST)
 		ret = __copy_to_user(addr, ptr, length);
         else {

