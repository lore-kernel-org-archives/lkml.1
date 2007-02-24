Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbXBXVNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbXBXVNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbXBXVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:13:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:57389 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbXBXVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:13:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=itkZK4W/46xigFuvQ4KRIRSwk+WDrbiBl/HoGV7bAzgWlFjfLT8CLrUGSdv1cF7NkR2a6A9db5qLXEismEBdH7PBi1pIeOyGlPTtkbjtzjj3byMmqF7lG3egReynBXR30LVDY6BN+ckUxV1gpTjxMfmglSxJV9NCJBCTX/AEjuk=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org> <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
	 <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-ClI4Ucv+fel4FdgErrnv"
Date: Sun, 25 Feb 2007 05:16:08 +0800
Message-Id: <1172351769.4415.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ClI4Ucv+fel4FdgErrnv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-02-24 at 10:16 +0100, Giuseppe Bilotta wrote:
> On 2/24/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Fri, 2007-02-23 at 14:34 +0100, Giuseppe Bilotta wrote:
> > >
> > > The snowy is constant and abundant, and it seems to be independent of
> > > video size (640 through 1600) and screen occupation (single prompt
> > > line to fullscreen mc session) and usage.
> > >
> > > > I presume that X's nv driver or vesafb does not exhibit this problem?
> > >
> > > X's nv gives a very clean display, /unless/ I load nvidiafb before: if
> > > I modprobe nvidiafb (it's a module, and it's blacklisted precisely for
> > > this reason), then the screen is very snowy with X's nv too.
> > >
> >
> > Hmm..., I really don't know how to fix this except to look at Xorg's
> > code and look for a difference.
> 
> Keep in mind that setting nvidiafb to totally ignore the EDID (either
> by not compiling in EDID support or by using e.g. the ignoreedid patch
> I had proposed) the snow effect is extremely reduced,

I did not know that, just scanned the entire thread. Try this patch, it
makes use of fb_ddc_read*() which I believe has extra steps to prevent
display corruption.  It also incorporates Luca's i2c fix.

Tony


--=-ClI4Ucv+fel4FdgErrnv
Content-Disposition: attachment; filename=nvidafb_generic_ddc
Content-Type: text/plain; name=nvidafb_generic_ddc; charset=utf-8
Content-Transfer-Encoding: 7bit

nvidiafb: Bring back generic ddc reading

Make nvidiafb use fb_ddc_read().  This patch was submitted before but was
reverted due to problems in a non-x86 platform.  This includes a fix for that
where ddc reading is bypassed if there is no DDC bus (duh).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

 drivers/video/nvidia/nv_i2c.c |   44 ++---------------------------------------
 1 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/nvidia/nv_i2c.c
index b858897..b91d404 100644
--- a/drivers/video/nvidia/nv_i2c.c
+++ b/drivers/video/nvidia/nv_i2c.c
@@ -70,8 +70,6 @@ static int nvidia_gpio_getscl(void *data
 	if (VGA_RD08(par->PCIO, 0x3d5) & 0x04)
 		val = 1;
 
-	val = VGA_RD08(par->PCIO, 0x3d5);
-
 	return val;
 }
 
@@ -159,51 +157,13 @@ void nvidia_delete_i2c_busses(struct nvi
 
 }
 
-static u8 *nvidia_do_probe_i2c_edid(struct nvidia_i2c_chan *chan)
-{
-	u8 start = 0x0;
-	struct i2c_msg msgs[] = {
-		{
-		 .addr = 0x50,
-		 .len = 1,
-		 .buf = &start,
-		 }, {
-		     .addr = 0x50,
-		     .flags = I2C_M_RD,
-		     .len = EDID_LENGTH,
-		     },
-	};
-	u8 *buf;
-
-	if (!chan->par)
-		return NULL;
-
-	buf = kmalloc(EDID_LENGTH, GFP_KERNEL);
-	if (!buf) {
-		dev_warn(&chan->par->pci_dev->dev, "Out of memory!\n");
-		return NULL;
-	}
-	msgs[1].buf = buf;
-
-	if (i2c_transfer(&chan->adapter, msgs, 2) == 2)
-		return buf;
-	dev_dbg(&chan->par->pci_dev->dev, "Unable to read EDID block.\n");
-	kfree(buf);
-	return NULL;
-}
-
 int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
 {
 	struct nvidia_par *par = info->par;
 	u8 *edid = NULL;
-	int i;
 
-	for (i = 0; i < 3; i++) {
-		/* Do the real work */
-		edid = nvidia_do_probe_i2c_edid(&par->chan[conn - 1]);
-		if (edid)
-			break;
-	}
+	if (par->chan[conn - 1].par)
+		edid = fb_ddc_read(&par->chan[conn - 1].adapter);
 
 	if (!edid && conn == 1) {
 		/* try to get from firmware */

--=-ClI4Ucv+fel4FdgErrnv--

