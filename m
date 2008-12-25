Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYLZDZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYLZDZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYLZDZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:25:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYLZDZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:25:25 -0500
Date: Thu, 25 Dec 2008 21:24:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081225212459.4c7e31b4@caramujo.chehab.org>
In-Reply-To: <20081225081907.GA4628@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Dec 2008 09:19:07 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> FYI, v2.6.28 still fails to build with certain configs:
> 
>  drivers/media/dvb/built-in.o: In function `dib7000p_set_gpio':
>  (.text+0x3f242): multiple definition of `dib7000p_set_gpio'
>  drivers/media/video/built-in.o:(.text+0xb8c1e): first defined here
>  drivers/media/dvb/built-in.o: In function `dib7000p_i2c_enumeration':
>  (.text+0x3f282): multiple definition of `dib7000p_i2c_enumeration'
>  drivers/media/video/built-in.o:(.text+0xb8c3e): first defined here
>  drivers/media/dvb/built-in.o: In function `dib7000p_set_wbd_ref':
>  (.text+0x3f1c1): multiple definition of `dib7000p_set_wbd_ref'
>  drivers/media/video/built-in.o:(.text+0xb8bfe): first defined here
>    LD      drivers/net/built-in.o
>  make[2]: *** [drivers/media/built-in.o] Error 1
> 
> Config attached. The patch below works it around in tip/master. Can test 
> any patch for this bug.

Please test the enclosed patch.

Cheers,
Mauro

---
Kbuild: fix compilation when dib7000p is not defined

dib7000p.h defines a few extern symbols when CONFIG_DVB_DIB7000P is not set. since the
header is used on more than one driver, this causes symbol duplication, as pointed by
Ingo Molnar <mingo@elte.hu>:

drivers/media/dvb/built-in.o: In function `dib7000p_set_gpio':
(.text+0x3f242): multiple definition of `dib7000p_set_gpio'
drivers/media/video/built-in.o:(.text+0xb8c1e): first defined here
drivers/media/dvb/built-in.o: In function `dib7000p_i2c_enumeration':
(.text+0x3f282): multiple definition of `dib7000p_i2c_enumeration'
drivers/media/video/built-in.o:(.text+0xb8c3e): first defined here
drivers/media/dvb/built-in.o: In function `dib7000p_set_wbd_ref':
(.text+0x3f1c1): multiple definition of `dib7000p_set_wbd_ref'
drivers/media/video/built-in.o:(.text+0xb8bfe): first defined here
  LD      drivers/net/built-in.o
make[2]: *** [drivers/media/built-in.o] Error 1

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/dib7000p.h b/drivers/media/dvb/frontends/dib7000p.h
index 3e81268..aab8112 100644
--- a/drivers/media/dvb/frontends/dib7000p.h
+++ b/drivers/media/dvb/frontends/dib7000p.h
@@ -66,7 +66,8 @@ struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *fe,
 	return NULL;
 }
 
-extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c,
+static inline
+int dib7000p_i2c_enumeration(struct i2c_adapter *i2c,
 				    int no_of_demods, u8 default_addr,
 				    struct dib7000p_config cfg[])
 {
@@ -74,13 +75,15 @@ extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c,
 	return -ENODEV;
 }
 
-extern int dib7000p_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
+static inline
+int dib7000p_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -ENODEV;
 }
 
-extern int dib7000p_set_wbd_ref(struct dvb_frontend *fe, u16 value)
+static inline
+int dib7000p_set_wbd_ref(struct dvb_frontend *fe, u16 value)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -ENODEV;

