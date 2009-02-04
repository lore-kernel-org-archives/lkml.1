Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZBDBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZBDBO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBDBOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:14:51 -0500
Received: from fifo99.com ([67.223.236.141]:56796 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZBDBOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:14:50 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
In-Reply-To: <4988ABEE.6020703@ventoso.org>
References: <20090203172836.GA6964@elte.hu>
	 <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>
	 <4988ABEE.6020703@ventoso.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 17:14:40 -0800
Message-Id: <1233710080.15119.37.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 21:41 +0100, Luca Olivetti wrote:

> No, I don't have 2.6.28, but I guess that maybe once usb_register is
> called the dvb-usb subsystem asynchronously (is that an smp system?)
> starts polling the remote before the rc_decode function pointer has been
> initialized.
> Could you try to initialize it to NULL before calling usb_register?

What happens to the decode function when you have,

CONFIG_DVB_USB_AF9005=y
CONFIG_DVB_USB_AF9005_REMOTE=n

It seems that the decode function is defined inside,
drivers/media/dvb/dvb-usb/af9005-remote.c

but that doesn't get compiled in the case above. It looks like you end
up with af9005_rc_decode being a function local weak symbol
(uninitialized) which then gets assigned to rc_decode .. I think the
crash actually happens on rc_keys_size which get assigned another
uninitialized local, and it gets de-referenced .

Here's a patch I compile tested, and I think it would fix the issue.

--

The Afatech AF9005 uses some functions and variables from the optional
remote code. If the remote code is disabled it's possible the kernel
could crash while access the missing variables. This patch adds ifdefs
to remove any usage of the remote variables when the remote isn't
compiled.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>

diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index ca5a0a4..69b9b1b 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -41,11 +41,17 @@ MODULE_PARM_DESC(dump_eeprom, "dump contents of the eeprom.");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+#ifdef CONFIG_DVB_USB_AF9005_REMOTE
 /* remote control decoder */
 static int (*rc_decode) (struct dvb_usb_device *d, u8 *data, int len,
 		u32 *event, int *state);
 static void *rc_keys;
 static int *rc_keys_size;
+#else
+static inline int
+rc_decode(struct dvb_usb_device *d, u8 *data,
+	int len, u32 *event, int *state) { return 0; }
+#endif
 
 u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
 
@@ -1108,6 +1114,7 @@ static int __init af9005_usb_module_init(void)
 		err("usb_register failed. (%d)", result);
 		return result;
 	}
+#ifdef CONFIG_DVB_USB_AF9005_REMOTE
 	rc_decode = symbol_request(af9005_rc_decode);
 	rc_keys = symbol_request(af9005_rc_keys);
 	rc_keys_size = symbol_request(af9005_rc_keys_size);
@@ -1118,12 +1125,15 @@ static int __init af9005_usb_module_init(void)
 		af9005_properties.rc_key_map = rc_keys;
 		af9005_properties.rc_key_map_size = *rc_keys_size;
 	}
-
+#else
+	af9005_properties.rc_query = NULL;
+#endif
 	return 0;
 }
 
 static void __exit af9005_usb_module_exit(void)
 {
+#ifdef CONFIG_DVB_USB_AF9005_REMOTE 
 	/* release rc decode symbols */
 	if (rc_decode != NULL)
 		symbol_put(af9005_rc_decode);
@@ -1131,6 +1141,7 @@ static void __exit af9005_usb_module_exit(void)
 		symbol_put(af9005_rc_keys);
 	if (rc_keys_size != NULL)
 		symbol_put(af9005_rc_keys_size);
+#endif
 	/* deregister this driver from the USB subsystem */
 	usb_deregister(&af9005_usb_driver);
 }




