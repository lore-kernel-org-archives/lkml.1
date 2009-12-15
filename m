Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbZLOUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbZLOUxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbZLOUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:53:34 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:50059 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760882AbZLOUxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:53:23 -0500
From: Justin Madru <jdm64@gawab.com>
To: linux-kernel@vger.kernel.org
Cc: Justin Madru <jdm64@gawab.com>, gregkh@suse.de, error27@gmail.com,
       ray-lk@madrabbit.org
Subject: [PATCH] staging: s5k3e2fx.c: simplify complexity by factoring
Date: Tue, 15 Dec 2009 12:52:10 -0800
Message-Id: <1260910330-3409-1-git-send-email-jdm64@gawab.com>
X-Mailer: git-send-email 1.6.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code was looping, seting s_move[i] to the following calculations

if (actual_step >= 0)
        s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
else
        s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);

but, this code redues to the expression
	s_move[i] = gain >> 10;

The reason for the complexity was to generate a step function with
integer division and rounding to land on specific values. But these calculations
can be simplified to the following code:

	gain = ((actual_step << 10) / 5) >> 10;
	for (i = 0; i <= 4; i++)
		s_move[i] = gain;
---
 drivers/staging/dream/camera/s5k3e2fx.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index edba198..66582af 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -1093,14 +1093,10 @@ static int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)
 
 	actual_step = step_direction * (int16_t)num_steps;
 	pos_offset = init_code + s5k3e2fx_ctrl->curr_lens_pos;
-	gain = actual_step * 0x400 / 5;
+	gain = ((actual_step << 10) / 5) >> 10;
 
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
1.6.5.6

