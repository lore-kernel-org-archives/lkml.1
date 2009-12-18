Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZLRTw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZLRTw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbZLRTw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:52:56 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60618 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753847AbZLRTwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:52:55 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Fri, 18 Dec 2009 20:52:39 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911231359.54544.rusty@rustcorp.com.au>
In-Reply-To: <200911231359.54544.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5155
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912182052.42477.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009 04:29:53 Rusty Russell wrote:
> On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
> > The problem is that
> > scripts/mod/file2alias.c simply ignores isapnp.
>
> AFAICT it always has, and noone has complained until now.  Perhaps
> something was still reading /lib/modules/`uname -r`/modules.isapnpmap?
>
> Two things are required:
> 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
> 2) Expose the isapnp devices in sysfs where udev will match them up
>    (/sys/bus/isa/devices/<dev>/modalias I guess?)
>
> The first patches would look something like these.  We could mangle the
> PNP names a-la ISAPNP_VENDOR/ISAPNP_DEVICE, but as long as the published
> modalias matches the file2alias result, it doesn't matter.
>
> Jaroslav?  Greg?  Patches for sysfs welcome...
>
> Thanks,
> Rusty.
> PS.  Jon, perhaps the new decade is a good time to kill modules.*map?
>
> isapnp: move definitions to mod_devicetable.h so file2alias can reach them.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/include/linux/isapnp.h b/include/linux/isapnp.h
> --- a/include/linux/isapnp.h
> +++ b/include/linux/isapnp.h
> @@ -43,10 +43,10 @@
>   */
>
>  #ifdef __KERNEL__
> +#include <linux/mod_devicetable.h>
>
>  #define DEVICE_COUNT_COMPATIBLE 4
>
> -#define ISAPNP_ANY_ID		0xffff
>  #define ISAPNP_CARD_DEVS	8
>
>  #define ISAPNP_CARD_ID(_va, _vb, _vc, _device) \
> @@ -74,12 +74,6 @@ struct isapnp_card_id {
>  #define ISAPNP_DEVICE_SINGLE_END \
>  		.card_vendor = 0, .card_device = 0
>
> -struct isapnp_device_id {
> -	unsigned short card_vendor, card_device;
> -	unsigned short vendor, function;
> -	unsigned long driver_data;	/* data private to the driver */
> -};
> -
>  #if defined(CONFIG_ISAPNP) || (defined(CONFIG_ISAPNP_MODULE) &&
> defined(MODULE))
>
>  #define __ISAPNP__
> diff --git a/include/linux/mod_devicetable.h
> b/include/linux/mod_devicetable.h --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -474,4 +474,11 @@ struct platform_device_id {
>  			__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };
>
> +#define ISAPNP_ANY_ID		0xffff
> +struct isapnp_device_id {
> +	unsigned short card_vendor, card_device;
> +	unsigned short vendor, function;
> +	kernel_ulong_t driver_data;	/* data private to the driver */
> +};
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
>
>
> isapnp: put aliases in .modinfo so modinfo can find them.
>
> Once isa devices publish a modalias field, I think udev should "Just Work".
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -727,6 +727,19 @@ static int do_platform_entry(const char
>  	return 1;
>  }
>
> +/* Format is: isa:cvNcdNvNfN */
> +static int do_isapnp_entry(const char *filename,
> +			   struct isapnp_device_id *id, char *alias)
> +{
> +	strcpy(alias, "isa:");
> +	ADD(alias, "cv", id->card_vendor != ISAPNP_ANY_ID, id->card_vendor);
> +	ADD(alias, "cd", id->card_device != ISAPNP_ANY_ID, id->card_device);
> +	ADD(alias, "v", id->vendor != ISAPNP_ANY_ID, id->vendor);
> +	ADD(alias, "f", id->function, id->function);
> +	add_wildcard(alias);
> +	return 1;
> +}
> +
>  /* Ignore any prefix, eg. some architectures prepend _ */
>  static inline int sym_is(const char *symbol, const char *name)
>  {
> @@ -874,6 +887,10 @@ void handle_moddevtable(struct module *m
>  		do_table(symval, sym->st_size,
>  			 sizeof(struct platform_device_id), "platform",
>  			 do_platform_entry, mod);
> +	else if (sym_is(symname, "__mod_isapnp_device_table"))
> +		do_table(symval, sym->st_size,
> +			 sizeof(struct isapnp_device_id), "isa",
> +			 do_isapnp_entry, mod);
>  	free(zeros);
>  }

The above patch did not work. However, the patch below works fine (at least 
with Debian). It needs your first patch that moves the definitions to 
mod_devicetable.h. Verified that aliases for these modules are generated 
correctly:
drivers/media/radio/radio-sf16fmi.c
drivers/net/ne.c
drivers/net/3c515.c
drivers/net/smc-ultra.c
drivers/pcmcia/i82365.c
drivers/scsi/aha1542.c
drivers/scsi/aha152x.c
drivers/scsi/sym53c416.c
drivers/scsi/g_NCR5380.c

Tested with RTL8019AS (ne), AVA-1505AE (aha152x) and dtc436e (g_NCR5380) 
cards - they now work automatically.

Found that drivers/isdn/hisax/hisax_fcpcipnp.c has broken pnp device table - 
wrong type (isapnp instead of pnp) and also ending record missing.


Generate pnp:d aliases for isapnp_device_tables. This allows udev to load
these modules automatically.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.32-orig/scripts/mod/file2alias.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-source-2.6.32/scripts/mod/file2alias.c	2009-12-18 20:20:57.000000000 +0100
@@ -727,6 +727,19 @@ static int do_platform_entry(const char 
 	return 1;
 }
 
+/* looks like: "pnp:dD" */
+static int do_isapnp_entry(const char *filename,
+			   struct isapnp_device_id *id, char *alias)
+{
+	sprintf(alias, "pnp:d%c%c%c%x%x%x%x*",
+		'A' + ((id->vendor >> 2) & 0x3f) - 1,
+		'A' + (((id->vendor & 3) << 3) | ((id->vendor >> 13) & 7)) - 1,
+		'A' + ((id->vendor >> 8) & 0x1f) - 1,
+		(id->function >> 4) & 0x0f, id->function & 0x0f,
+		(id->function >> 12) & 0x0f, (id->function >> 8) & 0x0f);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -874,6 +887,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct platform_device_id), "platform",
 			 do_platform_entry, mod);
+	else if (sym_is(symname, "__mod_isapnp_device_table"))
+		do_table(symval, sym->st_size,
+			sizeof(struct isapnp_device_id), "isa",
+			do_isapnp_entry, mod);
 	free(zeros);
 }
 


hisax_fcpcipnp: fix broken isapnp device table.

--- linux-source-2.6.32-orig/drivers/isdn/hisax/hisax_fcpcipnp.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-source-2.6.32/drivers/isdn/hisax/hisax_fcpcipnp.c	2009-12-17 23:55:08.000000000 +0100
@@ -74,9 +74,10 @@ static struct pnp_device_id fcpnp_ids[] 
 		.id		= "AVM0900",
 		.driver_data	= (unsigned long) "Fritz!Card PnP",
 	},
+	{ .id = "" }
 };
 
-MODULE_DEVICE_TABLE(isapnp, fcpnp_ids);
+MODULE_DEVICE_TABLE(pnp, fcpnp_ids);
 #endif
 
 static int protocol = 2;       /* EURO-ISDN Default */


-- 
Ondrej Zary
