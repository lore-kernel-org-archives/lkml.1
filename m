Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZGCGqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZGCGqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZGCGqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:46:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41458 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZGCGqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:46:02 -0400
Date: Fri, 3 Jul 2009 15:45:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] video: sm501fb: Early initialization of mm_lock mutex.
Message-ID: <20090703064555.GA8242@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 537a1bf059fa312355696fa6db80726e655e7f17 (fbdev: add mutex for
fb_mmap locking) introduces a ->mm_lock mutex for protecting smem
assignments. Unfortunately in the case of sm501fb these happen quite
early in the initialization code, well before the mutex_init() that takes
place in register_framebuffer(), leading to:

------------[ cut here ]------------
Badness at kernel/mutex.c:207

Pid : 1, Comm:          swapper
CPU : 0                 Not tainted  (2.6.31-rc1-00284-g529ba0d-dirty #2273)

PC is at __mutex_lock_slowpath+0x72/0x1bc
PR is at __mutex_lock_slowpath+0x66/0x1bc
...

matroxfb appears to have the same issue and has solved it with an early
mutex_init(), so we do the same for sm501fb.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>

---

 drivers/video/sm501fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 98f24f0..16d4f4c 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1624,6 +1624,8 @@ static int __devinit sm501fb_start_one(struct sm501fb_info *info,
 	if (!fbi)
 		return 0;
 
+	mutex_init(&info->fb[head]->mm_lock);
+
 	ret = sm501fb_init_fb(info->fb[head], head, drvname);
 	if (ret) {
 		dev_err(info->dev, "cannot initialise fb %s\n", drvname);
