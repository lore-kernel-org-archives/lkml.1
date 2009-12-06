Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZLFCEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZLFCEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZLFCEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:04:06 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:63657 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZLFCEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:04:06 -0500
From: Justin Madru <jdm64@gawab.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Justin Madru <jdm64@gawab.com>
Subject: [PATCH] staging: s5k3e2fx.c: reduce complexity by factoring
Date: Sat,  5 Dec 2009 18:03:20 -0800
Message-Id: <1260065000-5573-1-git-send-email-jdm64@gawab.com>
X-Mailer: git-send-email 1.6.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was style fixing some code when I ran into this code.
It seems like the code could be reduced, by factoring the expression.
But this results in a very simple expression.

Am I assuming something wrong? Or is this a bug in the original code?
This doesn't look right because the assignment of s_move[i] has no mention
of the loop counter.

Justin

------

the code was looping, seting s_move[i] to the following calculations

if (actual_step >= 0)
        s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
else
        s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);

but, by factoring the expression, it can be shown that they both reduce
to a very simple expression:

        s_move[i] = gain / 0x400;

Signed-off-by: Justin Madru <jdm64@gawab.com>
---
 drivers/staging/dream/camera/s5k3e2fx.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index f0e49be..d205a2d 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -1092,14 +1092,10 @@ static int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)
 
 	actual_step = step_direction * (int16_t)num_steps;
 	pos_offset = init_code + s5k3e2fx_ctrl->curr_lens_pos;
-	gain = actual_step * 0x400 / 5;
+	gain = actual_step / 5;
 
-	for (i = 0; i <= 4; i++) {
-		if (actual_step >= 0)
-			s_move[i] = ((((i+1)*gain+0x200) - (i*gain+0x200))/0x400);
-		else
-			s_move[i] = ((((i+1)*gain-0x200) - (i*gain-0x200))/0x400);
-	}
+	for (i = 0; i <= 4; i++)
+		s_move[i] = gain;
 
 	/* Ring Damping Code */
 	for (i = 0; i <= 4; i++) {
-- 
1.6.5.4

