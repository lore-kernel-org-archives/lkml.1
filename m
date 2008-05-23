Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbYEWEoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbYEWEoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYEWEof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:44:35 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:31074 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYEWEod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=El3lD+pVQip8/ONgdLrpqjxc4kxfQD5bS2XIxkLHebiJ46sq8HQp1zPAPkg89m7LlAL758Lph9w17nscB/z2IKvJ4AGE1N6gBpsmjR1nbIt5/OXp92oxFZOVv2DI5TWzgf/i6j6k6l10YvUxxIzh2ceP3j1fsTv3y6BgVxpGNaU=
Date: Fri, 23 May 2008 00:44:30 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno Pr??mont <bonbons@linux-vserver.org>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080523044430.GA9809@anvil.corenet.prv>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080516163318.ZZRA012@mailhub.coreip.homeip.net> <200805162300.06027.bonbons@linux-vserver.org> <20080519114827.ZZRA012@mailhub.coreip.homeip.net> <20080519184501.38647a94@neptune.home> <20080521135345.ZZRA012@mailhub.coreip.homeip.net> <20080521220833.2e4345cb@neptune.home> <20080521163638.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080521163638.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 04:38:08PM -0400, Dmitry Torokhov wrote:
> 
> Ah, ok, great.. I think we simply need to move dritek out of the place
> where you put it in so it does not interfere with our efforts to
> resume keyboard and mouse ;) I will see what I can do there..
> 

So what about the patch below? Does it work for you?

Thanks!

-- 
Dmitry

From: Bruno Prémont <bonbons@linux-vserver.org>

Input: i8042 - make sure Dritek quirk is invoked at resume

Also do not fail i8042 entire initialization if enabling dritek extension
fails.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/i8042.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

Index: work/drivers/input/serio/i8042.c
===================================================================
--- work.orig/drivers/input/serio/i8042.c
+++ work/drivers/input/serio/i8042.c
@@ -885,6 +885,20 @@ static long i8042_panic_blink(long count
 
 #undef DELAY
 
+#ifdef CONFIG_X86
+static void i8042_dritek_enable(void)
+{
+	char param = 0x90;
+	int error;
+
+	error = i8042_command(&param, 0x1059);
+	if (error)
+		printk(KERN_WARNING
+			"Failed to enable DRITEK extension: %d\n",
+			error);
+}
+#endif
+
 #ifdef CONFIG_PM
 /*
  * Here we try to restore the original BIOS settings. We only want to
@@ -942,6 +956,12 @@ static int i8042_resume(struct platform_
 		return -EIO;
 	}
 
+
+#ifdef CONFIG_X86
+	if (i8042_dritek)
+		i8042_dritek_enable();
+#endif
+
 	if (i8042_mux_present) {
 		if (i8042_set_mux_mode(1, NULL) || i8042_enable_mux_ports())
 			printk(KERN_WARNING
@@ -1160,6 +1180,11 @@ static int __devinit i8042_probe(struct 
 	if (error)
 		return error;
 
+#ifdef CONFIG_X86
+	if (i8042_dritek)
+		i8042_dritek_enable();
+#endif
+
 	if (!i8042_noaux) {
 		error = i8042_setup_aux();
 		if (error && error != -ENODEV && error != -EBUSY)
@@ -1171,14 +1196,6 @@ static int __devinit i8042_probe(struct 
 		if (error)
 			goto out_fail;
 	}
-#ifdef CONFIG_X86
-	if (i8042_dritek) {
-		char param = 0x90;
-		error = i8042_command(&param, 0x1059);
-		if (error)
-			goto out_fail;
-	}
-#endif
 /*
  * Ok, everything is ready, let's register all serio ports
  *
