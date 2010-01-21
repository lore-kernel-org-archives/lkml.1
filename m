Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311Ab0AUEXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0AUEXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088Ab0AUEW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:22:57 -0500
Received: from kroah.org ([198.145.64.141]:60062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0AUEWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:32 2010
Message-Id: <20100121041832.851257947@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       InKi Dae <inki.dae@samsung.com>, Kyungmin Park <kmpark@infradead.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [03/30] revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit eb29a5cc0b601c458bae9df2f6c3696d75c2d383 upstream.

Fix divide by zero and broken output.  Commit 600ce1a0fa ("fix clock
setting for Samsung SoC Framebuffer") introduced a mandatory refresh
parameter to the platform data for the S3C framebuffer but did not
introduce any validation code, causing existing platforms (none of which
have refresh set) to divide by zero whenever the framebuffer is
configured, generating warnings and unusable output.

Ben Dooks noted several problems with the patch:

 - The platform data supplies the pixclk directly and should already
   have taken care of the refresh rate.
 - The addition of a window ID parameter doesn't help since only the
   root framebuffer can control the pixclk.
 - pixclk is specified in picoseconds (rather than Hz) as the patch
   assumed.

and suggests reverting the commit so do that.  Without fixing this no
mainline user of the driver will produce output.

[akpm@linux-foundation.org: don't revert the correct bit]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/s3c-fb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -211,21 +211,23 @@ static int s3c_fb_check_var(struct fb_va
 
 /**
  * s3c_fb_calc_pixclk() - calculate the divider to create the pixel clock.
- * @id: window id.
  * @sfb: The hardware state.
  * @pixclock: The pixel clock wanted, in picoseconds.
  *
  * Given the specified pixel clock, work out the necessary divider to get
  * close to the output frequency.
  */
-static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int pixclk)
+static int s3c_fb_calc_pixclk(struct s3c_fb *sfb, unsigned int pixclk)
 {
-	struct s3c_fb_pd_win *win = sfb->pdata->win[id];
 	unsigned long clk = clk_get_rate(sfb->bus_clk);
+	unsigned long long tmp;
 	unsigned int result;
 
-	pixclk *= win->win_mode.refresh;
-	result = clk / pixclk;
+	tmp = (unsigned long long)clk;
+	tmp *= pixclk;
+
+	do_div(tmp, 1000000000UL);
+	result = (unsigned int)tmp / 1000;
 
 	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
 		pixclk, clk, result, clk / result);
@@ -301,7 +303,7 @@ static int s3c_fb_set_par(struct fb_info
 	/* use window 0 as the basis for the lcd output timings */
 
 	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(win_no, sfb, var->pixclock);
+		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
 		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);


