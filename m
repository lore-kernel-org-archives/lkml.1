Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbYETQQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbYETQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933867AbYETQQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:16:47 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:3382 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877AbYETQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:16:43 -0400
Message-ID: <4832F956.90708@linuxtv.org>
From: mkrufky@linuxtv.org
To: mingo@elte.hu
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, pb@linuxtv.org,
       Stoth@hauppauge.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [patch] fix build error in	drivers/media/video/cx23885/cx2388
	5-dvb.c
Date: Tue, 20 May 2008 12:16:22 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080520153248.GA13562@elte.hu>
x-originalarrivaltime: 20 May 2008 16:12:10.0476 (UTC) FILETIME=[41F80AC0:01C8BA94]
user-agent: Thunderbird 2.0.0.14 (Windows/20080421)
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C8BA94.41AF6900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C8BA94.41AF6900
Content-Type: text/plain;
	charset="iso-8859-1"

Please see below, proper patch attached...

Ingo Molnar wrote:
> testing of the -tip tree found the following module build failure on 
> latest -git:
>
>     Building modules, stage 2.
>     MODPOST 421 modules
>     ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko]
undefined!
>     make[1]: *** [__modpost] Error 1
>     make: *** [modules] Error 2
>
> with the following config:
>
>     http://redhat.com/~mingo/misc/config-Tue_May_20_17_13_32_CEST_2008.bad
>
> the problem is caused that ./drivers/media/video/cx23885/cx23885-dvb.c
> depends on a DVB_DIB7000P symbol (dib7000p_attach), but its Kconfig rule
> only selects it if DVB_FE_CUSTOMISE is enabled:
>
>        select DVB_DIB7000P if !DVB_FE_CUSTOMISE
>
> the minimal fix found is to select the DVB frontend driver
unconditionally.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/video/cx23885/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/media/video/cx23885/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/video/cx23885/Kconfig
> +++ linux/drivers/media/video/cx23885/Kconfig
> @@ -11,7 +11,7 @@ config VIDEO_CX23885
>  	select VIDEOBUF_DVB
>  	select VIDEO_CX25840
>  	select VIDEO_CX2341X
> -	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
> +	select DVB_DIB7000P
>  	select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
>  	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
>  	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
>
>   

Ingo,

Your patch will work around a symptom of the problem, but this is not 
the proper fix.

Please see the attached patch, which should be applied, instead.

Thanks for pointing this out.

Regards,

Mike Krufky



------_=_NextPart_000_01C8BA94.41AF6900
Content-Type: text/plain;
	name="dib7000p-attach.patch"
Content-Disposition: attachment;
	filename="dib7000p-attach.patch"

dib7000p: fix dib7000p_attach when !CONFIG_DVB_DIB7000P

somebody forgot to to fix this header...

Thanks to Ingo Molnar for pointing this out.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

---
 linux/drivers/media/dvb/frontends/dib7000p.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/dib7000p.h
+++ v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.h
@@ -37,7 +37,20 @@
 
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
 
-extern struct dvb_frontend * dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
+#if defined(CONFIG_DVB_DIB7000P) || (defined(CONFIG_DVB_DIB7000P_MODULE) && defined(MODULE))
+extern struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap,
+					    u8 i2c_addr,
+					    struct dib7000p_config *cfg);
+#else
+static inline struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap,
+						   u8 i2c_addr,
+						   struct dib7000p_config *cfg)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
 extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
 
 extern struct i2c_adapter * dib7000p_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);

------_=_NextPart_000_01C8BA94.41AF6900--
