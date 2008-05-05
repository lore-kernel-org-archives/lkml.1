Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbYEEUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbYEEUcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYEEUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:32:05 -0400
Received: from mx1.riseup.net ([204.13.164.18]:46514 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYEEUcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:32:03 -0400
Date: Mon, 5 May 2008 22:31:55 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
Message-ID: <20080505203154.GF11462@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
mutex. Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index bcb984f..db235ad 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -202,7 +202,7 @@ static struct omap_board_config_kernel nokia770_config[] __initdata = {
 #define	AMPLIFIER_CTRL_GPIO	58
 
 static struct clk *dspxor_ck;
-static DECLARE_MUTEX(audio_pwr_sem);
+static DEFINE_MUTEX(audio_pwr_lock);
 /*
  * audio_pwr_state
  * +--+-------------------------+---------------------------------------+
@@ -218,7 +218,7 @@ static DECLARE_MUTEX(audio_pwr_sem);
 static int audio_pwr_state = -1;
 
 /*
- * audio_pwr_up / down should be called under audio_pwr_sem
+ * audio_pwr_up / down should be called under audio_pwr_lock
  */
 static void nokia770_audio_pwr_up(void)
 {
@@ -237,11 +237,11 @@ static void nokia770_audio_pwr_up(void)
 
 static void codec_delayed_power_down(struct work_struct *work)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	if (audio_pwr_state == -1)
 		aic23_power_down();
 	clk_disable(dspxor_ck);
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 }
 
 static DECLARE_DELAYED_WORK(codec_power_down_work, codec_delayed_power_down);
@@ -258,19 +258,19 @@ static void nokia770_audio_pwr_down(void)
 static int
 nokia770_audio_pwr_up_request(struct dsp_kfunc_device *kdev, int stage)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	if (audio_pwr_state == -1)
 		nokia770_audio_pwr_up();
 	/* force audio_pwr_state = 0, even if it was 1. */
 	audio_pwr_state = 0;
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 	return 0;
 }
 
 static int
 nokia770_audio_pwr_down_request(struct dsp_kfunc_device *kdev, int stage)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	switch (stage) {
 	case 1:
 		if (audio_pwr_state == 0)
@@ -283,7 +283,7 @@ nokia770_audio_pwr_down_request(struct dsp_kfunc_device *kdev, int stage)
 		}
 		break;
 	}
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 	return 0;
 }
 
-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                If you don't know where you are going,
               you will probably end up somewhere else
                         (Laurence J. Peter)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
