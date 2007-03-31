Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXCaBXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXCaBXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXCaBXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:23:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:19532 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265AbXCaBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oVLOOZNikmyP20I3wWu/8EawNXMdb0A8oGAiufbcXwDPM5Co6hk/YOl/Qmm4crY8Ce/fzNpP2B9+O1nV8ODR8/WNuYfO5BNF+1feJ9qfmmCvJXUCTMuiBIkvXeGvtYUfiRDGC5fFmIUjjy4X7ubvv+rl04bLLiWwjYdXc/yJLb0=
Subject: Re: drivers/video/aty/atyfb_base.c: array overruns
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
In-Reply-To: <20070319092246.GI752@stusta.de>
References: <20070319092246.GI752@stusta.de>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 09:23:29 +0800
Message-Id: <1175304210.4663.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 10:22 +0100, Adrian Bunk wrote:
> The Coverity checker spotted the following two array overruns in 
> drivers/video/aty/atyfb_base.c:
> 
> <--  snip  -->
> 
> ...
> static const u32 lt_lcd_regs[] = {
>         CONFIG_PANEL_LG,
>         LCD_GEN_CNTL_LG,
>         DSTN_CONTROL_LG,
>         HFB_PITCH_ADDR_LG,
>         HORZ_STRETCHING_LG,
>         VERT_STRETCHING_LG,
>         0, /* EXT_VERT_STRETCH */
>         LT_GIO_LG,
>         POWER_MANAGEMENT_LG
> };

We can pad this array with zeroes, as a stop-gap measure. Ville, what do
you think?

Tony

> 
> void aty_st_lcd(int index, u32 val, const struct atyfb_par *par)
> {
>         if (M64_HAS(LT_LCD_REGS)) {
>                 aty_st_le32(lt_lcd_regs[index], val, par);
> ...
> }
> ...
> u32 aty_ld_lcd(int index, const struct atyfb_par *par)
> {
>         if (M64_HAS(LT_LCD_REGS)) {
>                 return aty_ld_le32(lt_lcd_regs[index], par);
> ...
> }
> ...
> static int aty_bl_update_status(struct backlight_device *bd)
> {
>         struct atyfb_par *par = class_get_devdata(&bd->class_dev);
>         unsigned int reg = aty_ld_lcd(LCD_MISC_CNTL, par);
> ...
>         aty_st_lcd(LCD_MISC_CNTL, reg, par);
> 
>         return 0;
> }
> ...
> 
> <--  snip  -->
> 
> LCD_MISC_CNTL = 0x14 = 20 > 8
> 
> cu
> Adrian
> 

