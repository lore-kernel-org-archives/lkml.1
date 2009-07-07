Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZGGRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZGGRFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZGGRFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:05:38 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:3707 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZGGRFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:05:37 -0400
Date: Tue, 7 Jul 2009 19:15:16 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: atafb: fix regression with uninitalized fb_info->mm_lock mutex
Message-Id: <20090707191516.6451f936.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: bec0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant locking of the fb_info->mm_lock mutex before the frambuffer 
is registered.

This fixes a problem with uninitialized the fb_info->mm_lock mutex introduced 
by the commit 537a1bf059f " fbdev: add mutex for fb_mmap locking"

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 497ff8a..8cd279b 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -2405,6 +2405,9 @@ static int do_fb_set_var(struct fb_var_screeninfo *var, int isactive)
 	return 0;
 }
 
+/* fbhw->encode_fix() must be called with fb_info->mm_lock held
+ * if it is called after the register_framebuffer() - not a case here
+ */
 static int atafb_get_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
 {
 	struct atafb_par par;
@@ -2414,9 +2417,7 @@ static int atafb_get_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
 	if (err)
 		return err;
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-	mutex_lock(&info->mm_lock);
 	err = fbhw->encode_fix(fix, &par);
-	mutex_unlock(&info->mm_lock);
 	return err;
 }
 

----------------------------------------------------------------------
Ubezpieczenie komunikacyjne wraz z ubezpieczeniem 
kosztow leczenia za granic±. http://link.interia.pl/f222b

