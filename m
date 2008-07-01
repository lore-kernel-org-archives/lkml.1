Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYGALzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYGALzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYGALzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:55:33 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:55873 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYGALzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:55:32 -0400
Date: Tue, 1 Jul 2008 13:55:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@mail.ru>
cc: linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
Message-ID: <Pine.LNX.4.64.0807011300110.21227@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 656acd2bbc4ce7f224de499ee255698701396c48
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu Jun 26 11:30:02 2008 -0400

    Input: fix locking in force-feedback core

    The newly added event_lock spinlock in the input core disallows sleeping
    and therefore using mutexes in event handlers. Convert force-feedback 
    core to rely on event_lock instead of mutex to protect slots allocated  
    for fore-feedback effects. The original mutex is still used to serialize
    uploading and erasing of effects.

causes the following regression on m68k:

| linux/drivers/input/ff-core.c: In function 'input_ff_upload':
| linux/drivers/input/ff-core.c:172: error: dereferencing pointer to incomplete type
| linux/drivers/input/ff-core.c: In function 'erase_effect':
| linux/drivers/input/ff-core.c:197: error: dereferencing pointer to incomplete type
| linux/drivers/input/ff-core.c:204: error: dereferencing pointer to incomplete type
| make[4]: *** [drivers/input/ff-core.o] Error 1

As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/ff-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -28,6 +28,7 @@
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 /*
  * Check that the effect_id is a valid effect and whether the user

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
