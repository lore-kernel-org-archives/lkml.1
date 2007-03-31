Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXCaOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXCaOpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 10:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXCaOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 10:45:24 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44202 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXCaOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 10:45:23 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 10:45:23 EDT
From: syrjala@sci.fi
Date: Sat, 31 Mar 2007 17:25:14 +0300
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/video/aty/atyfb_base.c: array overruns
Message-ID: <20070331142514.GA21030@sci.fi>
References: <20070319092246.GI752@stusta.de> <1175304210.4663.2.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1175304210.4663.2.camel@daplas>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 09:23:29AM +0800, Antonino A. Daplas wrote:
> On Mon, 2007-03-19 at 10:22 +0100, Adrian Bunk wrote:
> > The Coverity checker spotted the following two array overruns in 
> > drivers/video/aty/atyfb_base.c:
> > 
> > <--  snip  -->
> > 
> > ...
> > static const u32 lt_lcd_regs[] = {
> >         CONFIG_PANEL_LG,
> >         LCD_GEN_CNTL_LG,
> >         DSTN_CONTROL_LG,
> >         HFB_PITCH_ADDR_LG,
> >         HORZ_STRETCHING_LG,
> >         VERT_STRETCHING_LG,
> >         0, /* EXT_VERT_STRETCH */
> >         LT_GIO_LG,
> >         POWER_MANAGEMENT_LG
> > };
> 
> We can pad this array with zeroes, as a stop-gap measure. Ville, what do
> you think?

Actually this array overrun can never happen. LCD_MISC_CNTL is accessed
in the in the pmac backlight code and the backlight device is not
registered for the Rage LT chip (only user of lt_lcd_regs[]).

> > 
> > void aty_st_lcd(int index, u32 val, const struct atyfb_par *par)
> > {
> >         if (M64_HAS(LT_LCD_REGS)) {
> >                 aty_st_le32(lt_lcd_regs[index], val, par);
> > ...
> > }
> > ...
> > u32 aty_ld_lcd(int index, const struct atyfb_par *par)
> > {
> >         if (M64_HAS(LT_LCD_REGS)) {
> >                 return aty_ld_le32(lt_lcd_regs[index], par);
> > ...
> > }
> > ...
> > static int aty_bl_update_status(struct backlight_device *bd)
> > {
> >         struct atyfb_par *par = class_get_devdata(&bd->class_dev);
> >         unsigned int reg = aty_ld_lcd(LCD_MISC_CNTL, par);
> > ...
> >         aty_st_lcd(LCD_MISC_CNTL, reg, par);
> > 
> >         return 0;
> > }
> > ...
> > 
> > <--  snip  -->
> > 
> > LCD_MISC_CNTL = 0x14 = 20 > 8
> > 
> > cu
> > Adrian
> > 
> 

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
