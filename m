Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZKHKCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZKHKCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZKHKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:02:41 -0500
Received: from gw1.transmode.se ([213.115.205.20]:41293 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZKHKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:02:40 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 05:02:40 EST
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] zlib: Optimize inffast when copying direct from output
Date: Sun, 8 Nov 2009 10:53:14 +0100
Message-Id: <1257673994-23175-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-08 10:53:17,
	Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-08 10:53:17,
	Serialize complete at 2009-11-08 10:53:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JFFS2 uses lesser compression ratio and inflate always
ends up in "copy direct from output" case.
This patch tries to optimize the copy procedure for
arch's that have CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS defined.
On my MPC8321 this is about 14% faster on my JFFS2 root FS
than the original.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/zlib_inflate/inffast.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index 8550b0c..0588fbf 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -240,6 +240,40 @@ void inflate_fast(z_streamp strm, unsigned start)
                 }
                 else {
                     from = out - dist;          /* copy direct from output */
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+                    /* minimum length is three */
+		    if (dist > 2 ) {
+			unsigned short *sout = (unsigned short *)(out - OFF);
+			unsigned short *sfrom = (unsigned short *)(from - OFF);
+			unsigned long loops = len >> 1;
+
+			do
+			    PUP(sout) = PUP(sfrom);
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			from = (unsigned char *)sfrom + OFF;
+			if (len & 1)
+			    PUP(out) = PUP(from);
+		    } else if (dist == 2) {
+			unsigned short *sout = (unsigned short *)(out - OFF);
+			unsigned short pat16;
+			unsigned long loops = len >> 1;
+
+			pat16 = *(sout-2+2*OFF);
+			do
+			    PUP(sout) = pat16;
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			if (len & 1)
+			    PUP(out) = PUP(from);
+		    } else {
+			unsigned char pat8 = *(out - 1 + OFF);
+
+			do {
+			    PUP(out) = pat8;
+			} while (--len);
+		    }
+#else
                     do {                        /* minimum length is three */
                         PUP(out) = PUP(from);
                         PUP(out) = PUP(from);
@@ -251,6 +285,7 @@ void inflate_fast(z_streamp strm, unsigned start)
                         if (len > 1)
                             PUP(out) = PUP(from);
                     }
+#endif
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
-- 
1.6.4.4

