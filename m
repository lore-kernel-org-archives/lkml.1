Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbYA2Snd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbYA2Snd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYA2SnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:43:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYA2SnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:43:24 -0500
Date: Tue, 29 Jan 2008 16:42:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Adrian Bunk <bunk@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m,	I2C=n
 compile error
Message-ID: <20080129164237.42ae5251@gaivota>
In-Reply-To: <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
References: <20080127185216.GB13300@does.not.exist>
	<20080127223334.696fce6e@gaivota>
	<20080128084001.GB1001@does.not.exist>
	<Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

> Also  only the function v4l2_i2c_attach() is a problem.  The other functions,
> like v4l2_chip_match_i2c_client(), which the patch put inside an #ifdef
> don't use any i2c symbols and don't need to be protected.
>  could even easily be used by a driver that doesn't
> need I2C.

True, but, with the exception of v4l2_chip_match_host(), all the others have
struct i2c_client as an argument. I can't see any valid usage where someone would
fill this struct when i2c is not supported.

---

I'm committing right now a patch that should properly fix the regression. I've
checked it with -git tree and seems to work properly to me.

The Kconfig changes become this way:

diff -r ea8b678dd436 -r 3f704aa9d92e linux/drivers/media/Kconfig
--- a/linux/drivers/media/Kconfig       Mon Jan 28 22:11:19 2008 +0000
+++ b/linux/drivers/media/Kconfig       Tue Jan 29 16:32:35 2008 -0200
@@ -24,6 +24,11 @@ config VIDEO_DEV

          To compile this driver as a module, choose M here: the
          module will be called videodev.
+
+config VIDEO_V4L2_COMMON
+       tristate
+       depends on (I2C || I2C=n) && VIDEO_DEV
+       default (I2C || I2C=n) && VIDEO_DEV

The "depends on" clause is equal to default. Probably, it can be safely
removed, but this way seems clearer to my eyes.

Based on my tests, it seems that "depends on" only works fine for values that
are prompted. If the value is not prompted, it just uses whatever declared on
"default".

I'll push the complete changeset to -hg and my -git tree (at devel branch).

Cheers,
Mauro.
