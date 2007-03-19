Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXCSJXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXCSJXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXCSJWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:22:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34819 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbXCSJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:22:42 -0400
Date: Mon, 19 Mar 2007 10:22:46 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Antonino Daplas <adaplas@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: drivers/video/aty/atyfb_base.c: array overruns
Message-ID: <20070319092246.GI752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following two array overruns in 
drivers/video/aty/atyfb_base.c:

<--  snip  -->

...
static const u32 lt_lcd_regs[] = {
        CONFIG_PANEL_LG,
        LCD_GEN_CNTL_LG,
        DSTN_CONTROL_LG,
        HFB_PITCH_ADDR_LG,
        HORZ_STRETCHING_LG,
        VERT_STRETCHING_LG,
        0, /* EXT_VERT_STRETCH */
        LT_GIO_LG,
        POWER_MANAGEMENT_LG
};

void aty_st_lcd(int index, u32 val, const struct atyfb_par *par)
{
        if (M64_HAS(LT_LCD_REGS)) {
                aty_st_le32(lt_lcd_regs[index], val, par);
...
}
...
u32 aty_ld_lcd(int index, const struct atyfb_par *par)
{
        if (M64_HAS(LT_LCD_REGS)) {
                return aty_ld_le32(lt_lcd_regs[index], par);
...
}
...
static int aty_bl_update_status(struct backlight_device *bd)
{
        struct atyfb_par *par = class_get_devdata(&bd->class_dev);
        unsigned int reg = aty_ld_lcd(LCD_MISC_CNTL, par);
...
        aty_st_lcd(LCD_MISC_CNTL, reg, par);

        return 0;
}
...

<--  snip  -->

LCD_MISC_CNTL = 0x14 = 20 > 8

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

