Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYE2SqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYE2SqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYE2SqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:46:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:1148 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYE2SqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eoKVVa2vbyLaQkmEJsYwUhG9L+gI2TaN9uAMRDpmYA8gKM05020JuWJNCuGrttD5YgTQTYrs50eo4xnfxyCGiDaw9Vz6U5yGZWSBd/Z5NlQDzECsfWsNoUJ1DkAAZGZbLPFamZGJlyOzdxxA32zK23ExH39prBefUZ8AUTwzqDc=
Date: Thu, 29 May 2008 14:46:06 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, jkosina@suse.cz
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] serio: add ifdef for i8042 build fix
Message-ID: <20080529184606.GA17728@anvil.corenet.prv>
References: <20080529182556.2994310a.sfr@canb.auug.org.au> <20080529094454.3605aa5c.randy.dunlap@oracle.com> <20080529095633.8893b4ec.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529095633.8893b4ec.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Thu, May 29, 2008 at 09:56:33AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Restrict variable usage by bounding it with ifdef/endif CONFIG_PNP.
> 
> linux-next-20080529/drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
> 

Thank you for the report. I'd rahther changed it as in the patch below.
What do you think?

If everyone agrees then I will fold it in Jiri's original patch to keep
the trees bisectable.

-- 
Dmitry

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 709c9d9..2289e3a 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -63,7 +63,7 @@ static inline void i8042_write_command(int val)
 	outb(val, I8042_COMMAND_REG);
 }
 
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 
 #include <linux/dmi.h>
 
@@ -287,6 +287,7 @@ static struct dmi_system_id __initdata i8042_dmi_nomux_table[] = {
 	{ }
 };
 
+#ifdef CONFIG_PNP
 static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
 	{
 		.ident = "Intel MBO Desktop D845PESV",
@@ -297,13 +298,8 @@ static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
 	},
 	{ }
 };
-
 #endif
 
-#ifdef CONFIG_X86
-
-#include <linux/dmi.h>
-
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -351,7 +347,6 @@ static struct dmi_system_id __initdata i8042_dmi_dritek_table[] = {
 
 #endif /* CONFIG_X86 */
 
-
 #ifdef CONFIG_PNP
 #include <linux/pnp.h>
 
@@ -461,6 +456,11 @@ static int __init i8042_pnp_init(void)
 	int pnp_data_busted = 0;
 	int err;
 
+#ifdef CONFIG_X86
+	if (dmi_check_system(i8042_dmi_nopnp_table))
+		i8042_nopnp = 1;
+#endif
+
 	if (i8042_nopnp) {
 		printk(KERN_INFO "i8042: PNP detection disabled\n");
 		return 0;
@@ -578,10 +578,6 @@ static int __init i8042_platform_init(void)
 	i8042_kbd_irq = I8042_MAP_IRQ(1);
 	i8042_aux_irq = I8042_MAP_IRQ(12);
 
-#if defined(__i386__) || defined(__x86_64__)
-	if (dmi_check_system(i8042_dmi_nopnp_table))
-		i8042_nopnp = 1;
-#endif
 	retval = i8042_pnp_init();
 	if (retval)
 		return retval;
@@ -590,15 +586,13 @@ static int __init i8042_platform_init(void)
         i8042_reset = 1;
 #endif
 
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_noloop_table))
 		i8042_noloop = 1;
 
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = 1;
-#endif
 
-#ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = 1;
 #endif /* CONFIG_X86 */
