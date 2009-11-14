Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZKNDCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZKNDCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZKNDCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:02:53 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50609 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZKNDCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:02:52 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/HU4XF2NJXKRZ3/YLnQROW
Date: Fri, 13 Nov 2009 19:02:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       vikram pandita <vikram.pandita@ti.com>, linux-omap@atomide.com
Subject: Re: linux-next: manual merge of the sound tree with the omap tree
Message-ID: <20091114030248.GL3684@atomide.com>
References: <20091113131947.03d1b259.sfr@canb.auug.org.au>
 <20091113123901.GB30966@sirena.org.uk>
 <s5h1vk2po9n.wl%tiwai@suse.de>
 <20091113131148.GC21516@rakim.wolfsonmicro.main>
 <s5hzl6qo9c9.wl%tiwai@suse.de>
 <20091113204429.GE3684@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113204429.GE3684@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [091113 12:44]:
> * Takashi Iwai <tiwai@suse.de> [091113 05:13]:
> > At Fri, 13 Nov 2009 13:11:48 +0000,
> > Mark Brown wrote:
> > > 
> > > On Fri, Nov 13, 2009 at 02:06:44PM +0100, Takashi Iwai wrote:
> > > > Mark Brown wrote:
> > > 
> > > > > into the OMAP tree to resolve this.  There's some older ASoC changes in
> > > > > there to ensure the patches applied but I'm happy for you to carry those
> > > > > providing Takashi is.
> > > 
> > > > I can merge the tree above to for-next branch of sound git tree, too.
> > > > In that way, we can keep asoc branches clean.
> > > 
> > > I believe that creates the same problem both ways :/ .  If we merge
> > > OMAP->sound we may as well put it on the ASoC topic branch, it'll
> > > probably be helpful for people doing OMAP work anyway.
> > 
> > OK, in both ways I don't care...
> 
> I think this should get resolved if I git cherry-pick the following
> commits to linux-omap for-next:
> 
> MFD: twl4030: add twl4030_codec MFD as a new child to the core
> 0b83ddebc6e884dc0221358cf68c461520fbdd8e
> 
> OMAP: Platform support for twl4030_codec MFD
> f8d9aad96d0d7b57d0bf2e4de21fdda3a42f4449
> 
> OMAP: Configure audio_mclk for twl4030-codec MFD
> 953e2f3d272db9db6671ad4f4244820557a71cf7
> 
> Then I can tweak the sdp and zoom patches accordingly. So let's try
> that first, I'll try it out today.

OK, I ended up cherry-picking the following MFD commits to keep things
compiling:

$ git cherry-pick 0b83ddebc6e884dc0221358cf68c461520fbdd8e
$ git cherry-pick f8d9aad96d0d7b57d0bf2e4de21fdda3a42f4449
$ git cherry-pick cfd5324e699a2e74a44642d43dcf03d581f2a7db
$ git cherry-pick 953e2f3d272db9db6671ad4f4244820557a71cf7
$ git cherry-pick f9b4639e045c750e2bad37462476403995508350

Then I made the following changes to linux-omap for-next branch.
I will revert these changes as a fix after the merge window.

Without the patch below, there will still be conflicts. And
git mergetool ends up adding back the non-compiling entries
to board-zoom2.c.

But with the patch things work. So pulling

git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6 twl4030-mfd

to linux-omap for-next branch does not cause conflicts. So hopefully
it now works for Stephen too.

Regards,

Tony

--- b/arch/arm/mach-omap2/board-omap3evm.c
+++ a/arch/arm/mach-omap2/board-omap3evm.c
@@ -308,8 +308,6 @@ static struct twl4030_platform_data omap3evm_twldata = {
 	.usb		= &omap3evm_usb_data,
 	.gpio		= &omap3evm_gpio_data,
 	.codec		= &omap3evm_codec_data,
-	.vmmc1		= &omap3evm_vmmc1,
-	.vsim		= &omap3evm_vsim,
 };
 
 static struct i2c_board_info __initdata omap3evm_i2c_boardinfo[] = {
@@ -323,6 +321,13 @@ static struct i2c_board_info __initdata omap3evm_i2c_boardinfo[] = {
 
 static int __init omap3_evm_i2c_init(void)
 {
+	/*
+	 * REVISIT: These entries can be set in omap3evm_twl_data
+	 * after a merge with MFD tree
+	 */
+	omap3evm_twldata.vmmc1 = &omap3evm_vmmc1;
+	omap3evm_twldata.vsim = &omap3evm_vsim;
+
 	omap_register_i2c_bus(1, 2600, omap3evm_i2c_boardinfo,
 			ARRAY_SIZE(omap3evm_i2c_boardinfo));
 	omap_register_i2c_bus(2, 400, NULL, 0);
diff --git b/arch/arm/mach-omap2/board-zoom2.c a/arch/arm/mach-omap2/board-zoom2.c
index 3e88fcc..f2e66f3 100644
--- b/arch/arm/mach-omap2/board-zoom2.c
+++ a/arch/arm/mach-omap2/board-zoom2.c
@@ -36,6 +36,31 @@ static void __init omap_zoom2_init_irq(void)
 	omap_gpio_init();
 }
 
+/* REVISIT: These audio entries can be removed once MFD code is merged */
+#if 0
+
+static struct twl4030_madc_platform_data zoom2_madc_data = {
+	.irq_line	= 1,
+};
+
+static struct twl4030_platform_data zoom2_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.bci		= &zoom2_bci_data,
+	.madc		= &zoom2_madc_data,
+	.usb		= &zoom2_usb_data,
+	.gpio		= &zoom2_gpio_data,
+	.keypad		= &zoom2_kp_twl4030_data,
+	.vmmc1          = &zoom2_vmmc1,
+	.vmmc2          = &zoom2_vmmc2,
+	.vsim           = &zoom2_vsim,
+
+};
+
+#endif
+
 extern int __init omap_zoom2_debugboard_init(void);
 extern void __init zoom_peripherals_init(void);
 
