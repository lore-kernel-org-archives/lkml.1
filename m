Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbXFIKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbXFIKvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 06:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXFIKvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 06:51:12 -0400
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:4800 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbXFIKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 06:51:12 -0400
Date: Sat, 9 Jun 2007 12:52:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>, i2c@lm-sensors.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [i2c] i2c module aliases
Message-ID: <20070609125221.2a64ba48@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0706081647310.9505@anakin>
References: <Pine.LNX.4.64.0706062325270.30244@anakin>
	<20070607175342.3006e872@hyperion.delvare>
	<20070607160214.GB17800@kroah.com>
	<20070608153516.28fd9eb5@hyperion.delvare>
	<Pine.LNX.4.64.0706081647310.9505@anakin>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 16:48:45 +0200 (CEST), Geert Uytterhoeven wrote:
> On Fri, 8 Jun 2007, Jean Delvare wrote:
> > OK. Geert, care to submit a new patch removing struct i2c_device_id
> > altogether?
> 
> Sorry, probably not...
> 
> I just thought I found a grave bug while looking into adding zorro
> support to scripts/mod/file2alias.c, so that's why I reported it.

OK, no problem. I gave it a try myself. Greg, is it OK or did I miss
other parts which can be removed?

* * * * *

Subject: i2c: Kill struct i2c_device_id

I2C devices do not have any form of ID as PCI or USB devices have.
No driver uses "MODULE_DEVICE_TABLE(i2c, ...)" because it doesn't
make sense. So we can get rid of struct i2c_device_id and the
associated support code.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
---
 include/linux/mod_devicetable.h |    5 -----
 scripts/mod/file2alias.c        |   11 -----------
 2 files changed, 16 deletions(-)

--- linux-2.6.22-rc4.orig/include/linux/mod_devicetable.h	2007-05-13 10:01:23.000000000 +0200
+++ linux-2.6.22-rc4/include/linux/mod_devicetable.h	2007-06-08 19:08:29.000000000 +0200
@@ -255,11 +255,6 @@ struct pcmcia_device_id {
 #define PCMCIA_DEV_ID_MATCH_FAKE_CIS	0x0200
 #define PCMCIA_DEV_ID_MATCH_ANONYMOUS	0x0400
 
-/* I2C */
-struct i2c_device_id {
-	__u16 id;
-};
-
 /* Input */
 #define INPUT_DEVICE_ID_EV_MAX		0x1f
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
--- linux-2.6.22-rc4.orig/scripts/mod/file2alias.c	2007-06-08 18:56:36.000000000 +0200
+++ linux-2.6.22-rc4/scripts/mod/file2alias.c	2007-06-08 19:14:18.000000000 +0200
@@ -388,13 +388,6 @@ static int do_vio_entry(const char *file
 	return 1;
 }
 
-static int do_i2c_entry(const char *filename, struct i2c_device_id *i2c, char *alias)
-{
-	strcpy(alias, "i2c:");
-	ADD(alias, "id", 1, i2c->id);
-	return 1;
-}
-
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 static void do_input(char *alias,
@@ -571,10 +564,6 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct vio_device_id), "vio",
 			 do_vio_entry, mod);
-	else if (sym_is(symname, "__mod_i2c_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct i2c_device_id), "i2c",
-			 do_i2c_entry, mod);
 	else if (sym_is(symname, "__mod_input_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct input_device_id), "input",



-- 
Jean Delvare
