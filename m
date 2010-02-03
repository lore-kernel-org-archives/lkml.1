Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0BCIrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:47:36 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:56969 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab0BCIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I+MKYEG6bdcYMDYlUKqOsKvqZJ7b9jjffppPjugqPjmyp7LN/Zlso3WBaSycZWBlJT
         MBXneBjNYntWZ3Z5xtx/X4dAMhgtOb+znZxhhMkGu6Op9GtsyO7JDbHqU9Uk38zwxccr
         opvd56KJtw2w6qkhGFi5EyNbZKHgWTelo4ez4=
Date: Wed, 3 Feb 2010 00:47:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastian Blank <waldi@debian.org>, Ping Cheng <pingc@wacom.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Childs <oblivian@users.sourceforge.net>
Subject: Re: [PATCH 5/7] Input: wacom - Convert remaining ids, part two
Message-ID: <20100203084725.GB22110@core.coreip.homeip.net>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
 <20100107182953.GA12985@wavehammer.waldi.eu.org>
 <6753EB6004AFF34FAA275742C104F952016A1329@wacom-nt10.wacom.com>
 <20100111222448.GA7959@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111222448.GA7959@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 11:24:48PM +0100, Bastian Blank wrote:
> Please fix your MUA, it should break lines to below 80 characters.
> 
> On Mon, Jan 11, 2010 at 01:22:31PM -0800, Ping Cheng wrote:
> > Can we only move the struct wacom_features definition to wacom_sys.c
> > and leave the device specific wacom_features in wacom_wac.c?
> 
> The driver is so small. I don't see any reason to split that at all.
> 
> >                                                               Also
> > leave the actual wacom_ids [] in wacom_wac.c as well since they are
> > wacom specific stuff.
> 
> No, this are USB id mappings, Linux specific ones.
> 
> >                        We'd like to keep wacom specific stuff in
> > wacom_wac.c/h, which hopefully can be shared among kernel releases.
> 
> The two parts are not properly seperated, none of them can stand on its
> own. How exactly do you want to do that?
> 

OK, so I got a chance to review the series again. I can see Ping's point
of wanting to separate USB interface code form actial wacom-specific
part of the driver. This eases her task of maintaining driver that supports
several versions shince her changes usually touch wacom_wac.c while
kernel devs usually touch wacom_sys.

In the end I folded everything together and ended up with the patch
below. It should functionally be the same so I kept tested-by tag but
I'd appreciate if you could give it another spin.

Re: constifying - we should mark all wacom_features_0x24 as const. As a
side effect this will force us to fix the fact that we modify static
wacom_features instances in wacom_retrieve_hid_descriptor() which
means that the driver may not properly work with 2 devices with the
same product ID connected to the box if they happen to have
different dimansion (could they?).

Thanks.

-- 
Dmitry


Input: wacom - get features from driver info

From: Bastian Blank <waldi@debian.org>

Get the features information from the driver info of the usb device id
structure provided by the caller. The device ids and feature structs
are strong coupled using indices.

Signed-off-by: Bastian Blank <waldi@debian.org>
Tested-by: Jason Childs <oblivian@users.sourceforge.net>
Acked-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/tablet/wacom.h     |    5 -
 drivers/input/tablet/wacom_sys.c |   10 +
 drivers/input/tablet/wacom_wac.c |  342 ++++++++++++++++++++++----------------
 3 files changed, 205 insertions(+), 152 deletions(-)


diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 16310f3..8fef1b6 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -85,6 +85,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/init.h>
 #include <linux/usb/input.h>
 #include <asm/unaligned.h>
@@ -120,6 +121,8 @@ struct wacom_combo {
 	struct urb *urb;
 };
 
+extern const struct usb_device_id wacom_ids[];
+
 extern int wacom_wac_irq(struct wacom_wac * wacom_wac, void * wcombo);
 extern void wacom_report_abs(void *wcombo, unsigned int abs_type, int abs_data);
 extern void wacom_report_rel(void *wcombo, unsigned int rel_type, int rel_data);
