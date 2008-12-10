Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYLJXr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYLJXr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYLJXrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:47:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbYLJXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:47:00 -0500
Date: Wed, 10 Dec 2008 18:46:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org
cc: Henk Vergonet <Henk.Vergonet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove deprecated use of RW_LOCK_UNLOCKED in dvb frontends
Message-ID: <alpine.DEB.1.10.0812101844000.21545@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: cleanups


Steven Rostedt (1):
      remove deprecated use of RW_LOCK_UNLOCKED in dvb frontends

----
 drivers/media/dvb/frontends/drx397xD.c    |   12 ++++++------
 drivers/media/dvb/frontends/drx397xD_fw.h |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)
---------------------------
commit 3ca54b1298d8324890c2be66bca98db4d577b2f8
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 10 18:17:19 2008 -0500

    remove deprecated use of RW_LOCK_UNLOCKED in dvb frontends
    
    Impact: clean up
    
    RW_LOCK_UNLOCKED is deprecated. This patch replaces it with the
    __RW_LOCK_UNLOCKED(lock) macro. This change was a little trickier
    than others due to the macro being used in another macro that fills
    an array.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index b9ca5c8..ec4e08d 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -39,7 +39,7 @@ static const char mod_name[] = "drx397xD";
 #define F_SET_0D4h	2
 
 enum fw_ix {
-#define _FW_ENTRY(a, b)		b
+#define _FW_ENTRY(a, b, c)	b
 #include "drx397xD_fw.h"
 };
 
@@ -72,11 +72,11 @@ static struct {
 	int refcnt;
 	const u8 *data[ARRAY_SIZE(blob_name)];
 } fw[] = {
-#define _FW_ENTRY(a, b)		{			\
-			.name	= a,			\
-			.file	= 0,			\
-			.lock	= RW_LOCK_UNLOCKED,	\
-			.refcnt = 0,			\
+#define _FW_ENTRY(a, b, c)	{					\
+			.name	= a,					\
+			.file	= 0,					\
+			.lock	= __RW_LOCK_UNLOCKED(fw[c].lock),	\
+			.refcnt = 0,					\
 			.data	= { }		}
 #include "drx397xD_fw.h"
 };
diff --git a/drivers/media/dvb/frontends/drx397xD_fw.h b/drivers/media/dvb/frontends/drx397xD_fw.h
index 01de02a..c8b44c1 100644
--- a/drivers/media/dvb/frontends/drx397xD_fw.h
+++ b/drivers/media/dvb/frontends/drx397xD_fw.h
@@ -18,8 +18,8 @@
  */
 
 #ifdef _FW_ENTRY
-	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0		),
-	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1		),
+	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0,	DRXD_FW_A2	),
+	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1,	DRXD_FW_B1	),
 #undef _FW_ENTRY
 #endif /* _FW_ENTRY */
 

