Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978Ab0AMQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0AMQQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0AMQQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:16:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51157 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932109Ab0AMQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:16:45 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.33] s3c-fb: Fix handling of missing refresh in platform data
Date: Wed, 13 Jan 2010 16:16:42 +0000
Message-Id: <1263399402-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 600ce1a0faafeed1ce6bcfd421bc040b941cbbc1 ("fix clock setting
for Samsung SoC Framebuffer") introduced a mandatory refresh parameter
to the platform data for the S3C framebuffer but did not introduce any
validation code, causing existing platforms to divide by zero whenever
the framebuffer is configured, generating warnings and unusable output.

Add a WARN_ON(), in line with similar parameters, and check that we
have a non-zero refresh before we dividing by it. This gets usable
output on at least the SMDK6410, though without specifying a refresh
we see visible issues on some boots.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---

All mainline users of the s3c-fb driver are affected by this, none
provide refresh.

 drivers/video/s3c-fb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index adf9632..0f2e8f6 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -224,7 +224,8 @@ static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int
 	unsigned long clk = clk_get_rate(sfb->bus_clk);
 	unsigned int result;
 
-	pixclk *= win->win_mode.refresh;
+	if (win->win_mode.refresh)
+		pixclk *= win->win_mode.refresh;
 	result = clk / pixclk;
 
 	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
@@ -766,6 +767,7 @@ static int __devinit s3c_fb_probe_win(struct s3c_fb *sfb, unsigned int win_no,
 	WARN_ON(windata->max_bpp == 0);
 	WARN_ON(windata->win_mode.xres == 0);
 	WARN_ON(windata->win_mode.yres == 0);
+	WARN_ON(windata->win_mode.refresh == 0);
 
 	win = fbinfo->par;
 	var = &fbinfo->var;
-- 
1.6.6