@@ -142,7 +145,5 @@ extern void input_dev_mo(struct input_dev *input_dev, struct wacom_wac *wacom_wa
 extern void input_dev_bee(struct input_dev *input_dev, struct wacom_wac *wacom_wac);
 extern __u16 wacom_le16_to_cpu(unsigned char *data);
 extern __u16 wacom_be16_to_cpu(unsigned char *data);
-extern struct wacom_features *get_wacom_feature(const struct usb_device_id *id);
-extern const struct usb_device_id *get_device_table(void);
 
 #endif
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 072f33b..be4b76f 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -530,10 +530,13 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	struct usb_endpoint_descriptor *endpoint;
 	struct wacom *wacom;
 	struct wacom_wac *wacom_wac;
-	struct wacom_features *features;
+	struct wacom_features *features = (void *)id->driver_info;
 	struct input_dev *input_dev;
 	int error = -ENOMEM;
 
+	if (!features)
+		return -EINVAL;
+
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
 	wacom_wac = kzalloc(sizeof(struct wacom_wac), GFP_KERNEL);
 	input_dev = input_allocate_device();
@@ -555,7 +558,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
 	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
-	wacom_wac->features = features = get_wacom_feature(id);
+	wacom_wac->features = features;
 	BUG_ON(features->pktlen > WACOM_PKGLEN_MAX);
 
 	input_dev->name = wacom_wac->features->name;
@@ -663,6 +666,7 @@ static int wacom_reset_resume(struct usb_interface *intf)
 
 static struct usb_driver wacom_driver = {
 	.name =		"wacom",
+	.id_table =	wacom_ids,
 	.probe =	wacom_probe,
 	.disconnect =	wacom_disconnect,
 	.suspend =	wacom_suspend,
@@ -674,7 +678,7 @@ static struct usb_driver wacom_driver = {
 static int __init wacom_init(void)
 {
 	int result;
-	wacom_driver.id_table = get_device_table();
+
 	result = usb_register(&wacom_driver);
 	if (result == 0)
 		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 1056f14..56aaf01 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -903,153 +903,201 @@ void wacom_init_input_dev(struct input_dev *input_dev, struct wacom_wac *wacom_w
 	return;
 }
 
-static struct wacom_features wacom_features[] = {
-	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER },
-	{ "Wacom Graphire",       WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire2 4x5",  WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire2 5x7",  WACOM_PKGLEN_GRAPHIRE,  13918, 10206,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire3",      WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire3 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire4 4x5",  WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, WACOM_G4 },
-	{ "Wacom Graphire4 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, WACOM_G4 },
-	{ "Wacom BambooFun 4x5",  WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
-	{ "Wacom BambooFun 6x8",  WACOM_PKGLEN_BBFUN,     21648, 13530,  511, 63, WACOM_MO },
-	{ "Wacom Bamboo1 Medium", WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
-	{ "Wacom Volito",         WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom PenStation2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  255, 63, GRAPHIRE },
-	{ "Wacom Volito2 4x5",    WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom Volito2 2x3",    WACOM_PKGLEN_GRAPHIRE,   3248,  2320,  511, 63, GRAPHIRE },
-	{ "Wacom PenPartner2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  511, 63, GRAPHIRE },
-	{ "Wacom Bamboo",         WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
-	{ "Wacom Bamboo1",        WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom Intuos 4x5",     WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
-	{ "Wacom Intuos 6x8",     WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ "Wacom Intuos 9x12",    WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
-	{ "Wacom Intuos 12x12",   WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos 12x18",   WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
-	{ "Wacom PL400",          WACOM_PKGLEN_GRAPHIRE,   5408,  4056,  255,  0, PL },
-	{ "Wacom PL500",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  255,  0, PL },
-	{ "Wacom PL600",          WACOM_PKGLEN_GRAPHIRE,   6126,  4604,  255,  0, PL },
-	{ "Wacom PL600SX",        WACOM_PKGLEN_GRAPHIRE,   6260,  5016,  255,  0, PL },
-	{ "Wacom PL550",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  511,  0, PL },
-	{ "Wacom PL800",          WACOM_PKGLEN_GRAPHIRE,   7220,  5780,  511,  0, PL },
-	{ "Wacom PL700",          WACOM_PKGLEN_GRAPHIRE,   6758,  5406,  511,  0, PL },
-	{ "Wacom PL510",          WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
-	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,  0, PL },
-	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
-	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
-	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
-	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU },
-	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S },
-	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 },
-	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L },
-	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L },
-	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ },
-	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE },
-	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE },
-	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL },
-	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
+static struct wacom_features wacom_features_0x00 =
+	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER };
+static struct wacom_features wacom_features_0x10 =
+	{ "Wacom Graphire",       WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x11 =
+	{ "Wacom Graphire2 4x5",  WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x12 =
+	{ "Wacom Graphire2 5x7",  WACOM_PKGLEN_GRAPHIRE,  13918, 10206,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x13 =
+	{ "Wacom Graphire3",      WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x14 =
+	{ "Wacom Graphire3 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x15 =
+	{ "Wacom Graphire4 4x5",  WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, WACOM_G4 };
+static struct wacom_features wacom_features_0x16 =
+	{ "Wacom Graphire4 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, WACOM_G4 };
+static struct wacom_features wacom_features_0x17 =
+	{ "Wacom BambooFun 4x5",  WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x18 =
+	{ "Wacom BambooFun 6x8",  WACOM_PKGLEN_BBFUN,     21648, 13530,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x19 =
+	{ "Wacom Bamboo1 Medium", WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x60 =
+	{ "Wacom Volito",         WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x61 =
+	{ "Wacom PenStation2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  255, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x62 =
+	{ "Wacom Volito2 4x5",    WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x63 =
+	{ "Wacom Volito2 2x3",    WACOM_PKGLEN_GRAPHIRE,   3248,  2320,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x64 =
+	{ "Wacom PenPartner2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x65 =
+	{ "Wacom Bamboo",         WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x69 =
+	{ "Wacom Bamboo1",        WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x20 =
+	{ "Wacom Intuos 4x5",     WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x21 =
+	{ "Wacom Intuos 6x8",     WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x22 =
+	{ "Wacom Intuos 9x12",    WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x23 =
+	{ "Wacom Intuos 12x12",   WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x24 =
+	{ "Wacom Intuos 12x18",   WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x30 =
+	{ "Wacom PL400",          WACOM_PKGLEN_GRAPHIRE,   5408,  4056,  255,  0, PL };
+static struct wacom_features wacom_features_0x31 =
+	{ "Wacom PL500",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  255,  0, PL };
+static struct wacom_features wacom_features_0x32 =
+	{ "Wacom PL600",          WACOM_PKGLEN_GRAPHIRE,   6126,  4604,  255,  0, PL };
+static struct wacom_features wacom_features_0x33 =
+	{ "Wacom PL600SX",        WACOM_PKGLEN_GRAPHIRE,   6260,  5016,  255,  0, PL };
+static struct wacom_features wacom_features_0x34 =
+	{ "Wacom PL550",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  511,  0, PL };
+static struct wacom_features wacom_features_0x35 =
+	{ "Wacom PL800",          WACOM_PKGLEN_GRAPHIRE,   7220,  5780,  511,  0, PL };
+static struct wacom_features wacom_features_0x37 =
+	{ "Wacom PL700",          WACOM_PKGLEN_GRAPHIRE,   6758,  5406,  511,  0, PL };
+static struct wacom_features wacom_features_0x38 =
+	{ "Wacom PL510",          WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL };
+static struct wacom_features wacom_features_0x39 =
+	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,  0, PL };
+static struct wacom_features wacom_features_0xC4 =
+	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL };
+static struct wacom_features wacom_features_0xC0 =
+	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL };
+static struct wacom_features wacom_features_0xC2 =
+	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL };
+static struct wacom_features wacom_features_0x03 =
+	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU };
+static struct wacom_features wacom_features_0x41 =
+	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x42 =
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x43 =
+	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x44 =
+	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x45 =
+	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0xB0 =
+	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S };
+static struct wacom_features wacom_features_0xB1 =
+	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB2 =
+	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB3 =
+	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L };
+static struct wacom_features wacom_features_0xB4 =
+	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L };
+static struct wacom_features wacom_features_0xB5 =
+	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB7 =
+	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S };
+static struct wacom_features wacom_features_0xB8 =
+	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S };
+static struct wacom_features wacom_features_0xB9 =
+	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 };
+static struct wacom_features wacom_features_0xBA =
+	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L };
+static struct wacom_features wacom_features_0xBB =
+	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L };
+static struct wacom_features wacom_features_0x3F =
+	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ };
+static struct wacom_features wacom_features_0xC5 =
+	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE };
+static struct wacom_features wacom_features_0xC6 =
+	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE };
+static struct wacom_features wacom_features_0xC7 =
+	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL };
+static struct wacom_features wacom_features_0x90 =
+	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x93 =
+	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x9A =
+	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x9F =
+	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0xE2 =
+	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
+static struct wacom_features wacom_features_0xE3 =
+	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
+static struct wacom_features wacom_features_0x47 =
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+
+#define USB_DEVICE_WACOM(prod)					\
+	USB_DEVICE(USB_VENDOR_ID_WACOM, prod),			\
+	.driver_info = (kernel_ulong_t)&wacom_features_##prod
+
+const struct usb_device_id wacom_ids[] = {
+	{ USB_DEVICE_WACOM(0x00) },
+	{ USB_DEVICE_WACOM(0x10) },
+	{ USB_DEVICE_WACOM(0x11) },
+	{ USB_DEVICE_WACOM(0x12) },
+	{ USB_DEVICE_WACOM(0x13) },
+	{ USB_DEVICE_WACOM(0x14) },
+	{ USB_DEVICE_WACOM(0x15) },
+	{ USB_DEVICE_WACOM(0x16) },
+	{ USB_DEVICE_WACOM(0x17) },
+	{ USB_DEVICE_WACOM(0x18) },
+	{ USB_DEVICE_WACOM(0x19) },
+	{ USB_DEVICE_WACOM(0x60) },
+	{ USB_DEVICE_WACOM(0x61) },
+	{ USB_DEVICE_WACOM(0x62) },
+	{ USB_DEVICE_WACOM(0x63) },
+	{ USB_DEVICE_WACOM(0x64) },
+	{ USB_DEVICE_WACOM(0x65) },
+	{ USB_DEVICE_WACOM(0x69) },
+	{ USB_DEVICE_WACOM(0x20) },
+	{ USB_DEVICE_WACOM(0x21) },
+	{ USB_DEVICE_WACOM(0x22) },
+	{ USB_DEVICE_WACOM(0x23) },
+	{ USB_DEVICE_WACOM(0x24) },
+	{ USB_DEVICE_WACOM(0x30) },
+	{ USB_DEVICE_WACOM(0x31) },
+	{ USB_DEVICE_WACOM(0x32) },
+	{ USB_DEVICE_WACOM(0x33) },
+	{ USB_DEVICE_WACOM(0x34) },
+	{ USB_DEVICE_WACOM(0x35) },
+	{ USB_DEVICE_WACOM(0x37) },
+	{ USB_DEVICE_WACOM(0x38) },
+	{ USB_DEVICE_WACOM(0x39) },
+	{ USB_DEVICE_WACOM(0xC4) },
+	{ USB_DEVICE_WACOM(0xC0) },
+	{ USB_DEVICE_WACOM(0xC2) },
+	{ USB_DEVICE_WACOM(0x03) },
+	{ USB_DEVICE_WACOM(0x41) },
+	{ USB_DEVICE_WACOM(0x42) },
+	{ USB_DEVICE_WACOM(0x43) },
+	{ USB_DEVICE_WACOM(0x44) },
+	{ USB_DEVICE_WACOM(0x45) },
+	{ USB_DEVICE_WACOM(0xB0) },
+	{ USB_DEVICE_WACOM(0xB1) },
+	{ USB_DEVICE_WACOM(0xB2) },
+	{ USB_DEVICE_WACOM(0xB3) },
+	{ USB_DEVICE_WACOM(0xB4) },
+	{ USB_DEVICE_WACOM(0xB5) },
+	{ USB_DEVICE_WACOM(0xB7) },
+	{ USB_DEVICE_WACOM(0xB8) },
+	{ USB_DEVICE_WACOM(0xB9) },
+	{ USB_DEVICE_WACOM(0xBA) },
+	{ USB_DEVICE_WACOM(0xBB) },
+	{ USB_DEVICE_WACOM(0x3F) },
+	{ USB_DEVICE_WACOM(0xC5) },
+	{ USB_DEVICE_WACOM(0xC6) },
+	{ USB_DEVICE_WACOM(0xC7) },
+	{ USB_DEVICE_WACOM(0x90) },
+	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x9A) },
+	{ USB_DEVICE_WACOM(0x9F) },
+	{ USB_DEVICE_WACOM(0xE2) },
+	{ USB_DEVICE_WACOM(0xE3) },
+	{ USB_DEVICE_WACOM(0x47) },
 	{ }
 };
-
-static struct usb_device_id wacom_ids[] = {
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x00) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x10) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x11) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x12) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x13) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x14) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x15) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x16) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x17) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x18) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x19) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x60) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x61) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x62) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x63) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x64) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x65) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x69) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x20) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x21) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x22) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x23) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x24) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x30) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x31) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x32) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x33) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x34) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x35) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x37) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x38) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x39) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC4) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC0) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x03) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x41) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x42) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x43) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x44) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x45) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB0) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB1) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB4) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB8) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB9) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBA) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBB) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x3F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC6) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x90) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x93) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9A) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x47) },
-	{ }
-};
-
-const struct usb_device_id *get_device_table(void)
-{
-        const struct usb_device_id *id_table = wacom_ids;
-
-        return id_table;
-}
-
-struct wacom_features * get_wacom_feature(const struct usb_device_id *id)
-{
-        int index = id - wacom_ids;
-        struct wacom_features *wf = &wacom_features[index];
-
-        return wf;
-}
-
 MODULE_DEVICE_TABLE(usb, wacom_ids);
