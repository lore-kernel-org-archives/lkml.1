Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYKLXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYKLXEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYKLXD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:03:59 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54814 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYKLXD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:03:57 -0500
Date: Thu, 13 Nov 2008 00:06:36 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Message-ID: <20081112230636.GB17382@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112184956.GA17382@sortiz.org> <20081112200007.GA31451@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112200007.GA31451@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 08:00:07PM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2008 at 07:49:57PM +0100, Samuel Ortiz wrote:
> > On Mon, Nov 10, 2008 at 01:41:17PM +0000, Mark Brown wrote:
> 
> > > The vendor BSP used for the WM8350 development provided an I2C driver
> > > which incorrectly returned zero on succesful sends rather than the
> > > number of transmitted bytes, an error which was then propagated into the
> > > WM8350 I2C accessors.
> 
> > Shouldnt we fix the accessors behaviour instead ?
> > Currently, that would mean fixing some of the wm8350-core static functions.
> > Slightly bigger patch, but that would keep the i2c interface consistent.
> 
> I don't really understand what you mean by "keep the i2c interface
> consistent" here?  The purpose of this abstraction is to abstract away
> the control interface used to communicate with the chip since it
> supports both I2C and SPI.
I understand that. I'm just saying that I would prefer wm8350->read_dev() to
return the actual bytes read, be it for SPI or I2C. Same for write_dev(), of
course.
With this patch you're breaking that expectation because the read|write_dev()
callers basically expect it to return 0 when the you've read|written the right
number of bytes.
I'd prefer to fix the callers code, so that we keep the expected semantics
for your read|write_dev() routines. For example with wm8350_clear_bits():

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 0d47fb9..12ff3a6 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -199,19 +199,22 @@ static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
 int wm8350_clear_bits(struct wm8350 *wm8350, u16 reg, u16 mask)
 {
 	u16 data;
-	int err;
+	int err = 0, ret;
 
 	mutex_lock(&io_mutex);
-	err = wm8350_read(wm8350, reg, 1, &data);
-	if (err) {
+	ret = wm8350_read(wm8350, reg, 1, &data);
+	if (ret != 1) {
 		dev_err(wm8350->dev, "read from reg R%d failed\n", reg);
+		err = -EIO;
 		goto out;
 	}
 
 	data &= ~mask;
-	err = wm8350_write(wm8350, reg, 1, &data);
-	if (err)
+	ret = wm8350_write(wm8350, reg, 1, &data);
+	if (ret != 1) {
 		dev_err(wm8350->dev, "write to reg R%d failed\n", reg);
+		err = -EIO;
+	}
 out:
 	mutex_unlock(&io_mutex);
 	return err;


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
